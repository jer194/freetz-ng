PYTHON_DISTUTILSCROSS_VERSION:=0.1
PYTHON_DISTUTILSCROSS_SITE:=http://pypi.python.org/packages/source/d/distutilscross
PYTHON_DISTUTILSCROSS_SOURCE:=distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION).tar.gz
PYTHON_DISTUTILSCROSS_MD5:=700801380a336a01925ad8409ad98c25
PYTHON_DISTUTILSCROSS_DIR:=$(TARGET_TOOLCHAIN_DIR)/distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION)
PYTHON_DISTUTILSCROSS_BINARY:=$(TARGET_TOOLCHAIN_DIR)/distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION)/distutilscross/crosscompile.py

HOST_TOOLCHAIN_DIR:=$(FREETZ_BASE_DIR)/$(TOOLCHAIN_DIR)/host
PYTHON_DISTUTILSCROSS_SITE_PACKAGES:=$(HOST_TOOLCHAIN_DIR)/usr/lib/python2.7/site-packages
PYTHON_DISTUTILSCROSS_TARGET_BINARY:=$(PYTHON_DISTUTILSCROSS_SITE_PACKAGES)/distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION)-py2.7.egg

PYTHON_HOST:=$(PYTHON_HOST_TARGET_BINARY)
PYTHON_HOST_HOME:=$(HOST_TOOLCHAIN_DIR)/usr

$(DL_DIR)/$(PYTHON_DISTUTILSCROSS_SOURCE): | $(DL_DIR)
	$(DL_TOOL) $(DL_DIR) $(PYTHON_DISTUTILSCROSS_SOURCE) $(PYTHON_DISTUTILSCROSS_SITE) $(PYTHON_DISTUTILSCROSS_MD5)

$(PYTHON_DISTUTILSCROSS_DIR)/.unpacked: $(DL_DIR)/$(PYTHON_DISTUTILSCROSS_SOURCE) | $(TARGET_TOOLCHAIN_DIR)
	tar -C $(TARGET_TOOLCHAIN_DIR) $(VERBOSE) -xzf $(DL_DIR)/$(PYTHON_DISTUTILSCROSS_SOURCE)
	touch $@

$(PYTHON_DISTUTILSCROSS_DIR)/.configured: $(PYTHON_DISTUTILSCROSS_DIR)/.unpacked
	touch $@

$(PYTHON_DISTUTILSCROSS_BINARY): $(PYTHON_DISTUTILSCROSS_DIR)/.configured
	(mkdir -p $(PYTHON_DISTUTILSCROSS_SITE_PACKAGES); \
		cd $(PYTHON_DISTUTILSCROSS_DIR); \
		PYTHONHOME="$(PYTHON_HOST_HOME)" \
		$(PYTHON_HOST) setup.py build; \
	)
	touch -c $@

$(PYTHON_DISTUTILSCROSS_TARGET_BINARY): $(PYTHON_DISTUTILSCROSS_BINARY)
	(cd $(PYTHON_DISTUTILSCROSS_DIR); \
		PYTHONHOME="$(PYTHON_HOST_HOME)" \
		$(PYTHON_HOST) setup.py install; \
	)

python-distutilscross: python-host python-setuptools $(PYTHON_DISTUTILSCROSS_TARGET_BINARY)

python-distutilscross-unpacked: $(PYTHON_DISTUTILSCROSS_DIR)/.unpacked

python-distutilscross-configured: $(PYTHON_DISTUTILSCROSS_DIR)/.configured

python-distutilscross-source: $(DL_DIR)/$(PYTHON_DISTUTILSCROSS_SOURCE)

python-distutilscross-clean:
	(cd $(PYTHON_DISTUTILSCROSS_DIR); \
		PYTHONHOME="$(PYTHON_HOST_HOME)" \
		$(PYTHON_HOST) setup.py clean; \
	)

python-distutilscross-dirclean:
	$(RM) -r \
		$(PYTHON_DISTUTILSCROSS_DIR) \
		$(PYTHON_DISTUTILSCROSS_TARGET_BINARY) \
		$(HOST_TOOLCHAIN_DIR)/usr/lib/python2.7/site-packages/distutilscross*

.PHONY: python-distutilscross
