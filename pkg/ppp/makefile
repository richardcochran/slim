# SLIM makefile for the 'ppp' package.

PKG = ppp
VER = master
GET = git
URL = git://git.ozlabs.org/~paulus/ppp.git
PRG = pppd
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

LICENSE  = BSD
LICFILE  = $(SRC)/README
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Point-to-Point Protocol (PPP) implementation for Linux

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && ./configure --prefix=/usr

build:
	$(Q) $(MAKE) $(J) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:
	$(Q) true

install:
	$(Q) mkdir -p $(DST)
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc INSTROOT=$(rootfs) \
		INSTALL="install --strip-program=$(CROSS_COMPILE)strip" install
#	$(Q) $(start) -n 800 -f template.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
