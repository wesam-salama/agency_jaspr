import {createRequire} from 'node:module';
import {mkdir,writeFile,readFile} from 'node:fs/promises';
import {resolve} from 'node:path';
import assert from 'node:assert/strict';
process.env.PLAYWRIGHT_BROWSERS_PATH='/private/tmp/frame-playwright';
const require=createRequire(import.meta.url);
const {chromium}=require(process.env.FRAME_PLAYWRIGHT||'/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const origin='http://127.0.0.1:8803';const url=origin+'/assets/selected-work/frame/site/';
const output=resolve('docs/frame/verification/website');await mkdir(output,{recursive:true});
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const records=[];
const languages=process.env.FRAME_CAPTURE_LANG?[process.env.FRAME_CAPTURE_LANG]:['en','ar'];
assert.ok(languages.every(lang=>lang==='en'||lang==='ar'));
for(const lang of languages) {
 const learner=lang==='ar'?'demo-ar':'demo';
 const context=await browser.newContext({viewport:{width:1440,height:1000},recordVideo:{dir:output,size:{width:1440,height:1000}}});
 const page=await context.newPage();
 const reset=await page.request.post(origin+'/api/test/reset',{data:{learner}});assert.ok(reset.ok());
 await page.goto(url+`?lang=${lang}&learner=${learner}#courses`);
 await page.locator('.course-card').first().waitFor();await page.evaluate(()=>document.fonts.ready);
 await page.screenshot({path:resolve(output,`catalogue-${lang}.png`),fullPage:true});
 await page.waitForTimeout(1000);
 await page.locator('.course-caption h3 a').first().click();await page.locator('.detail-copy h1').waitFor();
 await page.screenshot({path:resolve(output,`course-detail-desktop-${lang}.png`),fullPage:true});
 await page.waitForTimeout(1000);
 await page.locator('[data-action="preview"]').first().click();await page.locator('video').evaluate(video=>new Promise((resolve,reject)=>{if(video.readyState>=1)resolve();else{video.addEventListener('loadedmetadata',resolve,{once:true});video.addEventListener('error',reject,{once:true});}}));
 const media=await page.locator('video').evaluate(async video=>{video.textTracks[0].mode='showing';await video.play();return {duration:video.duration,autoplay:video.autoplay,tracks:video.textTracks.length};});
 assert.equal(media.duration,30);assert.equal(media.autoplay,false);assert.equal(media.tracks,2);
 await page.waitForFunction(()=>document.querySelector('video').currentTime>3);
 await page.screenshot({path:resolve(output,`lesson-preview-${lang}.png`)});
 await page.locator('[data-action="close-preview"]').click();
 await page.locator('.detail-copy .button').click();await page.locator('[data-action="enrol"]').click();
 await page.locator('.handoff .button').waitFor();
 assert.equal(await page.locator('[role="progressbar"]').getAttribute('aria-valuenow'),'0');
 const link=await page.locator('.handoff .button').getAttribute('href');assert.equal(link,`frameacademy://course/FA-PH-01?learner=${learner}&lang=${lang}`);
 await page.screenshot({path:resolve(output,`enrolment-zero-${lang}.png`),fullPage:true});
 await page.waitForTimeout(2000);
 await page.locator('.handoff .button').focus();await page.keyboard.press('Enter');
 await page.locator('#handoff-feedback').filter({hasText:lang==='ar'?'تم إرسال طلب فتح التطبيق.':'App open request sent.'}).waitFor();
 await page.screenshot({path:resolve(output,`handoff-request-${lang}.png`),fullPage:true});
 await page.waitForTimeout(2000);
 records.push({lang,learner,course:'FA-PH-01',title:'Composition Essentials',initialComplete:0,link,media,requestSent:true,nativeConfirmation:'If iOS requests confirmation, the learner chooses Open; native acceptance is recorded separately.'});
 await context.close();await page.video().saveAs(resolve(output,`handoff-${lang}.webm`));
 process.stdout.write(`${lang} final handoff captured; ${learner} enrolled at0/6.\n`);
}
const context=await browser.newContext({viewport:{width:1440,height:1000},reducedMotion:'reduce'});
const page=await context.newPage();
for(const lang of languages)for(const width of [1440,390]) {
 await page.setViewportSize({width,height:1000});
 await page.goto(url+`?lang=${lang}&learner=${lang==='ar'?'demo-ar':'demo'}#home`);await page.locator('h1').waitFor();await page.evaluate(()=>document.fonts.ready);
 await page.screenshot({path:resolve(output,`${width===1440?'desktop':'mobile'}-${lang}.png`),fullPage:true});
 await page.goto(url+`?lang=${lang}&learner=${lang==='ar'?'demo-ar':'demo'}#course/FA-PH-01`);await page.locator('.detail-copy h1').waitFor();await page.evaluate(()=>document.fonts.ready);
 await page.screenshot({path:resolve(output,`course-detail-${width===1440?'desktop':'mobile'}-${lang}.png`),fullPage:true});
}
const record={date:'2026-10-14',platform:'Actual headless Chrome with real locally served website and acknowledged xcrun iPhone simulator request',records};
if(languages.length===1) {
 await writeFile(resolve(output,`capture-record-${languages[0]}.json`),JSON.stringify(record,null,2)+'\n');
 try {const english=JSON.parse(await readFile(resolve(output,'capture-record-en.json'),'utf8'));const arabic=JSON.parse(await readFile(resolve(output,'capture-record-ar.json'),'utf8'));await writeFile(resolve(output,'capture-record.json'),JSON.stringify({...record,records:[...english.records,...arabic.records]},null,2)+'\n');}catch {}
}else await writeFile(resolve(output,'capture-record.json'),JSON.stringify(record,null,2)+'\n');
await context.close();await browser.close();process.stdout.write('EN/AR handoff recordings and desktop/mobile screenshots captured.\n');
