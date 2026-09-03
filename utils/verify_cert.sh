#!/system/bin/sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_FILE="$SCRIPT_DIR/cert/1_ca_cert.pem"

clear
echo "=========================================="
echo "  🔐 VERIFIKASI CA CERT — CAROOT"
echo "=========================================="
[ ! -f "$CERT_FILE" ] && { echo "❌ Tidak ada: $CERT_FILE"; exit 1; }

echo "📄 File: $CERT_FILE"
echo ""
echo "1️⃣ Format PEM..."
openssl x509 -in "$CERT_FILE" -inform PEM -noout >/dev/null 2>&1 && echo "✅ PEM OK" || echo "❌ PEM GAGAL"

echo ""
echo "2️⃣ Info Cert:"
openssl x509 -in "$CERT_FILE" -text -noout | grep -E "(Subject:|Issuer:|Not Before|Not After)"

echo ""
echo "3️⃣ Android Hash:"
HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout)
echo "   $HASH → ${HASH}.0"

echo ""
echo "4️⃣ SHA256 Fingerprint:"
openssl x509 -in "$CERT_FILE" -fingerprint -sha256 -noout

echo ""
echo "✅ CERT VALID — NSlocal/CAROOT"
