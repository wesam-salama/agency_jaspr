const fs = require('fs');
const path = require('path');
const { chromium } = require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');

const output = path.join(__dirname, '../verification/agency');
const origin = process.env.FOLD_AGENCY_ORIGIN || 'http://127.0.0.1:8804';
const base = process.env.FOLD_AGENCY_BASE || '/agency_jaspr/';
const widths = [320, 390, 768, 1440];
const locales = ['en', 'ar', 'fr'];

function assert(condition, message) {
  if (!condition) throw new Error(message);
}

async function settleCase(page, name, requireCurtain = true) {
  let curtainSeen = false;
  try {
    await page.locator('.cm-transition-curtain').waitFor({ state: 'attached', timeout: 1000 });
    curtainSeen = true;
  } catch (_) {}
  await page.waitForFunction(name => {
    const modal = document.getElementById('caseModal');
    return modal && !modal.hidden && document.getElementById('cmTitle').textContent === name;
  }, name, { timeout: 12000 });
  await page.locator('.cm-transition-curtain').waitFor({ state: 'detached', timeout: 6000 });
  if (requireCurtain) assert(curtainSeen, `Shared curtain was not observed for ${name}`);
  return { name, curtainSeen };
}

async function waitImages(page) {
  await page.evaluate(async () => {
    const modal = document.getElementById('caseModal');
    // Load every lazy figure, including images well beyond the initial viewport.
    for (const image of modal.querySelectorAll('img')) image.loading = 'eager';
    for (let offset = 0; offset < modal.scrollHeight; offset += Math.max(200, modal.clientHeight * .75)) {
      modal.scrollTop = offset;
      await new Promise(resolve => setTimeout(resolve, 45));
    }
    await Promise.all([...modal.querySelectorAll('img')].map(image => new Promise(resolve => {
      if (image.complete) return resolve();
      image.addEventListener('load', resolve, { once: true });
      image.addEventListener('error', resolve, { once: true });
      setTimeout(resolve, 5000);
    })));
    modal.scrollTop = 0;
  });
}

(async () => {
  fs.mkdirSync(output, { recursive: true });
  const browser = await chromium.launch({ executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome', headless: true });
  const records = [];
  const failures = [];
  try {
    for (const locale of locales) {
      for (const width of widths) {
        const page = await browser.newPage({ viewport: { width, height: 1000 }, deviceScaleFactor: 1, reducedMotion: 'no-preference' });
        const errors = [];
        page.on('pageerror', error => errors.push(error.message));
        page.on('console', message => { if (message.type() === 'error') errors.push(message.text()); });
        const record = { locale, width, height: 1000, errors, captures: [] };
        try {
          const url = `${origin}${base}${locale === 'en' ? '' : `${locale}/`}`;
          const response = await page.goto(url, { waitUntil: 'domcontentloaded' });
          assert(response.status() === 200, `${url}: HTTP ${response.status()}`);
          const foldCard = page.locator('button.work-item[data-case="Fold Clothing"]');
          await page.waitForFunction(() => {
            const card = document.querySelector('button.work-item[data-case="Fold Clothing"]');
            return card && !card.disabled;
          }, null, { timeout: 30000 });
          await page.evaluate(() => document.fonts.ready);
          record.page = await page.evaluate(() => ({
            language: document.documentElement.lang,
            direction: document.documentElement.dir,
            overflow: Math.max(0, document.documentElement.scrollWidth - innerWidth),
            fonts: {
              inter: document.fonts.check('16px Inter'),
              spaceGrotesk: document.fonts.check('16px "Space Grotesk"'),
              arabic: document.fonts.check('16px "IBM Plex Sans Arabic"'),
            },
            fontFaces: [...document.fonts].map(face => ({ family: face.family.replaceAll("'", '').replaceAll('"', ''), status: face.status })),
            bodyFont: getComputedStyle(document.body).fontFamily,
            cards: [...document.querySelectorAll('.work-item')].map(card => card.dataset.case),
          }));
          assert(record.page.language === locale, 'Locale metadata mismatch');
          assert(record.page.direction === (locale === 'ar' ? 'rtl' : 'ltr'), 'Direction mismatch');
          assert(record.page.overflow === 0, `Page overflow ${record.page.overflow}`);
          const requiredFamily = locale === 'ar' ? 'IBM Plex Sans Arabic' : 'Inter';
          assert(record.page.fontFaces.some(face => face.family === requiredFamily && face.status === 'loaded'), `${requiredFamily} font was not loaded`);
          assert(record.page.cards.join('|') === 'Sift Coffee|Form Architecture|Frame Academy|Fold Clothing', 'Selected Work order mismatch');
          await foldCard.click();
          record.open = await settleCase(page, 'Fold Clothing');
          record.initialFocus = await page.evaluate(() => document.activeElement.id);
          assert(record.initialFocus === 'cmTitle', `Initial dialog focus ${record.initialFocus}`);
          await page.keyboard.press('Tab');
          const firstFocus = await page.evaluate(() => document.activeElement.id);
          await page.keyboard.press('Shift+Tab');
          const lastFocus = await page.evaluate(() => document.activeElement.id);
          await page.keyboard.press('Tab');
          const wrappedFocus = await page.evaluate(() => document.activeElement.id);
          record.focusWrap = { firstFocus, lastFocus, wrappedFocus };
          assert(firstFocus === 'cmClose' && lastFocus === 'cmNext' && wrappedFocus === 'cmClose', 'Dialog keyboard wrap failed');
          await waitImages(page);
          record.case = await page.evaluate(() => {
            const modal = document.getElementById('caseModal');
            const body = document.getElementById('cmBody');
            return {
              modalOverflow: Math.max(0, modal.scrollWidth - modal.clientWidth),
              bodyOverflow: Math.max(0, body.scrollWidth - body.clientWidth),
              resultsStripCount: body.querySelectorAll('.cm-stats').length,
              resultsGroupCount: body.querySelectorAll('[role="group"][aria-label="Results"], [role="group"][aria-label="النتائج"], [role="group"][aria-label="Résultats"]').length,
              figureCount: body.querySelectorAll('figure').length,
              images: [...modal.querySelectorAll('img')].map(image => ({ src: image.getAttribute('src'), currentSrc: image.currentSrc, loaded: image.complete && image.naturalWidth > 0, alt: image.alt, intrinsicWidth: image.naturalWidth })),
              links: [...body.querySelectorAll('.cm-download')].map(link => ({ label: link.textContent.trim(), href: link.getAttribute('href'), download: link.getAttribute('download'), aria: link.getAttribute('aria-label') })),
              metadata: document.getElementById('cmMeta').textContent,
            };
          });
          assert(record.case.modalOverflow === 0 && record.case.bodyOverflow === 0, 'Case horizontal overflow');
          assert(record.case.resultsStripCount === 0 && record.case.resultsGroupCount === 0, 'Fold created an empty Results strip or labelled group');
          assert(record.case.figureCount === 5, 'Fold five-figure narrative evidence is incomplete');
          assert(record.case.images.length === 6 && record.case.images.every(image => image.loaded && image.alt), 'Case image loading or alt failed');
          assert(record.case.links.length === 3, 'Fold destinations missing');
          assert(record.case.links[0].download === null && record.case.links[1].download === null && record.case.links[2].download === 'fold-source.zip', 'HTML/demo and ZIP semantics mismatch');
          const localeQuery = locale === 'ar' ? '?lang=ar' : '';
          const expectedHrefs = [
            `assets/selected-work/fold/site/index.html${localeQuery}`,
            `assets/selected-work/fold/shopping-flow.html${localeQuery}`,
            'assets/selected-work/fold/fold-source.zip',
          ];
          assert(record.case.links.every((link, index) => link.href === expectedHrefs[index]), 'Localized Fold destinations mismatch');
          for (const link of record.case.links) {
            const resolved = new URL(link.href, `${origin}${base}`).href;
            const destination = await page.request.head(resolved);
            assert(destination.status() === 200, `Destination ${resolved}: HTTP ${destination.status()}`);
            link.status = destination.status();
            link.method = 'HEAD';
            link.contentType = destination.headers()['content-type'];
            link.contentLength = Number(destination.headers()['content-length']);
            assert(link.contentLength > 0, `Empty destination ${resolved}`);
            assert(link.contentType.includes(link.href.endsWith('.zip') ? 'application/zip' : 'text/html'), `Destination type ${resolved}`);
          }
          if (width === 1440 || width === 390) {
            for (const position of ['top', 'middle', 'end']) {
              await page.evaluate(position => {
                const modal = document.getElementById('caseModal');
                modal.scrollTop = position === 'top' ? 0 : position === 'middle' ? (modal.scrollHeight - modal.clientHeight) / 2 : modal.scrollHeight;
              }, position);
              await page.waitForTimeout(75);
              const file = `${locale}-${width}-${position}.png`;
              await page.screenshot({ path: path.join(output, file) });
              record.captures.push(`verification/agency/${file}`);
            }
          }
          await page.locator('#cmNext').click();
          record.foldNext = await settleCase(page, 'Sift Coffee');
          record.siftChapters = await page.locator('#cmBody .cm-chblock').count();
          assert(record.siftChapters === 4, 'Sift chapters changed');
          await page.keyboard.press('Escape');
          await page.locator('#caseModal').waitFor({ state: 'hidden' });
          record.restoredFocus = await page.evaluate(() => document.activeElement.dataset.case);
          assert(record.restoredFocus === 'Fold Clothing', 'Fold opener focus was not restored after Next and Escape');
          await page.locator('button.work-item[data-case="Frame Academy"]').click();
          record.frame = await settleCase(page, 'Frame Academy');
          record.frameChapters = await page.locator('#cmBody .cm-hch').count();
          assert(record.frameChapters === 4, 'Frame four chapters changed');
          await page.locator('#cmNext').click();
          record.frameNext = await settleCase(page, 'Fold Clothing');
          assert(await page.locator('#cmBody .cm-stats').count() === 0, 'Frame→Fold created an empty Results strip');
          await page.locator('#cmNext').click();
          record.wrapNext = await settleCase(page, 'Sift Coffee');
          await page.keyboard.press('Escape');
          await page.locator('#caseModal').waitFor({ state: 'hidden' });
          record.frameRestoredFocus = await page.evaluate(() => document.activeElement.dataset.case);
          assert(record.frameRestoredFocus === 'Frame Academy', 'Frame opener focus was not restored after navigating through Fold');
          record.enquiryPreserved = await page.locator('#contactForm #message').count() === 1;
          assert(record.enquiryPreserved, 'Agency enquiry controls changed');
          assert(errors.length === 0, `Browser errors: ${errors.join('; ')}`);
          record.result = 'passed';
        } catch (error) {
          record.result = 'failed';
          record.failure = error.message;
          failures.push(`${locale}/${width}: ${error.message}`);
          const file = `${locale}-${width}-failure.png`;
          await page.screenshot({ path: path.join(output, file) }).catch(() => {});
          record.captures.push(`verification/agency/${file}`);
        } finally {
          records.push(record);
          console.log(JSON.stringify({ locale, width, result: record.result, failure: record.failure }));
          await page.close();
        }
      }
    }
  } finally {
    await browser.close();
  }
  fs.writeFileSync(path.join(__dirname, '../verification/agency-checks.json'), JSON.stringify({ checkedAt: new Date().toISOString(), origin, base, records, failures }, null, 2) + '\n');
  console.log(JSON.stringify({ checks: records.length, passed: records.filter(record => record.result === 'passed').length, failures }, null, 2));
  if (failures.length) process.exitCode = 1;
})().catch(error => { console.error(error); process.exitCode = 1; });
