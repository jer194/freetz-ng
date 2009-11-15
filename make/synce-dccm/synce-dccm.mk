$(call PKG_INIT_BIN, 0.9.1)
$(PKG)_SOURCE:=$(pkg)-$($(PKG)_VERSION).tar.gz
$(PKG)_SITE:=@SF/synce
$(PKG)_BINARY:=$($(PKG)_DIR)/src/dccm
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/dccm
$(PKG)_SOURCE_MD5:=8818b71133049fe9c739166225aebe0c

$(PKG)_DEPENDS_ON := libsynce

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_CONFIGURE)

$($(PKG)_BINARY): $(SYNCE_DCCM_DIR)/.configured
	PATH="$(TARGET_PATH)" \
		$(MAKE) -C $(SYNCE_DCCM_DIR) \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)"

$(SYNCE_DCCM_TARGET_BINARY): $(SYNCE_DCCM_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)

$(pkg)-clean:
	-$(MAKE) -C $(SYNCE_DCCM_DIR) clean

$(pkg)-uninstall:
	$(RM) $(SYNCE_DCCM_TARGET_BINARY)

$(PKG_FINISH)
