const fs = require('fs');
const path = require('path');
const http = require('http');
const { execFileSync } = require('child_process');
const runtime = '/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies';
const { chromium } = require(path.join(runtime, 'node/node_modules/playwright'));
const repo = path.resolve(__dirname, '../../../..');
const web = path.join(repo, 'web');
const guidePath = '/assets/selected-work/sift/sift-brand-guide.html';
const output = path.join(web, 'assets/selected-work/sift/sift-brand-guide.pdf');
const guide = path.join(repo, 'docs/sift/guide');
const proofs = path.join(guide, 'proofs');
const mime = {'.html':'text/html','.svg':'image/svg+xml','.ttf':'font/ttf','.woff2':'font/woff2','.txt':'text/plain','.png':'image/png','.webp':'image/webp'};
function luminance(hex) {
  const c = [1,3,5].map(i => parseInt(hex.slice(i,i+2),16)/255);
  const linear = c.map(v => v<=.04045 ? v/12.92 : ((v+.055)/1.055)**2.4);
  return linear.reduce((sum,v,i)=>sum+v*[.2126,.7152,.0722][i],0);
}
function ratio(a,b) { const l=[luminance(a),luminance(b)].sort((x,y)=>y-x); return (l[0]+.05)/(l[1]+.05); }
const contrast = [
  ['Ink / Paper','#28221F','#F4EBDD'],['Paper / Cobalt','#F4EBDD','#3047D9'],
  ['Ink / Mist','#28221F','#D9D9D0'],['Ink / White','#28221F','#FFFFFF'],
  ['Ink / Roast','#28221F','#C56339'],['Roast / Paper','#C56339','#F4EBDD']
].map(([name,a,b])=>({name,foreground:a,background:b,ratio:ratio(a,b),ordinaryText:ratio(a,b)>=4.5,largeText:ratio(a,b)>=3}));
async function main() {
  const server = http.createServer((req,res)=>{
    const pathname=decodeURIComponent(new URL(req.url,'http://localhost').pathname);
    const file=path.join(web,pathname);
    if (!file.startsWith(web+path.sep)) { res.writeHead(403).end(); return; }
    fs.readFile(file,(error,data)=>{if(error){res.writeHead(404).end('Missing local asset');return;} res.setHeader('Content-Type',mime[path.extname(file)]||'application/octet-stream');res.end(data);});
  });
  await new Promise(resolve=>server.listen(0,'127.0.0.1',resolve));
  const port=server.address().port;
  let browser;
  try {
    browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome',args:['--no-sandbox']});
    const page=await browser.newPage({viewport:{width:1100,height:1400},deviceScaleFactor:1});
    const requestFailures=[];
    page.on('response',r=>{if(r.status()>=400)requestFailures.push({url:r.url(),status:r.status()});});
    await page.goto(`http://127.0.0.1:${port}${guidePath}`,{waitUntil:'networkidle'});
    await page.evaluate(()=>document.fonts.ready);
    await page.emulateMedia({media:'print'});
    const report=await page.evaluate(async()=>{
      const pages=[...document.querySelectorAll('.page')].map((el,i)=>{
        const rect=el.getBoundingClientRect(),footer=el.querySelector('.folio').getBoundingClientRect();
        const walker=document.createTreeWalker(el,NodeFilter.SHOW_TEXT);
        const overlaps=[];let node;
        while(node=walker.nextNode()){
          if(!node.textContent.trim()||node.parentElement.closest('.folio'))continue;
          const range=document.createRange();range.selectNodeContents(node);
          for(const r of range.getClientRects())if(r.bottom>footer.top-8)overlaps.push(node.textContent.trim().slice(0,80));
        }
        return {page:i+1,width:rect.width,height:rect.height,contentOverlapsFooter:[...new Set(overlaps)]};
      });
      const images=[...document.images].map(i=>({src:i.getAttribute('src'),loaded:i.complete&&i.naturalWidth>0,naturalWidth:i.naturalWidth}));
      const links=await Promise.all([...document.querySelectorAll('a[href]')].map(async a=>{const r=await fetch(a.href);return{href:a.getAttribute('href'),status:r.status};}));
      const fonts=[...document.fonts].map(f=>({family:f.family,weight:f.weight,status:f.status}));
      return {pages,images,links,fonts};
    });
    report.contrast=contrast;
    report.requestFailures=requestFailures;
    report.source='web/assets/selected-work/sift/sift-brand-guide.html';
    report.pdf='web/assets/selected-work/sift/sift-brand-guide.pdf';
    report.proofScope='Digital artifact only. No physical print, supplier, brewing, independent translation or commercial launch verification.';
    fs.writeFileSync(path.join(guide,'proof-report.json'),JSON.stringify(report,null,2)+'\n');
    const problems=[...requestFailures,...report.images.filter(i=>!i.loaded),...report.links.filter(l=>l.status!==200),...report.pages.filter(p=>p.contentOverlapsFooter.length)];
    if(problems.length)throw new Error(`Guide not ready: ${JSON.stringify(problems)}`);
    await page.pdf({path:output,format:'A4',printBackground:true,preferCSSPageSize:true,displayHeaderFooter:false});
    report.portablePDFLinks=JSON.parse(execFileSync(path.join(runtime,'python/bin/python3'),[
      path.join(__dirname,'fix-pdf-links.py'),'--pdf',output,
      '--html',path.join(web,guidePath),'--report',path.join(guide,'portable-links-report.json')
    ],{encoding:'utf8'}));
    const info=execFileSync(path.join(runtime,'bin/override/pdfinfo'),[output],{encoding:'utf8'});
    const count=Number(info.match(/^Pages:\s+(\d+)/m)[1]);
    if(count!==12)throw new Error(`Expected 12 PDF pages; received ${count}`);
    report.verifiedPDFPageCount=count;
    fs.mkdirSync(proofs,{recursive:true});
    report.digitalSizeProofs=[];
    const samples=[['lockup-visible-320px','sift-wordmark-mono.svg',516.13,310/500],['lockup-visible-176px','sift-wordmark-mono.svg',284,310/500],['wordmark-small-visible-64px','sift-wordmark-small.svg',79,310/380],['selected-line-48px','sift-selected-line.svg',48,120/260],['selected-line-24px','sift-selected-line.svg',24,120/260]];
    for(const [name,asset,width,visibleFraction] of samples){
      const proof=await browser.newPage({viewport:{width:650,height:350},deviceScaleFactor:1});
      await proof.setContent(`<html><body style="margin:0;background:#F4EBDD"><div id="sample" style="padding:32px;width:max-content"><img src="http://127.0.0.1:${port}/assets/selected-work/sift/source/${asset}" width="${width}" style="display:block"></div></body></html>`);
      await proof.waitForFunction(()=>document.images[0].complete&&document.images[0].naturalWidth>0);
      const actual=await proof.locator('img').boundingBox();
      await proof.locator('#sample').screenshot({path:path.join(proofs,name+'.png')});
      report.digitalSizeProofs.push({filename:'docs/sift/guide/proofs/'+name+'.png',source:asset,requestedCSSContainerWidth:width,actualCSSContainerWidth:actual.width,nominalVisibleArtworkWidth:actual.width*visibleFraction,devicePixelRatio:1});
      await proof.close();
    }
    execFileSync(path.join(runtime,'bin/override/pdftoppm'),['-r','110','-png',output,path.join(proofs,'guide')],{maxBuffer:1024*1024});
    report.pageProofFiles=fs.readdirSync(proofs).filter(f=>/^guide-\d+\.png$/.test(f)).sort().map(f=>'docs/sift/guide/proofs/'+f);
    fs.writeFileSync(path.join(guide,'proof-report.json'),JSON.stringify(report,null,2)+'\n');
    console.log(JSON.stringify({pdf:output,pages:count,proofFiles:report.pageProofFiles,fonts:report.fonts,contrast:contrast.map(c=>({name:c.name,ratio:c.ratio.toFixed(2)}))},null,2));
  } finally {if(browser)await browser.close();await new Promise(resolve=>server.close(resolve));}
}
main().catch(error=>{console.error(error.message);process.exitCode=1;});
