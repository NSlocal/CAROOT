#!/bin/sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_FILE="$SCRIPT_DIR/cert/1_ca_cert.pem"

clear
echo "=========================================="
echo "  🔐 VERIFIKASI CA CERT — CAROOT"
echo "=========================================="
echo ""

if [ ! -f "$CERT_FILE" ]; then
    echo "❌ File cert tidak ditemukan: $CERT_FILE"
    ls -la "$SCRIPT_DIR/cert/"
    exit 1
fi

echo "📄 File: $CERT_FILE"
echo ""

echo "1️⃣ Cek Format PEM..."
if openssl x509 -in "$CERT_FILE" -inform PEM -noout >/dev/null 2>&1; then
    echo "✅ Format PEM — VALID"
else
    echo "❌ Format PEM — GAGAL"
    exit 1
fi

echo ""
echo "2️⃣ Info Certificate:"
openssl x509 -in "$CERT_FILE" -text -noout | grep -E "(Subject:|Issuer:|Not Before|Not After)"

echo ""
echo "3️⃣ Android Hash:"
HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout)
echo "   $HASH → ${HASH}.0"

echo ""
echo "4️⃣ SHA256 Fingerprint:"
openssl x509 -in "$CERT_FILE" -fingerprint -sha256 -noout

echo ""
echo "✅ SELESAI — Cert OK!"
