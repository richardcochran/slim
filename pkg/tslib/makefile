# SLIM makefile for the 'tslib' package.

BROKEN = 1

# cp -d /home/richard/git/slim/beaglebone/stage/usr/lib/libts-1.0.so* /home/richard/git/slim/beaglebone/rootfs/usr/lib
# cp: cannot stat '/home/richard/git/slim/beaglebone/stage/usr/lib/libts-1.0.so*': No such file or directory
# make[1]: *** [makefile:55: install] Error 1

PKG = tslib
VER = master
GET = git
URL = git://github.com/kergoth/tslib.git
PRG = ts_calibrate ts_test
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/lib

LICENSE  = LGPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES = libts-0
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Tslib is an abstraction layer for touchscreen panel \
events, as well as a filter stack for the manipulation of those \
events. It was created by Russell King, of arm.linux.org.uk. Examples \
of implemented filters include jitter smoothing and the calibration \
transform.

ac_env += PKG_CONFIG_PATH=$(stage)/usr/lib/pkgconfig

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && ./autogen.sh
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(rootfs)/etc
	$(Q) mkdir -p $(rootfs)/usr/bin
	$(Q) cp ts.conf $(rootfs)/etc
	$(Q) mkdir -p $(DST)/ts
	$(Q) cd $(stage)/usr/bin && cp $(PRG) $(rootfs)/usr/bin
	$(Q) cp ts_calibrate.sh $(rootfs)/usr/bin
	$(Q) for p in $(PRG) ; do \
		$(CROSS_COMPILE)strip $(rootfs)/usr/bin/$$p ; \
	done
	$(Q) cp -d $(stage)/usr/lib/libts-1.0.so* $(DST)
	$(Q) cp -d $(stage)/usr/lib/ts/*.so $(DST)/ts
	$(Q) $(CROSS_COMPILE)strip $(DST)/libts-1.0.so*
	$(Q) $(CROSS_COMPILE)strip $(DST)/ts/*.so

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
