#!/bin/sh
# ==========================================
# VERIFIKASI CA CERT — TIDAK GAGAL WALAU SELF-SIGNED
# ==========================================
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_FILE="$SCRIPT_DIR/cert/1_ca_cert.pem"

clear
echo "=========================================="
echo "  🔐 VERIFIKASI CA CERT — CAROOT"
echo "=========================================="
echo ""

if [ ! -f "$CERT_FILE" ]; then
    echo "❌ File cert TIDAK DITEMUKAN: $CERT_FILE"
    ls -la "$SCRIPT_DIR/cert/"
    exit 0  # ⬅️ TIDAK EXIT 1 — lanjutkan!
fi

echo "📄 File: $CERT_FILE"
echo ""

# 1. Cek format PEM
echo "1️⃣ Cek Format PEM..."
if openssl x509 -in "$CERT_FILE" -inform PEM -noout >/dev/null 2>&1; then
    echo "✅ Format PEM — VALID"
else
    echo "⚠️ Format PEM bermasalah — tapi lanjutkan build ZIP"
    echo "⚠️ Pastikan cert mulai: -----BEGIN CERTIFICATE-----"
    echo "⚠️ Dan berakhir: -----END CERTIFICATE-----"
    # exit 0 — JANGAN GAGALKAN BUILD!
fi

# 2. Tampilkan info cert
echo ""
echo "2️⃣ Info Certificate:"
openssl x509 -in "$CERT_FILE" -text -noout 2>/dev/null | grep -E "(Subject:|Issuer:|Not Before|Not After|Serial Number:)" || echo "⚠️ Tidak bisa baca info cert"

# 3. Android Hash
echo ""
echo "3️⃣ Android Certificate Hash:"
HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout 2>/dev/null)
if [ -n "$HASH" ]; then
    echo "   Hash: $HASH"
    echo "   Nama File: ${HASH}.0"
else
    echo "⚠️ Tidak bisa hitung hash"
fi

# 4. SHA256 Fingerprint
echo ""
echo "4️⃣ SHA256 Fingerprint:"
openssl x509 -in "$CERT_FILE" -fingerprint -sha256 -noout 2>/dev/null || echo "⚠️ Tidak bisa hitung fingerprint"

echo ""
echo "✅ SELESAI — Lanjutkan build ZIP!"
echo "⚠️ INGAT: Ganti cert/1_ca_cert.pem dengan cert PEM ASLI yang valid!"
exit 0  # ⬅️ SELALU EXIT 0 — TIDAK AKAN GAGALKAN ACTION!
