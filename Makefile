VERSION := 1.0.0
ZIP_NAME := CAROOT-v$(VERSION).zip
OUT_DIR := out

.PHONY: all verify zip release clean fix-perm

all: fix-perm verify zip

fix-perm:
	chmod +x scripts/*.sh utils/*.sh 2>/dev/null || true

verify: fix-perm
	@echo "🔐 Verifikasi Certificate..."
	@./utils/7_verify_cert.sh

zip:
	@echo "🗜️ Membuat ZIP: $(ZIP_NAME)"
	@mkdir -p $(OUT_DIR)
	@zip -r $(OUT_DIR)/$(ZIP_NAME) \
		cert/ \
		scripts/ \
		config/ \
		utils/ \
		.github/ \
		10_Makefile \
		11_README.md \
		2>/dev/null
	@echo "✅ Dibuat: $(OUT_DIR)/$(ZIP_NAME)"
	@ls -lh $(OUT_DIR)/

release: all
	@echo "✅ ======================================"
	@echo "✅ REPO: NSlocal/CAROOT — SIAP RELEASE!"
	@echo "✅ Push tag: git tag v$(VERSION) && git push origin v$(VERSION)"
	@echo "✅ ======================================"

clean:
	rm -rf $(OUT_DIR) downloads/
