# SLIM makefile for the 'zlib' package.

PKG = zlib
VER = master
GET = git
URL = git://github.com/madler/zlib.git
PRG =
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/lib

LICENSE  = BSD
LICFILE  = $(SRC)/README
UPSTREAM =
BINARIES =
PROVIDES = libz
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND =

DESCRIPTION = zlib is a general purpose data compression library.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && \
	LDSHARED="${CROSS_COMPILE}gcc -shared -Wl,-soname,libz.so.1" \
	CC=${CROSS_COMPILE}gcc \
	prefix=$(stage)/usr ./configure --shared $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC)

stage:
	$(Q) $(MAKE) -C $(SRC) install

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(stage)/usr/lib/libz.so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libz.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
