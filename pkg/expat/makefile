# SLIM makefile for the 'expat' package.

PKG = expat
VER = 2.0.1
GET = wget
URL = http://downloads.sourceforge.net/project/expat/expat/2.0.1
PRG = expat
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/lib

LICENSE  = MIT
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES =
PROVIDES = libexpat
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Expat is a C library for parsing XML.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(stage)/usr/lib/libexpat.so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libexpat.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
