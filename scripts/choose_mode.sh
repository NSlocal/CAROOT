#!/bin/sh
echo "=========================================="
echo "  ⚙️ PILIH MODE INSTALL"
echo "=========================================="
echo ""
echo "  1) 🔓 ROOT — System Cert (Permanen)"
echo "  2) 🔒 NON-ROOT — User Cert (Tanpa Root)"
echo "  3) ❌ Keluar"
echo ""
printf "Pilihan [1-3]: "
read -r CHOICE

case "$CHOICE" in
    1)
        if [ "$(id -u)" -eq 0 ] 2>/dev/null; then
            INSTALL_MODE="root"; echo "✅ ROOT Mode"
        else
            echo "⚠️ Tidak ada Root → Non-Root..."
            INSTALL_MODE="nonroot"
        fi ;;
    2) INSTALL_MODE="nonroot"; echo "✅ NON-ROOT Mode" ;;
    3) exit 0 ;;
    *) echo "❌ Salah!"; exit 1 ;;
esac
export INSTALL_MODE
echo ""
