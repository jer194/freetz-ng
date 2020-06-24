$(call PKG_INIT_BIN, 2020-06-24)
$(PKG)_SOURCE:=cacert-$($(PKG)_VERSION).pem
$(PKG)_SOURCE_SHA256:=726889705b00f736200ed7999f7a50021b8735d53228d679c4e6665aa3b44987
$(PKG)_SITE:=https://curl.haxx.se/ca

$(PKG)_BINARY:=$(DL_DIR)/$($(PKG)_SOURCE)
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/etc/ssl/certs/ca-bundle.crt

$(PKG)_STARTLEVEL=30

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_FILE)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:

$(pkg)-uninstall:
	$(RM) $(CA_BUNDLE_TARGET_BINARY)

$(PKG_FINISH)
