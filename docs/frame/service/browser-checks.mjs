import {createRequire} from 'node:module';
import {mkdir,writeFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import assert from 'node:assert/strict';
const require=createRequire(import.meta.url);
const {chromium}=require(process.env.FRAME_PLAYWRIGHT||'/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const origin='http://127.0.0.1:8803';
const url=origin+'/assets/selected-work/frame/site/';
const output=resolve('docs/frame/verification/website');await mkdir(output,{recursive:true});
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const checks=[];
const errors=[];
const context=await browser.newContext({viewport:{width:1440,height:1000},reducedMotion:'reduce'});
const page=await context.newPage();page.on('pageerror',error=>errors.push(error.message));
async function api(path,body) {const response=await page.request.post(origin+'/api/'+path,{data:{learner:'demo-web-test',...body}});assert.ok(response.ok(),path);return response.json();}
async function log(label,fn) {await fn();checks.push({check:label,result:'passed'});process.stdout.write('PASS '+label+'\n');}
await api('test/reset',{});
await log('Catalogue loading is visible until response; filters preserve an empty result and clear restores three',async()=>{
 let release;const hold=new Promise(resolve=>release=resolve);
 await page.route('**/api/catalogue',async route=>{await hold;await route.continue();});
 await page.goto(url+'?learner=demo-web-test#courses',{waitUntil:'commit'});
 await page.getByRole('heading',{name:'Loading the course catalogue…'}).waitFor();
 release();await page.locator('.course-card').first().waitFor();await page.unroute('**/api/catalogue');
 assert.equal(await page.locator('.course-card').count(),3);
 await page.locator('select[name="level"]').selectOption('intermediate');
 await page.getByRole('heading',{name:'No courses match these filters.'}).waitFor();
 assert.equal(await page.locator('select[name="level"]').inputValue(),'intermediate');
 await page.locator('[data-action="clear"]').first().click();assert.equal(await page.locator('.course-card').count(),3);
});
await log('Catalogue failure keeps filters and retry restores content',async()=>{
 await page.locator('select[name="discipline"]').selectOption('photography');
 await page.locator('.demo-checks summary').click();await page.locator('[data-action="error"]').click();
 await page.getByRole('heading',{name:'The catalogue couldn’t load. Your filters are still here.'}).waitFor();
 assert.equal(await page.locator('select[name="discipline"]').inputValue(),'photography');
 await page.locator('[data-action="retry-catalogue"]').click();await page.locator('.course-card').waitFor();assert.equal(await page.locator('.course-card').count(),1);
});
await log('Course decision exposes outcome, prerequisite and equipment before enrolment',async()=>{
 await page.locator('.course-caption h3 a').click();
 await page.getByRole('heading',{name:'Composition Essentials',exact:true}).waitFor();
 const text=await page.locator('main').innerText();assert.ok(text.indexOf('What you’ll make')<text.indexOf('Try Composition Essentials'));
 assert.ok(text.includes('No prior course required.'));assert.ok(text.includes('A phone or camera, one object and available light.'));
});
await log('Preview closes with Escape to origin; no viewing completion or autoplay',async()=>{
 await page.locator('[data-action="preview"]').first().focus();await page.keyboard.press('Enter');
 assert.equal(await page.locator('dialog').evaluate(el=>el.open),true);
 assert.equal(await page.locator('video').evaluate(el=>el.autoplay),false);
 await page.keyboard.press('Escape');assert.equal(await page.evaluate(()=>document.activeElement.dataset.action),'preview');
 const record=await page.request.get(origin+'/api/session?learner=demo-web-test');assert.equal((await record.json()).completed.length,0);
});
await log('Enrolment confirms shared persistence and language switching preserves learner',async()=>{
 await page.locator('.detail-copy .button').click();await page.locator('[data-action="enrol"]').click();
 await page.getByRole('heading',{name:'Your demo course is ready.'}).waitFor();
 assert.equal(await page.locator('.record-progress [role="progressbar"]').getAttribute('aria-valuenow'),'0');
 assert.match(await page.locator('.handoff .button').getAttribute('href'),/learner=demo-web-test&lang=en/);
 await page.locator('[data-action="language"]').click();assert.equal(await page.locator('html').getAttribute('dir'),'rtl');
 assert.match(await page.locator('.handoff .button').getAttribute('href'),/learner=demo-web-test&lang=ar/);
 assert.equal(await page.locator('.learner-code bdi').innerText(),'demo-web-test');
});
await log('Confirmed exercise draft and explicit completion appear on website; refreshed record points to02',async()=>{
 await api('draft',{lessonId:'01',note:'The second photograph gives the object more breathing room.',attachment:true});
 await api('complete',{lessonId:'01',note:'The second photograph gives the object more breathing room.',attachment:true});
 await page.locator('[data-action="refresh"]').click();await page.locator('#enrol-feedback').filter({hasText:'تم تحديث السجلّ المشترك.'}).waitFor();
 assert.equal(await page.locator('[role="progressbar"]').getAttribute('aria-valuenow'),'1');
 assert.equal(await page.locator('.record-next h3 bdi').innerText(),'02');
 assert.ok((await page.locator('.practice-note').innerText()).includes('breathing room'));
});
await log('Missing preview is readable and Retry restores the actual player',async()=>{
 await page.locator('.demo-checks summary').click();await page.locator('[data-action="missing"]').click();
 await page.getByRole('heading',{name:'هذه المعاينة غير متاحة.'}).waitFor();
 await page.locator('[data-action="retry-preview"]').click();assert.equal(await page.locator('video').count(),1);await page.keyboard.press('Escape');
});
await log('Local app handoff confirms its response and retains URL/code after controlled failure',async()=>{
 await page.route('**/api/handoff',route=>route.fulfill({status:503,contentType:'application/json',body:JSON.stringify({error:'Controlled unavailable simulator'})}));
 await page.locator('.handoff [data-action="handoff"]').click();
 await page.locator('#handoff-feedback').filter({hasText:'تعذّر فتح المحاكي المحلي.'}).waitFor();
 assert.match(await page.locator('.handoff .text-link').getAttribute('href'),/learner=demo-web-test&lang=ar/);
 assert.equal(await page.locator('[role="progressbar"]').getAttribute('aria-valuenow'),'1');
 await page.unroute('**/api/handoff');
 await page.route('**/api/handoff',route=>route.fulfill({status:200,contentType:'application/json',body:JSON.stringify({requestSent:true})}));
 await page.locator('.handoff [data-action="handoff"]').click();
 await page.locator('#handoff-feedback').filter({hasText:'تم إرسال طلب فتح التطبيق.'}).waitFor();
 await page.unroute('**/api/handoff');
});
await log('Responsive EN/AR five-view layouts at320/390/768/1440 with readable mixed scripts',async()=>{
 for(const language of ['en','ar'])for(const width of [320,390,768,1440])for(const view of ['home','courses','course/FA-PH-01','how','enrol']) {
  await page.setViewportSize({width,height:1000});await page.goto(url+`?learner=demo-web-test&lang=${language}#${view}`);await page.locator('h1').waitFor();await page.evaluate(()=>document.fonts.ready);
  assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1),`${language} ${width} ${view} overflows`);
  if(view==='course/FA-PH-01') {assert.equal(await page.locator('.decision-facts dt').count(),3);}
 }
});
await log('Text expansion and reduced motion maintain actions and natural wrapping',async()=>{
 await page.setViewportSize({width:390,height:1000});await page.goto(url+'?learner=demo-web-test&lang=ar#course/FA-PH-01');
 await page.addStyleTag({content:'body{font-size:200%}h1{font-size:64px!important}.button,.text-link,.metadata{font-size:24px!important}'});
 assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth+1));
 assert.equal(await page.locator('.button').first().evaluate(el=>getComputedStyle(el).transitionDuration),'0s');
});
assert.deepEqual(errors,[]);
await writeFile(resolve('docs/frame/verification/web-checks.json'),JSON.stringify({date:'2026-10-14',platform:'Chromium local desktop browser',learner:'demo-web-test',checks,pageErrors:errors,scope:'Final confirmation after responsive poster sizing, corrected EN/AR media, stale-read guard and local simulator bridge. Handoff UI failure/success uses controlled responses; actual bridge execution is recorded separately.'},null,2)+'\n');
await context.close();await browser.close();
process.stdout.write(`${checks.length} browser groups passed; docs/frame/verification/web-checks.json\n`);
