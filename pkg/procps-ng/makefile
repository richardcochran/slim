# SLIM makefile for the 'procps-ng' package.

PKG = procps-ng
VER = 3.3.11
GET = wget
URL = http://downloads.sourceforge.net/project/procps-ng/Production
PRG = ps top
TGZ = $(PKG)-$(VER).tar.xz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND = ncurses.stage
INSTALL_DEPEND = basefiles.install busybox.install

DESCRIPTION = Provides small useful utilities that give information \
about processes using the /proc filesystem.

ac_env += \
ac_cv_func_malloc_0_nonnull=yes \
ac_cv_func_realloc_0_nonnull=yes

ac_flags += \
--disable-nls \
--disable-rpath \
--disable-pidof \
--disable-kill \
--disable-wide-memory \
--disable-numa

export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" $(muffle)

stage:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) for p in $(PRG); do \
		if [ -L $(DST)/$$p ]; then \
			rm -f $(DST)/$$p; \
		fi \
	done
	$(Q) for p in $(PRG); do \
		cp $(stage)/usr/bin/$$p $(DST); \
		$(CROSS_COMPILE)strip $(DST)/$$p; \
	done
	$(Q) cp -a $(stage)/usr/lib/libprocps.so* $(rootfs)/usr/lib
	$(Q) $(CROSS_COMPILE)strip $(rootfs)/usr/lib/libprocps.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
