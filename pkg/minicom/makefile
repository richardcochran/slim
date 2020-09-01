# SLIM makefile for the 'minicom' package.

PKG = minicom
VER = master
GET = git
URL = https://salsa.debian.org/minicom-team/minicom.git
PRG = minicom runscript
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND = ncurses.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Minicom is a menu driven communications program. \
It emulates ANSI and VT102 terminals.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./autogen.sh
	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC)/src && cp $(PRG) $(DST)
	$(Q) for p in $(PRG); do \
		$(CROSS_COMPILE)strip $(DST)/$$p; \
	done
#	$(Q) $(start) -n 800 -f template.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
