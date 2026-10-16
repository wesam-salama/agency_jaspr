import {createRequire} from 'node:module';
import {writeFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import assert from 'node:assert/strict';

const require=createRequire(import.meta.url);
const {chromium}=require(process.env.FRAME_PLAYWRIGHT||'/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const page=await browser.newPage({viewport:{width:1440,height:1000},reducedMotion:'reduce'});
const origin='http://127.0.0.1:8803';const output=resolve('docs/frame/verification/website');
const requests=[];const errors=[];const records=[];
page.on('request',request=>{if(new URL(request.url()).pathname.startsWith('/api/'))requests.push({method:request.method(),path:new URL(request.url()).pathname});});
page.on('pageerror',error=>errors.push(error.message));
for(const target of [
 {lang:'en',learner:'demo',route:'course/FA-PH-01',selector:'.detail-head',file:'course-decision-desktop-en.png',width:1440,scope:'Complete course decision section through its enrolment action; adjacent curriculum is outside the screenshot.'},
 {lang:'ar',learner:'demo-ar',route:'home',selector:'.hero',file:'home-hero-desktop-ar.png',width:1440,scope:'Complete Arabic home hero; adjacent course catalogue is outside the screenshot.'},
 {lang:'ar',learner:'demo-ar',route:'course/FA-PH-01',selector:'.detail-copy',file:'course-decision-mobile-ar.png',width:390,scope:'Complete Arabic mobile decision copy, prerequisite, equipment and action; ends in whitespace before the poster panel.'}
]) {
 await page.setViewportSize({width:target.width,height:1000});
 await page.goto(origin+`/assets/selected-work/frame/site/?learner=${target.learner}&lang=${target.lang}#${target.route}`);
 const section=page.locator(target.selector);await section.waitFor();await page.evaluate(()=>document.fonts.ready);
 await section.locator('img').evaluateAll(images=>Promise.all(images.map(image=>image.complete?Promise.resolve():new Promise((resolve,reject)=>{image.addEventListener('load',resolve,{once:true});image.addEventListener('error',reject,{once:true});}))));
 assert.ok(await section.locator('img').evaluateAll(images=>images.every(image=>image.complete&&image.naturalWidth>0)));
 let box=await section.boundingBox();assert.ok(box);
 if(box.height+48>1000)await page.setViewportSize({width:target.width,height:Math.ceil(box.height+48)});
 await section.scrollIntoViewIfNeeded();box=await section.boundingBox();assert.ok(box);
 const viewport=page.viewportSize();const x=Math.max(0,box.x-20);const y=Math.max(0,box.y-20);
 const clip={x,y,width:Math.min(viewport.width-x,box.width+40),height:Math.min(viewport.height-y,box.height+40)};
 assert.ok(clip.height>=box.height,'Complete section must fit in screenshot.');
 await page.screenshot({path:resolve(output,target.file),clip});
 records.push({...target,viewport,sectionSize:{width:box.width,height:box.height},captureSize:{width:clip.width,height:clip.height},method:'Actual Chrome section pixels with surrounding page margin; no hidden, altered or reconstructed interface content.'});
}
assert.deepEqual(errors,[]);assert.ok(requests.every(request=>request.method==='GET'));
await writeFile(resolve(output,'presentation-excerpts.json'),JSON.stringify({date:'2026-10-14',capturedAtUTC:new Date().toISOString(),records,apiRequests:requests,pageErrors:errors},null,2)+'\n');
await browser.close();process.stdout.write('Three clean actual website section excerpts captured; full-page proof screenshots preserved.\n');
