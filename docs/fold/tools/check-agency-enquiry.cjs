const fs = require('node:fs');
const path = require('node:path');
const assert = require('node:assert/strict');
const { chromium } = require('/Users/wesamsalama/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright');

(async () => {
  const browser = await chromium.launch({ headless: true, executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' });
  const page = await browser.newPage({ viewport: { width: 390, height: 1000 }, reducedMotion: 'reduce' });
  const errors = [];
  const externalMailRequests = [];
  const nonReadRequests = [];
  const popups = [];
  page.on('pageerror', error => errors.push(error.message));
  page.on('console', message => { if (message.type() === 'error') errors.push(message.text()); });
  page.on('request', request => {
    if (request.url().startsWith('mailto:')) externalMailRequests.push(request.url());
    if (!['GET', 'HEAD'].includes(request.method())) nonReadRequests.push({ method: request.method(), url: request.url() });
  });
  page.on('popup', popup => popups.push(popup.url()));
  const expected = {
    name: 'Demo reviewer',
    email: 'reviewer@example.test',
    message: 'A bilingual ecommerce brand and store.\nملاحظة تجريبية تبقى كما هي.',
    timing: 'soon',
    services: ['0', '3'],
  };
  const records = [];
  try {
    await page.goto('http://127.0.0.1:8804/agency_jaspr/#contact');
    await page.waitForFunction(() => !document.getElementById('draftButton').disabled);
    const required = await page.evaluate(() => Object.fromEntries(['name', 'email', 'message'].map(id => [id, document.getElementById(id).required])));
    assert.deepEqual(required, { name: true, email: true, message: true });
    const emptyRequiredValid = await page.locator('#contactForm').evaluate(form => form.checkValidity());
    assert.equal(emptyRequiredValid, false);
    await page.locator('#name').fill(expected.name);
    await page.locator('#email').fill(expected.email);
    await page.locator('#message').fill(expected.message);
    await page.locator('#timing').selectOption(expected.timing);
    for (const value of expected.services) await page.locator(`input[name="services"][value="${value}"]`).check();
    for (const language of ['en', 'ar', 'fr']) {
      if (language !== 'en') {
        await page.locator('.language-switcher summary').click();
        await page.locator(`[data-language-link="${language}"]`).click();
        await page.waitForFunction(language => document.documentElement.lang === language, language);
        await page.waitForFunction(() => !document.getElementById('draftButton').disabled);
      }
      const actual = await page.evaluate(() => ({
        name: document.getElementById('name').value,
        email: document.getElementById('email').value,
        message: document.getElementById('message').value,
        timing: document.getElementById('timing').value,
        services: [...document.querySelectorAll('input[name="services"]:checked')].map(input => input.value),
      }));
      assert.deepEqual(actual, expected);
      assert.equal(new URL(page.url()).hash, '#contact');
      assert.equal(await page.locator('#contactForm').evaluate(form => form.checkValidity()), true);
      const action = await page.locator('#contactForm').getAttribute('action');
      assert.equal(action, 'mailto:hello@cr8.media');
      records.push({ language, actual, unfinishedBriefPreserved: true, requiredFieldsValid: true, sectionRetained: true, action });
    }
    assert.deepEqual(errors, []);
    assert.deepEqual(externalMailRequests, []);
    assert.deepEqual(nonReadRequests, []);
    assert.deepEqual(popups, []);
    const record = {
      checkedAt: new Date().toISOString(),
      target: 'Actual compiled Fold agency integration, Chrome 390×1000, reduced motion, http://127.0.0.1:8804/agency_jaspr/',
      required,
      emptyRequiredValid,
      expected,
      records,
      errors,
      externalMailRequests,
      nonReadRequests,
      popups,
      submitActivated: false,
      scope: 'Empty required-field validity and complete unfinished brief retained exactly EN→AR→FR, including service/timing choices. Submit was never activated; no mail client or external message was opened.',
    };
    fs.writeFileSync(path.join(__dirname, '../verification/agency-enquiry-checks.json'), JSON.stringify(record, null, 2) + '\n');
    console.log(JSON.stringify({ localeChecks: records.length, passed: true, submitted: false }));
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error); process.exitCode = 1; });
