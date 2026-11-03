/**
 * Working Puppeteer example for Mobile Harness (Ubuntu 20.04 PRoot ARM64)
 * Requires: Chromium installed via the install script in this repo
 */

const puppeteer = require('puppeteer');

async function main() {
  const browser = await puppeteer.launch({
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

  await page.screenshot({ path: '/tmp/puppeteer-test.png' });
  console.log('Screenshot saved to /tmp/puppeteer-test.png');

  await browser.close();
  console.log('✅ Puppeteer + Chromium works!');
}

main().catch((err) => {
  console.error('❌ Error:', err.message);
  process.exit(1);
});
