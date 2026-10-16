import {createRequire} from 'node:module';
import fs from 'node:fs';
import path from 'node:path';
import {execFileSync} from 'node:child_process';
const require=createRequire(import.meta.url);
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root=path.resolve(import.meta.dirname,'../../../..');
const source=path.join(root,'web/assets/selected-work/frame/source');
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const page=await browser.newPage({viewport:{width:800,height:1000},deviceScaleFactor:1});
async function settle(){await page.evaluate(async()=>{await document.fonts.ready;await Promise.all([...document.images].map(i=>i.complete?Promise.resolve():new Promise(r=>{i.onload=r;i.onerror=r})))})}
const covers=['composition-cover-ar','light-cover-ar','grids-cover-ar'];
for(const name of covers){
  await page.goto('file://'+path.join(source,name+'.svg'));await settle();
  await page.screenshot({path:path.join(source,name+'.png')});
  execFileSync('cwebp',['-quiet','-q','88',path.join(source,name+'.png'),'-o',path.join(source,name+'.webp')]);
}
const workbooks=['composition-workbook-ar','light-workbook-en','light-workbook-ar','grids-workbook-en','grids-workbook-ar'];
for(const name of workbooks){
  await page.goto('file://'+path.join(source,name+'.html'));await settle();
  await page.pdf({path:path.join(source,name+'.pdf'),printBackground:true,preferCSSPageSize:true,tagged:true});
}
await browser.close();
fs.writeFileSync(path.join(root,'docs/frame/verification/artwork/finish-review-fixes.json'),JSON.stringify({covers,workbooks,
  corrections:['Explicit RTL metadata embedding with the original right safe edge','Preview-only companion prompt footers no longer imply app completion'],
  boundaries:'English course fixtures, identity geometry and Composition completion instruction retained'},null,2)+'\n');
console.log(JSON.stringify({covers:covers.length,pdfs:workbooks.length}));
