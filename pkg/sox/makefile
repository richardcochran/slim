# SLIM makefile for the 'sox' package.

PKG = sox
VER = master
GET = git
URL = https://git.code.sf.net/p/sox/code
PRG = sox
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin
LIB = $(rootfs)/usr/lib

LICENSE  = GPL2
LICFILE  = $(SRC)/LICENSE.GPL
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = SoX reads and writes audio files in most popular formats and can optionally apply effects to them.

ac_flags += \
--disable-openmp \
--without-id3tag \
--without-ladspa \
--without-lame \
--without-libltdl \
--without-mad \
--without-magic \
--without-png \
--without-twolame

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) autoreconf -i
	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp $(stage)/usr/bin/$(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) cd $(DST) && ln -f -s sox play
	$(Q) mkdir -p $(LIB)
	$(Q) cp $(stage)/usr/lib/libsox.so.3.0.0 $(LIB)
	$(Q) $(CROSS_COMPILE)strip $(LIB)/libsox.so.3.0.0
	$(Q) cd $(LIB) && ln -f -s libsox.so.3.0.0 libsox.so
	$(Q) cd $(LIB) && ln -f -s libsox.so.3.0.0 libsox.so.3

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
