# SLIM makefile for the 'mtd-utils' package.

BROKEN = 1

# /opt/x-tools/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/8.3.0/../../../../arm-linux-gnueabihf/bin/ld: /home/richard/git/slim/beaglebone/build/mtd-utils/build/lib/libmtd.a(libmtd.o): in function `dev_node2num':
# /home/richard/git/slim/beaglebone/build/mtd-utils/lib/libmtd.c:446: undefined reference to `major'
# /opt/x-tools/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/8.3.0/../../../../arm-linux-gnueabihf/bin/ld: /home/richard/git/slim/beaglebone/build/mtd-utils/lib/libmtd.c:447: undefined reference to `minor'
# /opt/x-tools/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/8.3.0/../../../../arm-linux-gnueabihf/bin/ld: /home/richard/git/slim/beaglebone/build/mtd-utils/build/lib/libmtd.a(libmtd_legacy.o): in function `legacy_get_dev_info':
# /home/richard/git/slim/beaglebone/build/mtd-utils/lib/libmtd_legacy.c:254: undefined reference to `major'
# /opt/x-tools/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/8.3.0/../../../../arm-linux-gnueabihf/bin/ld: /home/richard/git/slim/beaglebone/build/mtd-utils/lib/libmtd_legacy.c:255: undefined reference to `minor'

PKG = mtd-utils
VER = v1.5.1
GET = git
URL = git://git.infradead.org/mtd-utils.git
PRG = flash_lock flash_unlock flash_erase nandwrite
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

UBI_PRG = ubiattach ubidetach ubiupdatevol ubiformat ubimkvol ubirename ubinfo \
ubirmvol mtdinfo

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG) $(UBI_PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install busybox.install

DESCRIPTION = Utilities for working with Memory Technology Devices under Linux. \
This package only builds the tools that are useful on an embedded computer.

BUILDDIR    = $(SRC)/build
TARGETS     = $(foreach target,$(PRG),$(BUILDDIR)/$(target))
UBI_TARGETS = $(foreach target,$(UBI_PRG),$(BUILDDIR)/ubi-utils/$(target))
ALL_TARGETS = $(TARGETS) $(UBI_TARGETS)
ALL_PRGS    = $(PRG) $(UBI_PRG)

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) mkdir -p $(BUILDDIR)

build:
	$(Q) $(ac_env) $(MAKE) -C $(SRC) $(TARGETS) \
		BUILDDIR=$(BUILDDIR) CROSS=$(CROSS_COMPILE) WITHOUT_XATTR=1 \
		WITHOUT_LZO=1
	$(Q) $(ac_env) $(MAKE) -C $(SRC) $(UBI_TARGETS) \
		BUILDDIR=$(BUILDDIR) CROSS=$(CROSS_COMPILE) WITHOUT_XATTR=1 \
		WITHOUT_LZO=1

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) for p in $(ALL_PRGS) ; do \
		if [ -L $(DST)/$$p ]; then \
			rm -f $(DST)/$$p; \
		fi ; \
	done
	$(Q) for p in $(ALL_TARGETS) ; do \
		cp $$p $(DST) ; \
	done
	$(Q) for p in $(ALL_PRGS) ; do \
		$(CROSS_COMPILE)strip $(DST)/$$p ; \
	done

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
