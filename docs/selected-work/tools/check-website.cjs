/** Focused, current-run browser validation for the Selected Work organization.
 * Run from any directory after the production build and local previews are ready:
 *   node docs/selected-work/tools/check-website.cjs
 * FOLD preview: 8804 (web + /agency_jaspr/ build); Frame service: 8803.
 * Isolated contexts; no enrolment, app handoff, publishing or enquiry submission.
 */
const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { chromium } = require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');

const docs = path.resolve(__dirname, '..');
const origin = process.env.SELECTED_WORK_ORIGIN || 'http://127.0.0.1:8804';
const frameOrigin = process.env.FRAME_SERVICE_ORIGIN || 'http://127.0.0.1:8803';
const agencyBase = process.env.SELECTED_WORK_BASE || '/agency_jaspr/';
const names = ['Sift Coffee', 'Form Architecture', 'Frame Academy', 'Fold Clothing'];
const report = {
  startedAt: new Date().toISOString(),
  scope: 'Fresh browser checks of the reorganized current source and current compiled agency; no earlier reports are reused.',
  origin, frameOrigin, agencyBase,
  widths: [390, 1440], agencyLocales: ['en', 'ar', 'fr'], standaloneLocales: ['en', 'ar'],
  protections: 'Fresh browser contexts; GET/HEAD/OPTIONS only; no enquiry submission, CMS publication, learner mutation, app handoff or replacement of original captures.',
  records: [], failures: [], screenshots: [],
};
let failureScreens = 0;

async function images(page, selector = 'body') {
  // Explicitly eager-load images outside both vertical and horizontal viewports.
  await page.locator(selector).evaluateAll(elements => {
    for (const element of elements) for (const image of element.querySelectorAll('img')) {
      image.loading = 'eager';
      image.fetchPriority = 'high';
    }
  });
  await page.waitForFunction(selector => [...document.querySelectorAll(selector)].every(element =>
    [...element.querySelectorAll('img')].every(image => image.complete && image.naturalWidth > 0)), selector, { timeout: 20000 });
  const inventory = await page.locator(selector).evaluateAll(elements => elements.flatMap(element =>
    [...element.querySelectorAll('img')].map(image => ({ src: image.currentSrc || image.src, width: image.naturalWidth, height: image.naturalHeight }))));
  assert(inventory.length > 0, `No images found in ${selector}`);
  return inventory;
}

async function layout(page, locale) {
  await page.evaluate(() => document.fonts.ready);
  const result = await page.evaluate(() => ({
    locale: document.documentElement.lang,
    direction: document.documentElement.dir,
    overflow: Math.max(0, document.documentElement.scrollWidth - innerWidth, document.body.scrollWidth - innerWidth),
  }));
  assert.equal(result.locale, locale, 'HTML language');
  assert.equal(result.direction, locale === 'ar' ? 'rtl' : 'ltr', 'HTML direction');
  assert.equal(result.overflow, 0, 'Horizontal body overflow');
  return result;
}

async function go(page, url, selector = 'h1') {
  const response = await page.goto(url, { waitUntil: 'domcontentloaded' });
  assert.equal(response.status(), 200, url);
  await page.locator(selector).first().waitFor();
}

async function settleCase(page, name) {
  await page.waitForFunction(name => {
    const modal = document.getElementById('caseModal');
    return modal && !modal.hidden && document.getElementById('cmTitle')?.textContent === name;
  }, name, { timeout: 20000 });
  await page.locator('.cm-transition-curtain').waitFor({ state: 'detached', timeout: 10000 });
  await page.waitForFunction(() => document.activeElement.id === 'cmTitle');
}

async function run(browser, name, viewport, task) {
  const context = await browser.newContext({ viewport, reducedMotion: 'reduce', deviceScaleFactor: 1 });
  const page = await context.newPage();
  const errors = [];
  const blockedRequests = [];
  page.setDefaultTimeout(15000);
  page.on('pageerror', error => errors.push(error.message));
  await context.route('**/*', route => {
    const request = route.request();
    if (!['GET', 'HEAD', 'OPTIONS'].includes(request.method())) {
      blockedRequests.push({ method: request.method(), url: request.url() });
      return route.abort();
    }
    const url = new URL(request.url());
    if (url.protocol.startsWith('http') && !['127.0.0.1', 'localhost'].includes(url.hostname)) {
      blockedRequests.push({ method: request.method(), url: request.url() });
      return route.abort();
    }
    return route.continue();
  });
  const record = { name, viewport, startedAt: new Date().toISOString() };
  try {
    record.detail = await task(page, context);
    assert.deepEqual(errors, [], 'Page JavaScript errors');
    assert.deepEqual(blockedRequests, [], 'Unexpected external or non-read request');
    record.result = 'passed';
  } catch (error) {
    record.result = 'failed';
    record.failure = error.message;
    report.failures.push({ name, message: error.message });
    if (failureScreens < 3) {
      const directory = path.join(docs, 'organization-proofs');
      fs.mkdirSync(directory, { recursive: true });
      const file = `failure-${++failureScreens}-${name.replace(/[^a-z0-9]+/gi, '-').toLowerCase()}.png`;
      await page.screenshot({ path: path.join(directory, file) }).then(() => report.screenshots.push(`docs/selected-work/organization-proofs/${file}`)).catch(() => {});
    }
  } finally {
    record.errors = errors;
    record.blockedRequests = blockedRequests;
    record.finishedAt = new Date().toISOString();
    report.records.push(record);
    console.log(JSON.stringify({ name, result: record.result, failure: record.failure }));
    await context.close();
  }
}

async function agency(page, locale, width) {
  await go(page, `${origin}${agencyBase}${locale === 'en' ? '' : locale + '/'}`, 'button.work-item');
  await page.waitForFunction(() => [...document.querySelectorAll('button.work-item')].length === 4 && [...document.querySelectorAll('button.work-item')].every(button => !button.disabled));
  const order = await page.locator('button.work-item').evaluateAll(buttons => buttons.map(button => button.dataset.case));
  assert.deepEqual(order, names, 'Selected Work order');
  const detail = { locale, width, order, layout: await layout(page, locale), cases: [] };
  for (const [index, name] of names.entries()) {
    // The explicit data attribute is the stable identity across translated labels.
    await page.locator(`button.work-item[data-case="${name}"]`).click();
    await settleCase(page, name);
    const loadedImages = await images(page, '#caseModal');
    const overflow = await page.locator('#caseModal').evaluate(modal => Math.max(0, modal.scrollWidth - modal.clientWidth));
    assert.equal(overflow, 0, `${name}: modal overflow`);
    assert.equal((await layout(page, locale)).overflow, 0);
    await page.keyboard.press('Tab');
    assert.equal(await page.evaluate(() => document.activeElement.id), 'cmClose', `${name}: first tab target`);
    const links = await page.locator('#cmBody .cm-download').evaluateAll(elements => elements.map(link => ({ href: link.href, download: link.getAttribute('download') })));
    assert(links.length > 0, `${name}: no source/resource links`);
    for (const link of links) {
      const response = await page.request.head(link.href);
      assert.equal(response.status(), 200, `${name}: ${link.href}`);
      assert(Number(response.headers()['content-length']) > 0, `${name}: empty download`);
      link.status = response.status();
    }
    const next = names[(index + 1) % names.length];
    await page.locator('#cmNext').click();
    await settleCase(page, next);
    if (index % 2) await page.keyboard.press('Escape');
    else await page.locator('#cmClose').click();
    await page.locator('#caseModal').waitFor({ state: 'hidden' });
    assert.equal(await page.evaluate(() => document.activeElement.dataset.case), name, `${name}: opener focus restoration`);
    detail.cases.push({ name, images: loadedImages, links, next, navigation: 'passed', close: index % 2 ? 'Escape' : 'button', focusRestored: true });
  }
  return detail;
}

async function form(page, locale) {
  const base = `${origin}/assets/selected-work/form/site/`;
  await go(page, `${base}index.html?lang=${locale}#home`);
  const home = { layout: await layout(page, locale), images: await images(page) };
  await page.locator('[data-nav="work"]').click();
  await page.waitForURL(/#work$/);
  await page.locator('a[href="#project/courtyard-house"]').first().click();
  await page.locator('.project-title-row').waitFor();
  const project = { layout: await layout(page, locale), images: await images(page), route: new URL(page.url()).hash };
  assert.equal(project.route, '#project/courtyard-house');
  await go(page, `${base}editor.html`, '#field-title-en');
  await page.locator('#editor-language').selectOption(locale);
  const title = await page.locator('#field-title-en').inputValue();
  assert.equal(title, 'Courtyard House');
  const editor = { layout: await layout(page, locale), images: await images(page), title };
  await page.locator('#preview').click();
  const preview = page.frameLocator('#site-preview');
  await preview.locator('.project-title-row').waitFor();
  assert.match(await preview.locator('h1').innerText(), /Courtyard House|منزل الفناء/);
  editor.actualPreviewLoaded = true;
  editor.publicationActivated = false;
  return { locale, home, project, editor };
}

async function frame(page, locale) {
  const learner = 'demo-organization-smoke';
  const sessionURL = `${frameOrigin}/api/session?learner=${learner}`;
  const before = await page.request.get(sessionURL);
  assert.equal(before.status(), 200, 'Frame service session GET');
  const beforeSession = await before.json();
  await go(page, `${frameOrigin}/assets/selected-work/frame/site/index.html?lang=${locale}&learner=${learner}#home`);
  const home = { layout: await layout(page, locale), images: await images(page) };
  await page.locator('header a[href="#courses"]').click();
  await page.locator('.filters [name="discipline"]').selectOption('photography');
  await page.locator('.filters [name="level"]').selectOption('beginner');
  await page.locator('.course-card').first().waitFor();
  const count = await page.locator('.course-card').count();
  assert(count > 0, 'Frame filtered catalogue empty');
  await page.locator('a[href="#course/FA-PH-01"]').first().click();
  await page.locator('.detail-head').waitFor();
  const course = { layout: await layout(page, locale), images: await images(page), filteredCourses: count };
  await page.locator('[data-action="preview"]').first().click();
  await page.locator('dialog[open] video').waitFor();
  await page.waitForFunction(() => document.querySelector('dialog video')?.readyState >= 1);
  course.previewDuration = await page.locator('dialog video').evaluate(video => video.duration);
  assert(course.previewDuration > 0, 'Frame preview metadata absent');
  await page.locator('[data-action="close-preview"]').click();
  await page.locator('dialog').waitFor({ state: 'hidden' });
  const after = await page.request.get(sessionURL);
  assert.deepEqual(await after.json(), beforeSession, 'Frame learner state changed during read-only discovery');
  return { locale, home, course, learnerStateUnchanged: true };
}

async function fold(page, locale) {
  const base = `${origin}/assets/selected-work/fold/`;
  await go(page, `${base}site/index.html?lang=${locale}`);
  await page.locator('.product-card').first().waitFor();
  const collection = { layout: await layout(page, locale), images: await images(page) };
  await page.locator('[name="category"]').selectOption('shirts');
  const filteredCount = await page.locator('.product-card').count();
  assert(filteredCount > 0, 'Fold filter produced no shirts');
  await page.locator('.product-card a').first().click();
  await page.locator('[name="product-size"][value="M"]').check();
  assert.equal(await page.locator('[name="product-size"][value="M"]').isChecked(), true);
  const product = { layout: await layout(page, locale), images: await images(page), filteredCount, selectedSize: 'M' };
  await go(page, `${base}shopping-flow.html?lang=${locale}`);
  await page.waitForFunction(() => document.querySelector('video')?.readyState >= 1);
  const viewer = { layout: await layout(page, locale), transcriptItems: await page.locator('#steps li').count(), duration: await page.locator('video').evaluate(video => video.duration) };
  assert.equal(viewer.transcriptItems, 5);
  assert(viewer.duration > 12, 'Fold recorded journey duration');
  await page.locator('#store').click();
  await page.locator('.product-card').first().waitFor();
  assert.equal(await page.locator('html').getAttribute('lang'), locale);
  viewer.storeLinkFollowed = true;
  return { locale, collection, product, viewer, checkoutActivated: false };
}

(async () => {
  let browser;
  try {
    browser = await chromium.launch({ headless: true, executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' });
    for (const locale of report.agencyLocales) for (const width of report.widths) {
      await run(browser, `agency-${locale}-${width}`, { width, height: 1000 }, page => agency(page, locale, width));
    }
    for (const locale of report.standaloneLocales) {
      await run(browser, `form-${locale}`, { width: 390, height: 844 }, page => form(page, locale));
      await run(browser, `frame-${locale}`, { width: 390, height: 844 }, page => frame(page, locale));
      await run(browser, `fold-${locale}`, { width: 390, height: 844 }, page => fold(page, locale));
    }
  } catch (error) {
    report.failures.push({ name: 'runner', message: error.message });
    console.error(error);
  } finally {
    if (browser) await browser.close();
    report.finishedAt = new Date().toISOString();
    report.summary = { records: report.records.length, passed: report.records.filter(row => row.result === 'passed').length, failures: report.failures.length };
    fs.writeFileSync(path.join(docs, 'browser-validation.json'), JSON.stringify(report, null, 2) + '\n');
    console.log(JSON.stringify(report.summary));
    if (report.failures.length) process.exitCode = 1;
  }
})();
