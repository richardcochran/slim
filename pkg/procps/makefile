# SLIM makefile for the 'procps' package.

PKG = procps
VER = 3.2.8
GET = wget
URL = http://procps.sourceforge.net
PRG = top
TGZ = $(PKG)-$(VER).tar.gz
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

DESCRIPTION = Provides small useful utilities that give information about \
processes using the /proc filesystem.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) true

build:
	$(Q) $(MAKE) -C $(SRC) $(ac_env)

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) if [ -L $(DST)/$(PRG) ]; then rm -f $(DST)/$(PRG); fi
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) cd $(SRC) && cp proc/libproc-3.2.8.so $(rootfs)/usr/lib
	$(Q) $(CROSS_COMPILE)strip $(rootfs)/usr/lib/libproc-3.2.8.so

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
