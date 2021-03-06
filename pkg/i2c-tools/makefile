# SLIM makefile for the 'i2ctools' package.

PKG = i2c-tools
VER = 3.1.1
GET = wget
URL = https://mirrors.edge.kernel.org/pub/software/utils/i2c-tools
PRG = i2cdetect i2cdump i2cget i2cset
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install busybox.install

DESCRIPTION = The i2c-tools package contains a heterogeneous set of \
I2C tools for Linux.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) true

build:
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) for p in $(PRG) ; do \
		if [ -L $(DST)/$$p ]; then \
			rm -f $(DST)/$$p; \
		fi ; \
	done
ifndef SKIP_STRIP
	$(Q) cd $(SRC)/tools && $(CROSS_COMPILE)strip $(PRG)
endif
	$(Q) cd $(SRC)/tools && cp $(PRG) $(DST)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
