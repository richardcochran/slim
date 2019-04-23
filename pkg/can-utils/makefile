# SLIM makefile for the 'can-utils' package.

PKG = can-utils
VER = master
GET = git
URL = https://github.com/linux-can/can-utils.git
PRG = candump canplayer
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = candump.c
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = This package contains some userspace utilities for the \
Linux CAN subsystem (aka SocketCAN).

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./autogen.sh $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) for x in $(PRG); do \
		$(CROSS_COMPILE)strip $(DST)/$$x; \
	done

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
