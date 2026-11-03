/**
 * Working Playwright example for Mobile Harness (Ubuntu 20.04 PRoot ARM64)
 * Requires: Chromium installed via the install script in this repo
 */

const { chromium } = require('playwright');

async function main() {
  const browser = await chromium.launch({
    headless: true,
    executablePath: '/usr/bin/chromium-browser',
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
      '--disable-gpu',
      '--single-process',
      '--no-zygote'
    ]
  });

  const page = await browser.newPage();
  await page.goto('https://example.com');

  const title = await page.title();
  console.log('Page title:', title);

  await page.screenshot({ path: '/tmp/playwright-test.png' });
  console.log('Screenshot saved to /tmp/playwright-test.png');

  await browser.close();
  console.log('✅ Playwright + Chromium works!');
}

main().catch((err) => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
