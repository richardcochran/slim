# SLIM makefile for the 'ncurses' package.

PKG = ncurses
VER = 6.1
GET = wget
URL = http://ftp.gnu.org/pub/gnu/ncurses
PRG = ncurses
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/bin

LICENSE  = MIT
LICFILE  = $(SRC)/README
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = The Ncurses (new curses) library is a free software emulation of \
curses in System V Release 4.0, and more.

ac_flags += \
--without-cxx \
--without-cxx-binding \
--without-ada \
--without-manpages \
--without-progs \
--with-termlib \
--without-tests

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(rootfs)" install $(muffle)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) true

include depend.mk
