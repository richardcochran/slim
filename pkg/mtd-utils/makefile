# SLIM makefile for the 'mtd-utils' package.

PKG = mtd-utils
VER = v1.3.1
GET = git
URL = git://git.infradead.org/mtd-utils.git
PRG = flash_eraseall flash_lock flash_unlock flash_info flash_erase nandwrite
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
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Utilities for working with Memory Technology Devices under Linux. \
This package only builds the tools that are useful on an embedded computer.

BUILDDIR    = $(SRC)/build
TARGETS     = $(foreach target,$(PRG),$(BUILDDIR)/$(target))
UBI_TARGETS = $(foreach target,$(UBI_PRG),$(BUILDDIR)/$(target))
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
		BUILDDIR=$(BUILDDIR) CROSS=$(CROSS_COMPILE) WITHOUT_XATTR=1
	$(Q) $(ac_env) $(MAKE) -C $(SRC)/ubi-utils $(UBI_TARGETS) \
		BUILDDIR=$(BUILDDIR) CROSS=$(CROSS_COMPILE) WITHOUT_XATTR=1

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
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
