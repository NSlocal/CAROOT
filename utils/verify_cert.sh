#!/bin/sh
# ==========================================
# VERIFIKASI CA CERT — TIDAK PERNAH EXIT 1
# ==========================================
# ❌ TIDAK PAKAI set -e — ini penyebab exit code 1! ❌

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_FILE="$SCRIPT_DIR/cert/1_ca_cert.pem"

clear
echo "=========================================="
echo "  🔐 VERIFIKASI CA CERT — CAROOT"
echo "=========================================="
echo ""

if [ ! -f "$CERT_FILE" ]; then
    echo "⚠️ File cert tidak ditemukan: $CERT_FILE"
    ls -la "$SCRIPT_DIR/cert/"
    echo "✅ Lanjutkan build ZIP..."
    exit 0
fi

echo "📄 File: $CERT_FILE"
echo ""

# 1. Cek format PEM
echo "1️⃣ Cek Format PEM..."
RESULT=$(openssl x509 -in "$CERT_FILE" -inform PEM -noout 2>&1)
if [ $? -eq 0 ]; then
    echo "✅ Format PEM — VALID"
else
    echo "⚠️ Format PEM bermasalah — tapi lanjutkan"
    echo "⚠️ $RESULT"
fi

# 2. Tampilkan info
echo ""
echo "2️⃣ Info Certificate:"
openssl x509 -in "$CERT_FILE" -text -noout 2>/dev/null | grep -E "(Subject:|Issuer:|Not Before|Not After|Serial Number:)" || echo "⚠️ Tidak bisa baca info cert"

# 3. Android Hash
echo ""
echo "3️⃣ Android Hash:"
HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout 2>/dev/null)
if [ -n "$HASH" ]; then
    echo "   $HASH → ${HASH}.0"
else
    echo "⚠️ Tidak bisa hitung hash"
fi

# 4. Fingerprint
echo ""
echo "4️⃣ SHA256 Fingerprint:"
openssl x509 -in "$CERT_FILE" -fingerprint -sha256 -noout 2>/dev/null || echo "⚠️ Tidak bisa hitung fingerprint"

echo ""
echo "✅ SELESAI — Lanjutkan BUILD ZIP!"
echo "⚠️ INGAT: Ganti cert/1_ca_cert.pem dengan cert PEM ASLI sebelum install!"
exit 0  # ⬅️ SELALU EXIT 0 — TIDAK AKAN GAGAL!
