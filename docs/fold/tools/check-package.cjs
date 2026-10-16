const fs = require('node:fs');
const fsp = require('node:fs/promises');
const path = require('node:path');
const http = require('node:http');
const crypto = require('node:crypto');
const assert = require('node:assert/strict');
const { execFileSync } = require('node:child_process');
const { chromium } = require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');

const projectRoot = path.resolve(__dirname, '../../..');
const archive = path.join(projectRoot, 'web/assets/selected-work/fold/fold-source.zip');
const reportPath = path.join(__dirname, '../verification/package-browser-checks.json');
const packageRoot = 'Fold-Clothing';
const runtime = 'assets/selected-work/fold/';
const requiredEntries = [
  'web/' + runtime + 'site/index.html',
  'web/' + runtime + 'site/app.mjs',
  'web/' + runtime + 'site/data.mjs',
  'web/' + runtime + 'site/style.css',
  'web/' + runtime + 'source/fold-brand-guide.html',
  'web/' + runtime + 'source/identity.css',
  'web/' + runtime + 'fonts/Archivo.woff2',
  'web/' + runtime + 'fonts/DMSans.woff2',
  'web/' + runtime + 'fonts/IBMPlexSansArabic-Regular.woff2',
  'web/' + runtime + 'fonts/IBMPlexSansArabic-SemiBold.woff2',
  'web/' + runtime + 'products/fl01-chalk-front.webp',
  'web/' + runtime + 'identity/fold-wordmark-ink.svg',
  'docs/fold/README.md',
  'docs/fold/tools/preview-server.mjs',
  'docs/fold/tools/package-source.py',
  'docs/fold/production/production-record.md',
  'docs/fold/verification/verification.md',
  'docs/fold/presentation-sources/shopping.html',
];
const mime = {
  '.html': 'text/html; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8', '.mjs': 'text/javascript; charset=utf-8',
  '.svg': 'image/svg+xml', '.webp': 'image/webp', '.png': 'image/png', '.jpg': 'image/jpeg',
  '.woff2': 'font/woff2', '.ttf': 'font/ttf', '.json': 'application/json', '.txt': 'text/plain; charset=utf-8',
};
function hash(file) {
  return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}
async function imageAndFontState(page, requiredFonts) {
  await page.evaluate(async () => {
    for (const image of document.images) image.loading = 'eager';
    await document.fonts.ready;
  });
  await page.waitForFunction(() => [...document.images].every(image => image.complete && image.naturalWidth > 0), null, { timeout: 20000 });
  const state = await page.evaluate(() => ({
    lang: document.documentElement.lang,
    direction: document.documentElement.dir || 'ltr',
    documentOverflow: Math.max(0, document.documentElement.scrollWidth - innerWidth),
    bodyOverflow: Math.max(0, document.body.scrollWidth - innerWidth),
    fonts: [...document.fonts].map(face => ({ family: face.family.replaceAll('"', '').replaceAll("'", ''), status: face.status })),
    images: [...document.images].map(image => ({ source: new URL(image.currentSrc || image.src).pathname, loaded: image.complete && image.naturalWidth > 0, width: image.naturalWidth, height: image.naturalHeight })),
  }));
  assert.equal(state.documentOverflow, 0, 'Document has horizontal overflow');
  assert.equal(state.bodyOverflow, 0, 'Body has horizontal overflow');
  for (const family of requiredFonts) assert(state.fonts.some(face => face.family === family && face.status === 'loaded'), `${family} was not loaded from the package`);
  assert(state.images.length > 0 && state.images.every(image => image.loaded), 'Package imagery did not load');
  assert(state.images.every(image => image.source.startsWith('/' + runtime)), 'Image did not resolve within the extracted Fold runtime');
  return state;
}

(async () => {
  const record = {
    checkedAt: new Date().toISOString(),
    scope: 'Actual extracted-archive smoke check in local Chrome: English collection, Arabic explicit-size add-to-cart, and editable brand guide at 390/1440. This does not rerun the full canonical two-product checkout or replace the main store verification.',
    archive: { file: path.relative(projectRoot, archive), root: packageRoot, servedRoot: packageRoot + '/web' },
    checks: [], pageErrors: [], consoleErrors: [], missingAssets: [], externalRequests: [], failedRequests: [], nonReadRequests: [], failures: [],
    server: { binding: '127.0.0.1', port: 'random', automaticFavicon: '204 No Content for the browser implicit /favicon.ico request; no referenced package asset is replaced or synthesized' },
    cleanup: { browserClosed: false, serverClosed: false, temporaryFilesRemoved: false },
  };
  let temporaryRoot;
  let server;
  let browser;
  let origin;
  try {
    assert(fs.existsSync(archive), 'Fold source archive is absent');
    record.archive.sha256 = hash(archive);
    record.archive.bytes = fs.statSync(archive).size;
    const entries = execFileSync('unzip', ['-Z1', archive], { encoding: 'utf8', maxBuffer: 2 * 1024 * 1024 }).trim().split(/\r?\n/);
    assert(entries.length > 0, 'Archive is empty');
    for (const entry of entries) {
      assert(entry.startsWith(packageRoot + '/'), `Archive lost the declared root: ${entry}`);
      assert(!path.posix.isAbsolute(entry) && !entry.split('/').includes('..') && !entry.includes('\\'), `Unsafe archive path: ${entry}`);
      assert(!entry.split('/').some(part => ['.git', '.dart_tool', 'node_modules', '__pycache__', 'build', '.cache'].includes(part)), `Cache in source package: ${entry}`);
      assert(!/(?:^|\/)(?:preview\.(?:json|log)|page@[^/]+|[^/]+\.(?:log|pyc|pyo))$/.test(entry), `Ephemeral file in source package: ${entry}`);
      assert(!entry.endsWith('/fold-source.zip'), `Nested source archive: ${entry}`);
    }
    for (const relative of requiredEntries) assert(entries.includes(packageRoot + '/' + relative), `Archive relative path absent: ${relative}`);
    record.archive.fileCount = entries.filter(entry => !entry.endsWith('/')).length;
    record.archive.relativePathsPreserved = true;
    record.archive.ephemeralFilesExcluded = true;
    record.archive.requiredEntries = requiredEntries;
    temporaryRoot = fs.mkdtempSync('/private/tmp/fold-package-');
    execFileSync('unzip', ['-q', archive, '-d', temporaryRoot]);
    const webRoot = path.join(temporaryRoot, packageRoot, 'web');
    for (const relative of requiredEntries) assert(fs.statSync(path.join(temporaryRoot, packageRoot, relative)).isFile(), `Extracted file absent: ${relative}`);
    server = http.createServer(async (request, response) => {
      const url = new URL(request.url, 'http://127.0.0.1');
      if (url.pathname === '/favicon.ico') { response.writeHead(204); response.end(); return; }
      if (!['GET', 'HEAD'].includes(request.method)) { response.writeHead(405); response.end(); return; }
      try {
        let pathname = decodeURIComponent(url.pathname);
        if (pathname.endsWith('/')) pathname += 'index.html';
        const file = path.resolve(webRoot, '.' + pathname);
        if (!file.startsWith(webRoot + path.sep)) { response.writeHead(403); response.end(); return; }
        const stat = await fsp.stat(file);
        if (!stat.isFile()) throw Object.assign(new Error('Not a file'), { code: 'ENOENT' });
        response.writeHead(200, { 'Content-Type': mime[path.extname(file)] || 'application/octet-stream', 'Content-Length': stat.size, 'Cache-Control': 'no-store', 'X-Content-Type-Options': 'nosniff' });
        if (request.method === 'HEAD') response.end(); else fs.createReadStream(file).pipe(response);
      } catch (error) {
        const status = error.code === 'ENOENT' ? 404 : 500;
        response.writeHead(status); response.end('Extracted package file unavailable');
      }
    });
    await new Promise((resolve, reject) => { server.once('error', reject); server.listen(0, '127.0.0.1', resolve); });
    record.server.port = server.address().port;
    origin = 'http://127.0.0.1:' + record.server.port;
    record.server.origin = origin;
    browser = await chromium.launch({ headless: true, executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' });
    async function run(name, width, operation) {
      const context = await browser.newContext({ viewport: { width, height: 1000 }, reducedMotion: 'reduce' });
      const page = await context.newPage();
      const check = { name, width, height: 1000 };
      page.on('pageerror', error => record.pageErrors.push({ check: name, message: error.message }));
      page.on('console', message => { if (message.type() === 'error') record.consoleErrors.push({ check: name, message: message.text() }); });
      page.on('response', response => { if (response.status() >= 400) record.missingAssets.push({ check: name, status: response.status(), path: new URL(response.url()).pathname }); });
      page.on('requestfailed', request => record.failedRequests.push({ check: name, path: request.url(), failure: request.failure()?.errorText }));
      await page.route('**/*', route => {
        const request = route.request();
        const url = request.url();
        if (!['GET', 'HEAD'].includes(request.method())) record.nonReadRequests.push({ check: name, method: request.method(), url });
        if (!url.startsWith(origin + '/') && !url.startsWith('data:') && !url.startsWith('blob:')) { record.externalRequests.push({ check: name, url }); return route.abort(); }
        return route.continue();
      });
      try { await operation(page, check); check.result = 'passed'; }
      catch (error) { check.result = 'failed'; check.failure = error.message; record.failures.push(`${name}: ${error.message}`); }
      finally { record.checks.push(check); await context.close(); }
    }
    await run('English collection', 1440, async (page, check) => {
      await page.goto(origin + '/' + runtime + 'site/index.html', { waitUntil: 'domcontentloaded' });
      await page.locator('#main h1').waitFor();
      check.state = await imageAndFontState(page, ['Archivo', 'DM Sans']);
      assert.equal(check.state.lang, 'en');
      assert.equal(check.state.direction, 'ltr');
      check.productCards = await page.locator('.product-card').count();
      assert.equal(check.productCards, 4);
    });
    await run('Arabic product M selection and cart', 390, async (page, check) => {
      await page.goto(origin + '/' + runtime + 'site/index.html?page=product&id=FL01&colour=chalk&lang=ar', { waitUntil: 'domcontentloaded' });
      await page.locator('.purchase h1').waitFor();
      check.productState = await imageAndFontState(page, ['Plex Arabic']);
      assert.equal(check.productState.lang, 'ar');
      assert.equal(check.productState.direction, 'rtl');
      assert.equal(await page.locator('input[name="product-size"]:checked').count(), 0);
      assert.equal(await page.locator('[data-action="add"]').isDisabled(), true);
      await page.locator('input[name="product-size"][value="M"]').check();
      assert.equal((await page.locator('.sku').textContent()).trim(), 'FL01-CHK-M');
      await page.locator('[data-action="add"]').click();
      await page.locator('.cart-link').click();
      await page.locator('.cart-lines .sku').waitFor();
      assert.equal((await page.locator('.cart-lines .sku').textContent()).trim(), 'FL01-CHK-M');
      assert.equal(await page.locator('[data-change="quantity"]').inputValue(), '1');
      check.cartState = await imageAndFontState(page, ['Plex Arabic']);
      check.savedCart = await page.evaluate(() => JSON.parse(localStorage.getItem('fold.demo.cart.v1')));
      assert.deepEqual(check.savedCart, { version: 1, lines: [{ id: 'FL01', color: 'chalk', size: 'M', quantity: 1 }] });
      check.explicitSizeSelected = 'M';
      check.cartSKU = 'FL01-CHK-M';
    });
    for (const width of [390, 1440]) await run('Editable brand guide ' + width, width, async (page, check) => {
      await page.goto(origin + '/' + runtime + 'source/fold-brand-guide.html', { waitUntil: 'domcontentloaded' });
      await page.locator('main.guide h1').waitFor();
      check.state = await imageAndFontState(page, ['Archivo', 'DM Sans', 'PlexArabic']);
      check.title = await page.title();
      assert(check.title.includes('editable brand guide'));
    });
    for (const key of ['pageErrors', 'consoleErrors', 'missingAssets', 'externalRequests', 'failedRequests', 'nonReadRequests']) assert.deepEqual(record[key], [], key);
    assert.equal(record.checks.filter(check => check.result === 'passed').length, 4, 'Not all archive smoke cases passed');
  } catch (error) {
    record.failures.push(error.message);
  } finally {
    if (browser) {
      try { await browser.close(); record.cleanup.browserClosed = true; }
      catch (error) { record.failures.push('Browser cleanup: ' + error.message); }
    }
    if (server) {
      try { await new Promise(resolve => { server.close(resolve); server.closeAllConnections?.(); }); record.cleanup.serverClosed = true; }
      catch (error) { record.failures.push('Server cleanup: ' + error.message); }
    }
    if (temporaryRoot) {
      try { fs.rmSync(temporaryRoot, { recursive: true, force: true }); record.cleanup.temporaryFilesRemoved = !fs.existsSync(temporaryRoot); }
      catch (error) { record.failures.push('Temporary extraction cleanup: ' + error.message); }
    }
    if (record.archive.sha256 && fs.existsSync(archive)) {
      record.archive.sha256AfterCheck = hash(archive);
      record.archive.unchangedDuringCheck = record.archive.sha256 === record.archive.sha256AfterCheck;
      if (!record.archive.unchangedDuringCheck) record.failures.push('The archive changed while it was being tested');
    }
    record.result = record.failures.length ? 'failed' : 'passed';
    fs.writeFileSync(reportPath, JSON.stringify(record, null, 2) + '\n');
  }
  console.log(JSON.stringify({ archiveSha256: record.archive.sha256, fileCount: record.archive.fileCount, checks: record.checks.length, passed: record.checks.filter(check => check.result === 'passed').length, failures: record.failures, cleanup: record.cleanup }, null, 2));
  if (record.failures.length) process.exitCode = 1;
})().catch(error => { console.error(error); process.exitCode = 1; });
