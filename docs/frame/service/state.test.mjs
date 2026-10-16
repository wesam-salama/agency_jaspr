import test from 'node:test';
import assert from 'node:assert/strict';
import {mkdtemp,readFile,rm} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {DemoStore,initialSession,validateLearner,validateDraft} from './state.mjs';
import {courses,lessons} from './catalogue.mjs';

test('canon keeps exact titles, lesson targets, and zero initial progress',()=>{
 assert.deepEqual(courses.map(c=>c.title),['Composition Essentials','Light for Motion','Designing with Grids']);
 assert.equal(lessons.reduce((sum,l)=>sum+l.plannedMinutes,0),62);
 assert.equal(courses[0].actualPreviewSeconds,30);
 assert.deepEqual(initialSession().completed,[]);
 assert.deepEqual(initialSession().enrolments,[]);
});
test('confirmed writes survive a new store and retain learner isolation',async()=>{
 const folder=await mkdtemp(join(tmpdir(),'frame-store-'));const file=join(folder,'sessions.json');
 try {
  const store=new DemoStore(file);await store.load();
  await store.mutate('demo','enrol',{courseId:'FA-PH-01'});
  const draft={lessonId:'01',note:'The edge gives the object more space.',attachment:true};
  const saved=await store.mutate('demo','draft',draft);assert.equal(saved.completed.length,0);
  const complete=await store.mutate('demo','complete',draft);assert.deepEqual(complete.completed,['01']);
  const restarted=new DemoStore(file);await restarted.load();assert.deepEqual(restarted.session('demo'),complete);
  assert.deepEqual(restarted.session('demo-ar').completed,[]);
  assert.equal(restarted.session('demo').drafts['01'].note,draft.note);
 }finally {await rm(folder,{recursive:true,force:true});}
});
test('controlled failure preserves stored draft and successful retry completes once',async()=>{
 const folder=await mkdtemp(join(tmpdir(),'frame-recovery-'));const file=join(folder,'sessions.json');
 try {
  const store=new DemoStore(file);await store.mutate('demo','enrol',{});
  const draft={lessonId:'01',note:'First draft',attachment:false};await store.mutate('demo','draft',draft);
  const revision=store.session('demo').revision;const before=await readFile(file,'utf8');
  store.failure.add('demo');const retained={...draft,note:'Retained locally during failure'};
  await assert.rejects(store.mutate('demo','complete',retained),error=>error.status===503);
  assert.equal(await readFile(file,'utf8'),before);assert.equal(store.session('demo').revision,revision);
  const success=await store.mutate('demo','complete',retained);assert.equal(success.drafts['01'].note,retained.note);
  await store.mutate('demo','complete',retained);assert.deepEqual(store.session('demo').completed,['01']);
 }finally {await rm(folder,{recursive:true,force:true});}
});
test('concurrent queued mutations do not lose separate learner changes',async()=>{
 const folder=await mkdtemp(join(tmpdir(),'frame-concurrency-'));try {
  const store=new DemoStore(join(folder,'sessions.json'));
  await Promise.all([store.mutate('demo','enrol',{}),store.mutate('demo-ar','enrol',{})]);
  await Promise.all([store.mutate('demo','draft',{lessonId:'01',note:'English',attachment:false}),store.mutate('demo-ar','draft',{lessonId:'01',note:'العربية',attachment:false})]);
  assert.equal(store.session('demo').drafts['01'].note,'English');assert.equal(store.session('demo-ar').drafts['01'].note,'العربية');
 }finally {await rm(folder,{recursive:true,force:true});}
});
test('exercise cannot save before enrolment and input validation is bounded',async()=>{
 assert.equal(validateLearner('../../private'),false);assert.equal(validateLearner('demo-ar'),true);
 assert.equal(validateDraft({lessonId:'01',note:'x',attachment:false}),true);
 assert.equal(validateDraft({lessonId:'07',note:'x',attachment:false}),false);
 assert.equal(validateDraft({lessonId:'01',note:'x'.repeat(4001),attachment:false}),false);
 const store=new DemoStore('/unused');await assert.rejects(store.mutate('demo','draft',{lessonId:'01',note:'x',attachment:false}),error=>error.status===409);
});
