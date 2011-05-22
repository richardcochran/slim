# SLIM makefile for the 'busybox' package.

PKG = busybox
VER = 1_16_0
GET = git
URL = git://git.busybox.net/busybox
PRG =
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/share/udhcpc

LICENSE  = GPL2
LICFILE  = $(SRC)/LICENSE
UPSTREAM = ""
BINARIES = busybox
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = BusyBox combines tiny versions of many common UNIX utilities \
into a single small executable. BusyBox provides a fairly complete POSIX \
environment for any small system, both embedded environments and more full \
featured systems concerned about space.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER) -u $(UPSTREAM)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cp Config $(SRC)/.config
	$(Q) $(MAKE) -C $(SRC) silentoldconfig $(muffle)
ifdef kconfig
	$(Q) $(MAKE) -C $(SRC) menuconfig
endif

build:
	$(Q) $(MAKE) $(J) -C $(SRC)

stage:
	$(Q) true

install:
	$(Q) $(MAKE) -C $(SRC) CONFIG_PREFIX=$(rootfs) install $(muffle)
	$(Q) mkdir -p $(DST)
	$(Q) cp -a default.script $(DST)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
