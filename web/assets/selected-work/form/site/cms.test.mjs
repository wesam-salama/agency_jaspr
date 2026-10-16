import test from 'node:test';
import assert from 'node:assert/strict';
import { DEFAULT_PROJECTS, cloneProjects, validateProject, saveProjects, loadProjects, STORAGE_KEY } from './data.js';
import { moveSection, removeProjectImage, updateField } from './cms.js';

const fixtures = () => cloneProjects(DEFAULT_PROJECTS);
test('story reorder keeps bilingual explanation and its image relation together',()=>{
  const [project]=fixtures(), before=JSON.stringify(project.sections[0]);
  assert.equal(moveSection(project,0,1),true);
  assert.equal(JSON.stringify(project.sections[1]),before);
  assert.equal(moveSection(project,0,-1),false);
  assert.deepEqual(Object.keys(validateProject(project,fixtures())),[]);
});
test('removing an image preserves story text and blocks a now missing chapter image',()=>{
  const projects=fixtures(), p=projects[0], story=JSON.stringify(p.sections);
  assert.equal(removeProjectImage(p,1),true);
  assert.equal(JSON.stringify(p.sections),story);
  assert.match(validateProject(p,projects)['sections.0.imageId'],/existing image/);
});
test('nested focal controls preserve the other viewport and numeric values',()=>{
  const [p]=fixtures(), mobile=JSON.stringify(p.images[0].focal.mobile);
  updateField(p,'images.0.focal.desktop.x','37');
  assert.equal(p.images[0].focal.desktop.x,37);
  assert.equal(JSON.stringify(p.images[0].focal.mobile),mobile);
  updateField(p,'year','2026');assert.equal(p.year,2026);
});
test('publishing rejects empty galleries, duplicate slugs, misleading status and oversized title',()=>{
  const projects=fixtures(), p=projects[0];
  p.images=[];assert.ok(validateProject(p,projects).images);
  p.slug=projects[1].slug;assert.ok(validateProject(p,projects).slug);
  p.status='Built project';assert.ok(validateProject(p,projects).status);
  p.title.en='A'.repeat(101);assert.ok(validateProject(p,projects)['title.en']);
});
test('a long permitted title and missing optional area remain publishable',()=>{
  const projects=fixtures(), p=projects[0];
  p.title.en='Courtyard House — '.padEnd(100,'a');p.area='';
  assert.deepEqual(validateProject(p,projects),{});
});
test('published local data round-trips and blocked storage leaves the original untouched',()=>{
  const memory=new Map();globalThis.localStorage={getItem:key=>memory.get(key)||null,setItem:(key,value)=>memory.set(key,value)};
  const projects=fixtures();projects[0].summary.en='A planted court connects light, privacy, and everyday movement.';
  saveProjects(projects);assert.equal(loadProjects()[0].summary.en,projects[0].summary.en);
  const original=memory.get(STORAGE_KEY);globalThis.localStorage.setItem=()=>{throw new Error('Storage blocked');};
  assert.throws(()=>saveProjects(fixtures()),/Storage blocked/);assert.equal(memory.get(STORAGE_KEY),original);
  delete globalThis.localStorage;
});
