#!/system/bin/sh
set -e
SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CERT_FILE="$SCRIPT_DIR/cert/1_ca_cert.pem"
SYSTEM_CERT_DIR="/system/etc/security/cacerts"
USER_CERT_DIR="/data/local/tmp/ca_certs"

clear
echo "=========================================="
echo "  🔑 INSTALL CA CERT — NSlocal/CAROOT"
echo "=========================================="
[ ! -f "$CERT_FILE" ] && { echo "❌ Tidak ada: $CERT_FILE"; exit 1; }

. "$SCRIPT_DIR/scripts/5_choose_mode.sh"

if [ "$INSTALL_MODE" = "root" ]; then
    echo "✅ === MODE ROOT ==="
    HASH=$(openssl x509 -in "$CERT_FILE" -hash -noout)
    SYSTEM_NAME="${HASH}.0"
    echo "📋 Hash: $HASH"
    mount -o remount,rw /system 2>/dev/null || true
    cp "$CERT_FILE" "$SYSTEM_CERT_DIR/$SYSTEM_NAME"
    chmod 644 "$SYSTEM_CERT_DIR/$SYSTEM_NAME"
    chown 0:0 "$SYSTEM_CERT_DIR/$SYSTEM_NAME"
    mount -o remount,ro /system 2>/dev/null || true
    echo "✅ Terinstall: $SYSTEM_CERT_DIR/$SYSTEM_NAME"
    echo "⚠️ REBOOT HP!"
else
    echo "✅ === MODE NON-ROOT ==="
    mkdir -p "$USER_CERT_DIR"
    cp "$CERT_FILE" "$USER_CERT_DIR/"
    echo "📄 Cert: $USER_CERT_DIR/1_ca_cert.pem"
    echo "👉 Settings → Security → Install Certificate → CA Certificate"
    echo "⚠️ Butuh kunci layar!"
fi
echo "✅ Verifikasi: ./utils/7_verify_cert.sh"
