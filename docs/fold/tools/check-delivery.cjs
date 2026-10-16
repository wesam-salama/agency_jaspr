const fs=require('fs'),path=require('path'),assert=require('assert/strict');
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
 const rows=[],errors=[],origin='http://127.0.0.1:8804';
 try{
  const page=await browser.newPage({viewport:{width:390,height:844},reducedMotion:'reduce'});page.on('pageerror',e=>errors.push(e.message));
  for(const locale of ['en','ar']){
   const base=origin+'/agency_jaspr/assets/selected-work/fold/';
   const response=await page.goto(base+'shopping-flow.html?lang='+locale);assert.equal(response.status(),200);
   await page.locator('video').evaluate(v=>new Promise((resolve,reject)=>{if(v.readyState>=1)return resolve();v.addEventListener('loadedmetadata',resolve,{once:true});v.addEventListener('error',reject,{once:true});}));
   assert.equal(await page.locator('html').getAttribute('lang'),locale);assert.ok(await page.locator('video').evaluate(v=>v.duration)>12);assert.equal(await page.locator('video').evaluate(v=>v.autoplay),false);
   assert.match(await page.locator('video source').getAttribute('src'),new RegExp('shopping-flow-'+locale+'\\.mp4$'));
   assert.ok(await page.locator('#steps li').count()===5);assert.ok(await page.evaluate(()=>document.documentElement.scrollWidth<=innerWidth));
   await page.locator('#store').click();await page.locator('.product-card').first().waitFor();assert.equal(await page.locator('html').getAttribute('dir'),locale==='ar'?'rtl':'ltr');
   await page.locator('.product-card img').first().evaluate(i=>i.decode());assert.ok(await page.locator('.product-card img').first().evaluate(i=>i.naturalWidth)>0);
   rows.push({locale,videoMetadata:true,viewerOverflow:0,autoplay:false,transcriptItems:5,productionStoreLink:true});
  }
  const request=page.request,paths=['/agency_jaspr/','/agency_jaspr/ar/','/agency_jaspr/fr/','/agency_jaspr/main.client.dart.js','/agency_jaspr/assets/styles.css','/agency_jaspr/assets/selected-work/fold/fold-source.zip','/agency_jaspr/assets/selected-work/fold/site/index.html?lang=ar','/agency_jaspr/assets/selected-work/fold/hero.webp','/agency_jaspr/assets/selected-work/fold/products/fl04-stone-back.webp','/agency_jaspr/assets/selected-work/fold/fonts/IBMPlexSansArabic-Regular.woff2'];
  const http=[];for(const pathname of paths){const r=await request.head(origin+pathname);assert.equal(r.status(),200,pathname);http.push({pathname,status:r.status()});}
  const range=await request.get(origin+'/agency_jaspr/assets/selected-work/fold/shopping-flow-en.mp4',{headers:{Range:'bytes=0-255'}});assert.equal(range.status(),206);assert.equal((await range.body()).length,256);
  assert.deepEqual(errors,[]);fs.writeFileSync(path.join(__dirname,'../verification/delivery-checks.json'),JSON.stringify({date:'2026-10-15',viewer:rows,http,rangeMP4:206,pageErrors:errors},null,2)+'\n');console.log(JSON.stringify({viewerChecks:rows.length,httpChecks:http.length,range:206,pageErrors:errors}));
 }finally{await browser.close();}
})().catch(e=>{console.error(e);process.exitCode=1});
