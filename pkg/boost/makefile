# SLIM makefile for the 'boost' package.

BROKEN = 1

# Only installs:
# /rootfs/usr/lib/libboost_system.a
# /rootfs/usr/lib/libboost_system.so.1.43.0
# /rootfs/usr/lib/libboost_system.so
#
# Thread support fails with ARM GCC 8.3

PKG = boost
VER = 1_43_0
GET = wget
URL = http://downloads.sourceforge.net/project/boost/boost/1.43.0
PRG =
TGZ = $(PKG)_$(VER).tar.bz2
SRC = $(build)/$(PKG)_$(VER)
DST = $(rootfs)/usr/lib

LICENSE  = MIT
LICFILE  = $(SRC)/LICENSE_1_0.txt
UPSTREAM =
BINARIES =
PROVIDES = libboost_date_time libboost_system libboost_thread
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Boost provides free peer-reviewed portable C++ source \
libraries. Boost emphasizes libraries that work well with the C++ \
Standard Library.

GCCVER = $(shell $(CROSS_COMPILE)gcc -dumpversion)

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && ./bootstrap.sh
	$(Q) printf "using gcc : %s : %s ;\n" $(GCCVER) $(CROSS_COMPILE)gcc > \
		$(SRC)/tools/build/v2/user-config.jam

build:
	$(Q) cd $(SRC) && ./bjam \
		--with-date_time \
		--with-program_options \
		--with-system \
		--with-thread

stage:
	$(Q) mkdir -p $(stage)/usr/include
	$(Q) mkdir -p $(stage)/usr/lib
	$(Q) cp -a $(SRC)/boost $(stage)/usr/include
	$(Q) cp -d $(SRC)/stage/lib/libboost* $(stage)/usr/lib

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(SRC)/stage/lib/libboost* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libboost*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
