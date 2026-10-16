import test from 'node:test';
import assert from 'node:assert/strict';
import { DEFAULT_PROJECTS, cloneProjects, validateProject, loadProjects, saveProjects, STORAGE_KEY } from './data.js';
import { validateEnquiry } from './app.js';

test('canonical bilingual studies have valid publishing records and exact fixture facts', () => {
  assert.deepEqual(DEFAULT_PROJECTS.map(p => [p.slug, p.year, p.area]), [['courtyard-house',2025,'240 m²'],['line-studio',2026,'180 m²'],['shore-library',2026,'620 m²']]);
  for (const project of DEFAULT_PROJECTS) assert.deepEqual(validateProject(project,DEFAULT_PROJECTS),{});
});
test('publishing rejects duplicate slugs, misleading status, missing imagery and empty stories', () => {
  const projects=cloneProjects(DEFAULT_PROJECTS);
  projects[0].slug=projects[1].slug;
  assert.match(validateProject(projects[0],projects).slug,/already/);
  projects[0].slug='courtyard-house';projects[0].status='Built project';projects[0].images=[];projects[0].sections=[];
  const errors=validateProject(projects[0],projects);
  assert.ok(errors.status);assert.ok(errors.images);assert.ok(errors.sections);
  assert.throws(()=>saveProjects(projects),/Studio concept/);
});
test('publishing rejects extreme crop coordinates, missing Arabic and unbounded text', () => {
  const projects=cloneProjects(DEFAULT_PROJECTS);const p=projects[0];
  p.title.en='x'.repeat(101);p.title.ar='';p.images[0].focal.mobile.x=101;p.sections[0].body.en='x'.repeat(3001);
  const errors=validateProject(p,projects);
  assert.ok(errors['title.en']);assert.ok(errors['title.ar']);assert.ok(errors['images.0.focal.mobile.x']);assert.ok(errors['sections.0.body.en']);
});
test('published data round trips; corrupt or invalid saved content falls back to canonical records', () => {
  const store=new Map();globalThis.localStorage={getItem:key=>store.get(key)||null,setItem:(key,value)=>store.set(key,value)};
  const projects=cloneProjects(DEFAULT_PROJECTS);projects[0].title.en='Courtyard House — light and privacy';
  saveProjects(projects);assert.equal(loadProjects()[0].title.en,projects[0].title.en);
  store.set(STORAGE_KEY,'{');assert.deepEqual(loadProjects(),DEFAULT_PROJECTS);
  store.set(STORAGE_KEY,JSON.stringify([{slug:'unsafe'}]));assert.deepEqual(loadProjects(),DEFAULT_PROJECTS);
  delete globalThis.localStorage;
});
test('enquiry validation preserves values and names the first missing field in both languages', () => {
  const draft={name:'',email:'bad',type:'',location:'',outline:'Short'};const before=JSON.stringify(draft);
  assert.equal(Object.keys(validateEnquiry(draft))[0],'name');assert.ok(validateEnquiry(draft,'ar').name);assert.equal(JSON.stringify(draft),before);
});
test('enquiry supports uncertainty while bounding a useful outline and checking email syntax', () => {
  const draft={name:'Demo visitor',email:'demo@example.com',type:'residential',location:'Mediterranean study',outline:'We are exploring a home around a planted courtyard.',area:'',budget:'undecided',timing:'undecided'};
  assert.deepEqual(validateEnquiry(draft),{});
  assert.ok(validateEnquiry({...draft,email:'name@domain'}).email);
  assert.ok(validateEnquiry({...draft,outline:'x'.repeat(2001)}).outline);
  assert.deepEqual(validateEnquiry({...draft,outline:'x'.repeat(2000)}),{});
});
