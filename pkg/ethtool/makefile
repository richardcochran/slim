# SLIM makefile for the 'ethtool' package.

PKG = ethtool
VER = master
GET = git
URL = git://git.kernel.org/pub/scm/network/ethtool/ethtool.git
PRG = ethtool
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND =

DESCRIPTION = Ethtool is a small utility for examining and tuning your \
ethernet-based network interface.

CATEGORY = networking

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && ./autogen.sh
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC)

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
ifndef SKIP_STRIP
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
endif

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
