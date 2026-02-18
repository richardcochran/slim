# SLIM makefile for the 'tcl' package.

PKG = tcl
VER = main
GET = git
URL = https://github.com/tcltk/tcl.git
PRG = tclsh
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin
LIB = $(rootfs)/usr/lib

LICENSE  = BSD
LICFILE  = $(SRC)/license.terms
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND = zlib.stage
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Tcl provides a powerful platform for creating integration applications.

ac_flags += \
	--disable-zipfs \
	--enable-64bit

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC)/unix && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC)/unix DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC)/unix DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC)/unix && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) cp -d $(stage)/usr/lib/libtcl* $(LIB)
	$(Q) $(CROSS_COMPILE)strip $(LIB)/libtcl*so

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
