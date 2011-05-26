# SLIM makefile for the 'fcgi' package.

PKG = fcgi
VER = 2.4.0
GET = wget
URL = http://www.fastcgi.com/dist
PRG = fcgi
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/lib

LICENSE  = MIT
LICFILE  = $(SRC)/LICENSE.TERMS
UPSTREAM =
BINARIES =
PROVIDES = libfcgi
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = FastCGI is an open extension to CGI that provides high \
performance for all Internet applications without the penalties of Web \
server APIs.

PATCH := $(shell pwd)/gcc-4.4-compile.patch

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && patch -p0 < $(PATCH) $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(stage)/usr/lib/libfcgi.so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libfcgi.so*

clean:
	$(Q) rm -f $(stage)/usr/lib/libfcgi*
	$(Q) rm -f $(rootfs)/usr/lib/libfcgi*
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -f $(stage)/usr/lib/libfcgi*
	$(Q) rm -f $(rootfs)/usr/lib/libfcgi*
	$(Q) rm -Rf $(SRC)

include depend.mk
