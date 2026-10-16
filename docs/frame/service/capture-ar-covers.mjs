import {createRequire} from 'node:module';
import {resolve} from 'node:path';
const require=createRequire(import.meta.url);
const {chromium}=require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');
const browser=await chromium.launch({headless:true,executablePath:'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'});
const page=await browser.newPage({viewport:{width:1440,height:1000}});
for(const width of [1440,390])for(const [view,name] of [['home',width===1440?'desktop-ar':'mobile-ar'],['courses',width===1440?'catalogue-ar':'catalogue-mobile-ar'],['course/FA-PH-01',`course-detail-${width===1440?'desktop':'mobile'}-ar`]]) {
 await page.setViewportSize({width,height:1000});await page.goto(`http://127.0.0.1:8803/assets/selected-work/frame/site/?learner=demo-ar&lang=ar#${view}`);await page.locator('h1').waitFor();await page.evaluate(()=>document.fonts.ready);
 await page.screenshot({path:resolve(`docs/frame/verification/website/${name}.png`),fullPage:true});
}
await browser.close();process.stdout.write('Six corrected-Arabic-cover website views captured read-only.\n');
