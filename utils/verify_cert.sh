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

# 1. Cek format PEM
echo "1️⃣ Cek Format PEM..."
if openssl x509 -in "$CERT_FILE" -inform PEM -noout >/dev/null 2>&1; then
    echo "✅ Format PEM — VALID"
else
    echo "❌ Format PEM — GAGAL"
    echo "⚠️ Pastikan cert berawal: -----BEGIN CERTIFICATE-----"
    echo "⚠️ Dan berakhir: -----END CERTIFICATE-----"
    exit 1
fi

# 2. Tampilkan info cert
echo ""
echo "2️⃣ Info Certificate:"
openssl x509 -in "$CERT_FILE" -text -noout | grep -E "(Subject:|Issuer:|Not Before|Not After|Public Key Algorithm|Public-Key:|Serial Number)"

# 3. Android Hash
echo ""
echo "3️⃣ Android Certificate Hash:"
HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout)
echo "   Hash: $HASH"
echo "   Nama File Android: ${HASH}.0"

# 4. SHA256 Fingerprint
echo ""
echo "4️⃣ SHA256 Fingerprint:"
openssl x509 -in "$CERT_FILE" -fingerprint -sha256 -noout

# 5. Verifikasi — WARNING saja jika self-signed, TIDAK GAGAL
echo ""
echo "5️⃣ Verifikasi Certificate..."
if openssl verify -CAfile "$CERT_FILE" "$CERT_FILE" 2>&1; then
    echo "✅ Certificate — TRUSTED & VALID"
else
    echo "⚠️ Certificate Self-Signed — Normal untuk Root CA"
    echo "✅ Format OK — Lanjutkan (cocokkan fingerprint manual)"
fi

echo ""
echo "✅ VERIFIKASI SELESAI!"
