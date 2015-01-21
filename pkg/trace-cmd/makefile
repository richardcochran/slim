# SLIM makefile for the 'trace-cmd' package.

PKG = trace-cmd
VER = master
GET = git
URL = git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git
PRG = trace-cmd
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Provides tracing tools for the Linux kernel.

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
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
