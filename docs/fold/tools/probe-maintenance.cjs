const fs=require('node:fs');
const path=require('node:path');
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
(async()=>{
 const stage=process.argv[2]||'before';
 const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
 const records=[];
 try{
 for(const lang of ['en','ar']){
  const page=await browser.newPage({viewport:{width:1000,height:900},reducedMotion:'reduce'});
  await page.goto('http://127.0.0.1:8804/assets/selected-work/fold/site/?page=product&id=FL01&colour=chalk&lang='+lang);
  await page.locator('input[name="product-size"][value="M"]').check();
  await page.locator('[data-action="add"]').click();
  await page.locator('.cart-link').click();
  const qty=page.locator('[data-change="quantity"]');
  await qty.focus();await qty.fill('2');await page.keyboard.press('Tab');
  const quantity=await page.evaluate(()=>({activeTag:document.activeElement.tagName,activeChange:document.activeElement.dataset.change||null,activeLine:document.activeElement.dataset.line||null,activeAction:document.activeElement.dataset.action||null,sku:document.querySelector('.sku').textContent,quantity:document.querySelector('[data-change="quantity"]').value}));
  const size=page.locator('[data-change="size"]');await size.focus();await size.selectOption('L');
  const sizing=await page.evaluate(()=>({activeTag:document.activeElement.tagName,activeChange:document.activeElement.dataset.change||null,activeLine:document.activeElement.dataset.line||null,sku:document.querySelector('.sku').textContent}));
  await page.screenshot({path:path.join(__dirname,'../verification/store',`maintenance-${stage}-${lang}.png`),fullPage:true});
  records.push({language:lang,quantity,sizing});await page.close();
 }
 fs.writeFileSync(path.join(__dirname,`../verification/maintenance-${stage}.json`),JSON.stringify({stage,date:'2026-10-15',method:'Real browser quantity commit via keyboard Tab; size selection followed by active-element and retained SKU/value observations',records},null,2)+'\n');
 console.log(JSON.stringify(records));
 }finally{await browser.close();}
})();
