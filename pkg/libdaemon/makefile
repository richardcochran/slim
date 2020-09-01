# SLIM makefile for the 'libdaemon' package.

PKG = libdaemon
VER = cross
GET = git
URL = git://github.com/richardcochran/libdaemon.git
PRG = libdaemon
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/lib

LICENSE  = LGPL2
LICFILE  = $(SRC)/LICENSE
UPSTREAM = v0.14
BINARIES =
PROVIDES = libdaemon
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = A lightweight C library to make writing UNIX daemons easier.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER) -u $(UPSTREAM)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && NOCONFIGURE=1 ./bootstrap.sh $(muffle)
	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(stage)/usr/lib/libdaemon.so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libdaemon.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
