# SLIM makefile for the 'linuxptp' package.

PKG = linuxptp
VER = master
GET = git
URL = git://git.code.sf.net/p/linuxptp/code
PRG = ptp4l phc2sys hwstamp_ctl
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = This software is an implementation of the Precision Time \
Protocol (PTP) according to IEEE standard 1588 for Linux.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) true

export KBUILD_OUTPUT = $(stage)

build:
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) mkdir -p $(rootfs)/etc
ifndef SKIP_STRIP
	$(Q) cd $(SRC) && $(CROSS_COMPILE)strip $(PRG)
endif
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) cd $(SRC)/configs && cp default.cfg gPTP.cfg $(rootfs)/etc
#	$(Q) $(start) -n 800 -f template.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
