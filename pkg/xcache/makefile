# SLIM makefile for the 'xcache' package.

BROKEN = 1

# --2020-08-29 21:51:49--  http://xcache.lighttpd.net/pub/Releases/1.3.0/xcache-1.3.0.tar.gz
# Resolving xcache.lighttpd.net (xcache.lighttpd.net)... 5.9.70.195, 2a01:4f8:161:80c9::2
# Connecting to xcache.lighttpd.net (xcache.lighttpd.net)|5.9.70.195|:80... connected.
# HTTP request sent, awaiting response... 404 Not Found
# 2020-08-29 21:51:50 ERROR 404: Not Found.

PKG = xcache
VER = 1.3.0
GET = wget
URL = http://xcache.lighttpd.net/pub/Releases/1.3.0
PRG = xcache.so
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/lib/php

LICENSE  = BSD
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES =
PROVIDES = xcache
CATEGORY = networking

PREP_DEPEND = php.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = XCache is a fast, stable PHP opcode cacher that has been \
tested and is now running on production servers under high load.

# Additional flags for xcache build
ac_flags += --enable-xcache --with-php-config=$(stage)/usr/bin/php-config
XCACHE_INC := . main TSRM Zend ext ext/date/lib
XCACHE_CFLAGS := $(addprefix -I$(stage)/usr/include/php/, $(XCACHE_INC))

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(stage)/usr/bin && \
	awk '{ print $0; } /^prefix=/ { print "prefix=$(stage)/usr"; }' phpize > phpize.cross
	$(Q) cd $(stage)/usr/bin && chmod +x phpize.cross
	$(Q) cd $(SRC) && $(stage)/usr/bin/phpize.cross $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc \
		EXTENSION_DIR=/usr/lib/php INCLUDES="$(XCACHE_CFLAGS)" \
		INSTALL_ROOT="$(stage)" $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) EXTENSION_DIR=/usr/lib/php \
		INSTALL_ROOT="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(stage)/usr/lib/php && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
