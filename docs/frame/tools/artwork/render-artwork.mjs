import {createRequire} from 'node:module';import fs from 'node:fs';import path from 'node:path';
const require=createRequire(import.meta.url);
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const sharp=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp');
const root='/Users/wesamsalama/Desktop/Agency/website/agency_jaspr';
const asset=root+'/web/assets/selected-work/frame', source=asset+'/source';
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});const page=await browser.newPage({viewport:{width:1920,height:1080},deviceScaleFactor:1});
async function settle(){await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.complete?Promise.resolve():new Promise(r=>{i.onload=r;i.onerror=r})))})}
const report={source:'Authored editable SVG/HTML; actual browser-rendered proof',checks:[]};
await page.setViewportSize({width:1024,height:1024});await page.goto('file://'+source+'/frame-app-icon.svg');await settle();await page.screenshot({path:source+'/frame-app-icon-1024.png'});console.log('Native icon ready '+source+'/frame-app-icon-1024.png');
for(const lang of ['en','ar']){
const frames='/private/tmp/frame-film-'+lang;fs.mkdirSync(frames,{recursive:true});await page.setViewportSize({width:1920,height:1080});await page.goto('file://'+source+'/lesson-film.html?lang='+lang);await settle();
for(let f=0;f<150;f++){await page.evaluate(t=>window.setLessonTime(t),f/5);await settle();await page.screenshot({path:frames+'/'+String(f).padStart(4,'0')+'.png'});if(f===90){await page.screenshot({path:asset+'/media/poster'+(lang==='ar'?'-ar':'')+'.png'})}if(f%30===0)console.log('film '+lang+' '+f+'/150');}
report.checks.push({id:'film-'+lang,frames:150,sourceFps:5,outputFps:30,targetDurationSeconds:30,overflow:await page.evaluate(()=>({scrollWidth:document.documentElement.scrollWidth,clientWidth:document.documentElement.clientWidth}))});
}
await page.setViewportSize({width:2000,height:1500});await page.goto('file://'+source+'/identity-system.svg');await settle();await page.screenshot({path:source+'/identity-system.png'});console.log('Identity proof ready');
for(const file of fs.readdirSync(source).filter(f=>f.endsWith('.svg')&&!f.startsWith('identity-system'))){const text=fs.readFileSync(source+'/'+file,'utf8');const size=text.match(/width="(\d+)" height="(\d+)"/);await page.setViewportSize({width:Number(size?.[1]||800),height:Number(size?.[2]||1000)});await page.goto('file://'+source+'/'+file);await settle();await page.screenshot({path:source+'/'+file.replace('.svg','.png')});report.checks.push({id:file,rendered:true});}
fs.writeFileSync(root+'/docs/frame/verification/artwork/render-audit.json',JSON.stringify(report,null,2));
await browser.close();console.log('Asset render complete');
