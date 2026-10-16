const fs = require('fs');
const path = require('path');
const { chromium } = require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const root = path.resolve(__dirname, '../../..');
const source = path.join(root, 'web/assets/selected-work/sift/source');
const requested = process.argv.slice(2);
(async()=>{
  const browser = await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
  const page = await browser.newPage({deviceScaleFactor:1});
  const files = requested.length ? requested : fs.readdirSync(source).filter(f=>f.endsWith('.svg'));
  const result=[];
  for(const file of files){
    const src=fs.readFileSync(path.join(source,file),'utf8');
    const dim=src.match(/<svg[^>]*width="(\d+)" height="(\d+)"/);
    const width=Number(dim[1]),height=Number(dim[2]);
    await page.setViewportSize({width,height});
    await page.setContent(`<html><head><style>html,body{margin:0;padding:0;background:transparent}svg{display:block}</style></head><body>${src}</body></html>`);
    await page.evaluate(async()=>{await document.fonts.ready; for(const font of ['24px Manrope','24px Fraunces','24px PlexArabic']) await document.fonts.load(font);});
    const fontStatus=await page.evaluate(()=>({fraunces:document.fonts.check('24px Fraunces'),manrope:document.fonts.check('24px Manrope'),arabic:document.fonts.check('24px PlexArabic')}));
    const overflow=await page.evaluate(()=>[...document.querySelectorAll('text')].filter(t=>{const r=t.getBoundingClientRect(); return r.left < -1 || r.top < -1 || r.right > innerWidth+1 || r.bottom > innerHeight+1;}).map(t=>t.textContent));
    const output=path.join(source,file.replace(/\.svg$/,'.png'));
    await page.screenshot({path:output,omitBackground:true});
    result.push({file,output,width,height,fontStatus,overflow});
  }
  await browser.close();
  const auditPath=path.join(source,'render-audit.json');
  const previous=requested.length && fs.existsSync(auditPath) ? JSON.parse(fs.readFileSync(auditPath,'utf8')) : [];
  const byFile=new Map(previous.map(r=>[r.file,r]));
  for(const rec of result) byFile.set(rec.file,rec);
  fs.writeFileSync(auditPath,JSON.stringify([...byFile.values()].sort((a,b)=>a.file.localeCompare(b.file)),null,2)+'\n');
  console.log(JSON.stringify(result,null,2));
})().catch(e=>{console.error(e);process.exit(1)});
