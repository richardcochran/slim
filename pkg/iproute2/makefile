# SLIM makefile for the 'iproute2' package.

PKG = iproute2
VER = v5.0.0
GET = git
URL = git://git.kernel.org/pub/scm/network/iproute2/iproute2.git
PRG = ip
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = This is a set of utilities for Linux networking.

ac_env += PKG_CONFIG_LIBDIR=$(stage)/usr/lib/pkgconfig

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) for x in $(PRG); do \
		rm -f $(DST)/$$x; \
		cp $(stage)/sbin/$$x $(DST)/$$x; \
		$(CROSS_COMPILE)strip $(DST)/$$x; \
	done

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
