# SLIM makefile for the 'boost' package.

PKG = boost
VER = 1_72_0
GET = wget
URL = https://dl.bintray.com/boostorg/release/1.72.0/source
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
		$(SRC)/user-config.jam

# The file, user-config.jam, must be in the HOME directory.  Brilliant.

build:
	$(Q) cd $(SRC) && HOME=$(SRC) ./b2 \
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
	$(Q) cp -d $(SRC)/stage/lib/libboost*so* $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/libboost*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
