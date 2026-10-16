const fs=require('fs'),path=require('path');
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const root=path.resolve(__dirname,'../../..'),dir=path.join(root,'web/assets/selected-work/form/source');
 const browser=await chromium.launch({executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',headless:true});
 const page=await browser.newPage({deviceScaleFactor:1});let audit=[];
 for(const file of fs.readdirSync(dir).filter(f=>f.endsWith('.svg'))){
  const svg=fs.readFileSync(path.join(dir,file),'utf8'),m=svg.match(/width="(\d+)" height="(\d+)"/); const width=+m[1],height=+m[2];
  await page.setViewportSize({width,height});await page.setContent(`<style>html,body{margin:0}svg{display:block}</style>${svg}`);await page.evaluate(()=>document.fonts.ready);
  const overflow=await page.evaluate(()=>[...document.querySelectorAll('text')].filter(t=>{let r=t.getBoundingClientRect();return r.left<0||r.right>innerWidth||r.top<0||r.bottom>innerHeight}).map(t=>t.textContent));
  const output=path.join(dir,file.replace('.svg','.png'));await page.screenshot({path:output,omitBackground:true});audit.push({file,width,height,overflow});
 }
 await page.setViewportSize({width:700,height:260});await page.setContent(`<html><body style="background:#F1F0EA;font-family:Arial;color:#2D3331"><p>Wordmark at 192px; frame at 24px with context</p><img src="http://127.0.0.1:8797/assets/selected-work/form/source/wordmark.svg" width="192"><p><img src="http://127.0.0.1:8797/assets/selected-work/form/source/frame-mark.svg" height="24"> Form Architecture</p></body></html>`);await page.waitForFunction(()=>[...document.images].every(i=>i.complete));await page.screenshot({path:path.join(dir,'small-size-proof.png')});
 fs.writeFileSync(path.join(root,'docs/form/verification/identity-render-audit.json'),JSON.stringify(audit,null,2));await browser.close();console.log(JSON.stringify(audit));
})().catch(e=>{console.error(e);process.exit(1)});
