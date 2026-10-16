import { chromium } from '/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../../../web/assets/selected-work/fold');
const output = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../verification/identity');
fs.mkdirSync(output,{recursive:true});
const browser=await chromium.launch({headless:true,channel:'chrome'});
const checks=[];
try {
  for(const file of ['identity-board.html','packaging-board.html']){
    const page=await browser.newPage({viewport:{width:2000,height:1500},deviceScaleFactor:1});
    await page.goto(pathToFileURL(path.join(root,'source',file)).href);
    await page.evaluate(()=>document.fonts.ready);
    await page.screenshot({path:path.join(output,file.replace('.html','.png'))});
    checks.push({surface:file,width:2000,fonts:await page.evaluate(()=>[...document.fonts].map(f=>({family:f.family,status:f.status}))),images:await page.locator('img').evaluateAll(imgs=>imgs.every(img=>img.complete&&img.naturalWidth>0))});
    await page.close();
  }
  for(const width of [390,1440]){
    const page=await browser.newPage({viewport:{width,height:1000},deviceScaleFactor:1});
    await page.goto(pathToFileURL(path.join(root,'source','fold-brand-guide.html')).href);
    await page.evaluate(()=>document.fonts.ready);
    await page.screenshot({path:path.join(output,`guide-${width}.png`),fullPage:true});
    checks.push({surface:'brand-guide',width,overflow:await page.evaluate(()=>document.documentElement.scrollWidth-innerWidth),fonts:await page.evaluate(()=>[...document.fonts].map(f=>({family:f.family,status:f.status}))),images:await page.locator('img').evaluateAll(imgs=>imgs.every(img=>img.complete&&img.naturalWidth>0))});
    await page.close();
  }
} finally {await browser.close();}
fs.writeFileSync(path.join(output,'checks.json'),JSON.stringify(checks,null,2)+'\n');
console.log(JSON.stringify(checks));
