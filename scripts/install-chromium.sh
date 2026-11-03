#!/bin/bash
# Mobile Harness Chromium Fix - Install Script
# Ubuntu 20.04 PRoot ARM64
# Safe to run multiple times

set -e

echo "=== Mobile Harness Chromium Installer ==="
echo "Target: Ubuntu 20.04 PRoot ARM64"
echo ""

# Check if already installed
if [ -x /usr/bin/chromium-browser ]; then
  VERSION=$(chromium-browser --version 2>/dev/null || true)
  if echo "$VERSION" | grep -q "112.0.5615.49"; then
    echo "✅ Chromium 112 already installed at /usr/bin/chromium-browser"
    echo "$VERSION"
    exit 0
  fi
fi

echo "→ Downloading real Chromium 112 ARM64 packages..."
cd /tmp
rm -f chromium-*.deb

wget -c http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-codecs-ffmpeg-extra_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb
wget -c http://ports.ubuntu.com/pool/universe/c/chromium-browser/chromium-browser_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb

echo ""
echo "→ Installing packages..."
dpkg -i chromium-codecs-ffmpeg-extra_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb || true
dpkg -i chromium-browser_112.0.5615.49-0ubuntu0.18.04.1_arm64.deb || true

echo ""
echo "→ Fixing dependencies..."
apt --fix-broken install -y
apt install -y libatk-bridge2.0-0 libcups2 libpango-1.0-0 libx11-xcb1 xdg-utils || true

echo ""
echo "→ Verifying installation..."
if which chromium-browser >/dev/null 2>&1; then
  echo "✅ SUCCESS"
  which chromium-browser
  chromium-browser --version
else
  echo "❌ Installation failed. Check the output above."
  exit 1
fi

echo ""
echo "=== Done ==="
echo "Use executablePath: '/usr/bin/chromium-browser'"
echo "Required args: --no-sandbox --disable-setuid-sandbox --disable-dev-shm-usage --disable-gpu --single-process --no-zygote"
