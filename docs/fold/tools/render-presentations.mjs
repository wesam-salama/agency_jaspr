import {chromium} from '/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright/index.mjs';
import {createRequire} from 'node:module';
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import {fileURLToPath,pathToFileURL} from 'node:url';
const sharp=createRequire(import.meta.url)('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/sharp');

const here=path.dirname(fileURLToPath(import.meta.url));
const source=path.join(here,'../presentation-sources');
const project=path.resolve(here,'../../..');
const assets=path.join(project,'web/assets/selected-work/fold');
const requested=process.argv.slice(2).filter(x=>!x.startsWith('--'));
const readyOnly=process.argv.includes('--ready');
const configs=[['card',1600,1000,'card.webp'],['hero',2560,1600,'hero.webp'],...['identity','continuity','measurements','shopping','maintenance'].map(n=>[n,2000,1500,`case/${n}.webp`])].filter(c=>!requested.length||requested.includes(c[0]));
const records=[];
if(configs.some(c=>c[0]==='maintenance')){
  for(const stage of ['before','after']){
    const input=path.join(here,`../verification/store/maintenance-${stage}-en.png`);
    if(fs.existsSync(input)){
      const output=path.join(source,`maintenance-${stage}-en-crop.png`);
      await sharp(input).extract({left:150,top:318,width:420,height:285}).png().toFile(output);
      fs.writeFileSync(output+'.json',JSON.stringify({origin:path.relative(project,input),operation:'Same exact browser screenshot crop to cart controls in both captures; no UI alteration',region:{left:150,top:318,width:420,height:285}},null,2)+'\n');
    }
  }
}
const browser=await chromium.launch({headless:true,channel:'chrome'});
try{
  for(const [name,width,height,relativeOutput] of configs){
    const file=path.join(source,name+'.html');
    const html=fs.readFileSync(file,'utf8');
    const deps=[...html.matchAll(/src="([^\"]+)"/g)].map(m=>path.resolve(source,m[1]));
    const missing=deps.filter(p=>!fs.existsSync(p));
    if(missing.length){if(readyOnly){console.log('Pending '+name+': '+missing.map(p=>path.basename(p)).join(', '));continue;}throw Error('Missing '+name+': '+missing.join(', '));}
    const page=await browser.newPage({viewport:{width,height},deviceScaleFactor:1,reducedMotion:'reduce'});
    await page.goto(pathToFileURL(file).href);
    await page.evaluate(()=>document.fonts.ready);
    const imageChecks=await page.locator('img').evaluateAll(imgs=>imgs.map(i=>({src:i.getAttribute('src'),loaded:i.complete&&i.naturalWidth>0})));
    if(imageChecks.some(i=>!i.loaded))throw Error('Unloaded image '+name);
    const png=path.join(source,name+'.png');
    await page.screenshot({path:png});
    const full=path.join(assets,relativeOutput);
    fs.mkdirSync(path.dirname(full),{recursive:true});
    await sharp(png).webp({quality:91}).toFile(full);
    const outputs=[full];
    for(const target of name==='card'||name==='hero'?[480,960]:[960]){
      const out=full.replace(/\.webp$/,`-${target}.webp`);
      await sharp(png).resize({width:target}).webp({quality:88}).toFile(out);outputs.push(out);
    }
    const provenance={origin:path.relative(project,file),operation:'Local Chrome capture of authored editable HTML presentation; photographic inputs and actual UI screenshots remain separate source records',sourceFiles:deps.map(p=>path.relative(project,p)),sourceFileChecksums:[file,path.join(source,'boards.css'),...deps].map(p=>({file:path.relative(project,p),sha256:crypto.createHash('sha256').update(fs.readFileSync(p)).digest('hex')})),generatedImageReferences:deps.filter(p=>p.includes('/products/')).map(p=>({file:path.relative(project,p),provenance:JSON.parse(fs.readFileSync(p+'.json','utf8'))})),created:'2026-10-15',capturedAt:new Date().toISOString(),creator:'CR8.Media / Codex authored presentation composition'};
    for(const out of [png,...outputs]){
      const info=await sharp(out).metadata();const sha256=crypto.createHash('sha256').update(fs.readFileSync(out)).digest('hex');
      const entry={...provenance,file:path.relative(project,out),width:info.width,height:info.height,sha256};
      fs.writeFileSync(out+'.json',JSON.stringify(entry,null,2)+'\n');records.push(entry);
    }
    await page.close();console.log('Rendered '+name+' '+width+'×'+height);
  }
}finally{await browser.close();}
const inventory=path.join(here,'../production/presentation-exports.json');
const previous=fs.existsSync(inventory)?JSON.parse(fs.readFileSync(inventory,'utf8')):[];
const names=new Set(records.map(r=>r.file));
fs.writeFileSync(inventory,JSON.stringify([...previous.filter(p=>!names.has(p.file)),...records],null,2)+'\n');
