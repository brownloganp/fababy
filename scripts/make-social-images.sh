#!/usr/bin/env bash
# Renders each version's link-preview image (1200x630) and the shared iPhone icon (180x180)
# from the HTML sources in assets/og/ using headless Chrome. macOS only (uses sips).
set -euo pipefail
cd "$(dirname "$0")/.."

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

for v in teaser labor born; do
  "$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=1200,630 \
    --screenshot="$TMP/$v.png" "file://$PWD/assets/og/card.html?v=$v" >/dev/null 2>&1
  sips -s format jpeg -s formatOptions 88 "$TMP/$v.png" --out "versions/$v/og-image.jpg" >/dev/null
  echo "versions/$v/og-image.jpg"
done

"$CHROME" --headless=new --disable-gpu --hide-scrollbars --window-size=512,512 \
  --screenshot="$TMP/icon.png" "file://$PWD/assets/og/icon.html" >/dev/null 2>&1
sips -z 180 180 "$TMP/icon.png" --out versions/_shared/apple-touch-icon.png >/dev/null
echo "versions/_shared/apple-touch-icon.png"
