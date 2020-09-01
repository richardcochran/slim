# SLIM makefile for the 'libpng' package.

PKG = libpng
VER = v1.2.44
GET = git
URL = git://libpng.git.sourceforge.net/gitroot/libpng/libpng
PRG =
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/lib

LICENSE  = MIT
LICFILE  = $(SRC)/LICENSE
UPSTREAM =
BINARIES =
PROVIDES = libpng
CATEGORY = libraries

PREP_DEPEND = zlib.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = The official PNG reference library. It supports almost \
all PNG features, is extensible, and has been extensively tested for \
over 15 years.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)
unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(stage)/usr/lib && cp -d libpng*so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libpng*so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
