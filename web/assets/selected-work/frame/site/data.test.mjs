import test from 'node:test';
import assert from 'node:assert/strict';
import {catalogue,lessonTitles,plannedMinutes,filterCourses,nextLesson,deepLink,copy,courseTitle} from './data.mjs';
test('catalogue filtering includes a recoverable empty combination',()=>{assert.equal(filterCourses().length,3);assert.equal(filterCourses('photography').length,1);assert.equal(filterCourses('all','intermediate').length,0);assert.equal(filterCourses('filmmaking','beginner')[0].id,'FA-FI-02');});
test('next lesson follows explicit completion without a viewing shortcut',()=>{assert.equal(nextLesson([]),'01');assert.equal(nextLesson(['01']),'02');assert.equal(nextLesson(['02']),'01');assert.equal(nextLesson(['01','02','03','04','05','06']),null);});
test('shared course canon and bilingual display preserve IDs',()=>{assert.equal(catalogue[0].title,'Composition Essentials');assert.equal(catalogue[0].lessons,6);assert.equal(plannedMinutes.reduce((a,b)=>a+b),62);assert.equal(lessonTitles[1],'Find the subject');assert.equal(courseTitle(catalogue[0],'ar'),'أساسيات التكوين');assert.ok(deepLink('demo-ar','ar').includes('learner=demo-ar&lang=ar'));});
test('Arabic includes every English functional key',()=>assert.deepEqual(Object.keys(copy.en).sort(),Object.keys(copy.ar).sort()));
