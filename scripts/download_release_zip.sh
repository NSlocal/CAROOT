#!/bin/sh
# ==========================================
# 🤖 BOT DOWNLOAD RELEASE ZIP — NSlocal/CAROOT
# Repo: https://github.com/NSlocal/CAROOT
# ==========================================
set -e

GITHUB_REPO="NSlocal/CAROOT"
ZIP_PREFIX="CAROOT-v"

clear
echo "=========================================="
echo "  🤖 BOT DOWNLOAD RELEASE ZIP"
echo "  Repo: $GITHUB_REPO"
echo "=========================================="
echo ""

command -v curl >/dev/null 2>&1 || { echo "❌ curl tidak ada"; exit 1; }

echo "🔍 Mencari release terbaru..."
RELEASE_JSON=$(curl -s "https://api.github.com/repos/$GITHUB_REPO/releases/latest")

if echo "$RELEASE_JSON" | grep -q '"message": "Not Found"'; then
    echo "❌ Belum ada Release!"
    echo "👉 Buat tag: git tag v1.0.0 && git push origin v1.0.0"
    echo "👉 Action akan build ZIP otomatis!"
    exit 1
fi

TAG_NAME=$(echo "$RELEASE_JSON" | grep '"tag_name"' | head -1 | sed -E 's/.*"tag_name": "([^"]+)".*/\1/')
VERSION=$(echo "$TAG_NAME" | sed 's/v//')
ZIP_NAME="${ZIP_PREFIX}${VERSION}.zip"

echo "✅ Versi: $TAG_NAME → $ZIP_NAME"
echo ""

ASSET_URL=$(echo "$RELEASE_JSON" | grep -Eo '"browser_download_url": "[^"]+' | grep "$ZIP_NAME" | sed -E 's/"browser_download_url": "//')

if [ -z "$ASSET_URL" ]; then
    echo "⚠️ ZIP tidak ketemu — manual: https://github.com/$GITHUB_REPO/releases"
    exit 1
fi

echo "📥 Download: $ASSET_URL"
curl -L -f -o "$ZIP_NAME" "$ASSET_URL"

if [ -f "$ZIP_NAME" ] && [ -s "$ZIP_NAME" ]; then
    echo "✅ SUKSES: $ZIP_NAME ($(du -h "$ZIP_NAME" | cut -f1))"
    echo "👉 Extract: unzip $ZIP_NAME"
    echo "👉 Install: ./scripts/4_install_cert.sh"
else
    echo "❌ GAGAL!"; exit 1
fi
