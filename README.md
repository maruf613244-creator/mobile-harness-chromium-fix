# Mobile Harness Chromium Fix (Ubuntu 20.04 PRoot ARM64)

This repository contains a proven, working method to install a real Chromium browser inside **Mobile Harness** (Ubuntu 20.04 PRoot on Android ARM64) so that **Playwright** and **Puppeteer** can run correctly.

The official Playwright/Puppeteer browsers fail in this environment because:
- Architecture is ARM64
- PRoot has restricted sandbox / `/dev` / shared memory
- Ubuntu’s `chromium-browser` package is a Snap wrapper (Snap does not work reliably in PRoot)

## What this fix does

1. Installs a real Chromium 112 `.deb` (from Ubuntu 18.04 ports) that works on ARM64
2. Avoids the Snap version completely
3. Provides the correct `executablePath` + launch arguments needed for PRoot
4. Includes ready-to-use examples for Playwright and Puppeteer

## Quick Install (copy-paste into Mobile Harness Terminal)

**Important:** Mobile Harness runs every command in a new shell. Always use absolute paths and chain with `&&`.

```bash
cd /tmp && rm -f chromium-*.deb && wget -c http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb && wget -c http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb && ls -lh chromium-*.deb
```

```bash
cd /tmp && dpkg -i chromium-codecs-ffmpeg-extra_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb && dpkg -i chromium-browser_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb && apt --fix-broken install -y && apt install -y libatk-bridge2.0-0 libcups2 libpango-1.0-0 libx11-xcb1 xdg-utils
```

Verify:

```bash
which chromium-browser && chromium-browser --version
```

Expected output:
```
/usr/bin/chromium-browser
Chromium 112.0.5615.49 Built on Ubuntu , running on Ubuntu 20.04
```

## Recommended Launch Options

Always use these settings:

```js
{
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
}
```

Also set these environment variables when possible:

```bash
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
export CHROME_PATH=/usr/bin/chromium-browser
```

## Test Command (Playwright)

```bash
cd /workspace/your-project && npm install playwright@1.40.0 && node -e 'const { chromium } = require("playwright"); (async () => { const browser = await chromium.launch({ headless: true, executablePath: "/usr/bin/chromium-browser", args: ["--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--single-process", "--no-zygote"] }); const page = await browser.newPage(); await page.goto("https://example.com"); console.log("Title:", await page.title()); await browser.close(); console.log("✅ SUCCESS - Chromium works!"); })().catch(e => console.error("❌ Error:", e.message));'
```

## Files in this repository

- `scripts/install-chromium.sh` – automated install script
- `examples/playwright-example.js` – working Playwright example
- `examples/puppeteer-example.js` – working Puppeteer example
- `README.md` – this file

## Notes for Agents

When an agent is asked to “fix Chromium” or “make Playwright/Puppeteer work” inside Mobile Harness:

1. Check if `/usr/bin/chromium-browser` already exists and reports version 112.
2. If not, run the install commands above (or `bash scripts/install-chromium.sh`).
3. Always force `executablePath: '/usr/bin/chromium-browser'` and the six args listed.
4. Never rely on Playwright/Puppeteer downloading their own browser.
5. Remember Mobile Harness terminal rules: every command is a new shell → always chain with `&&` and use absolute paths.

## Credits

Solution developed and verified inside Mobile Harness (Ubuntu 20.04 PRoot ARM64) on 2026-11-03.
