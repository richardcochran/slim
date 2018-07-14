# SLIM makefile for the 'glibc' package.

PKG = glibc
VER = NA
GET = NA
URL = NA
PRG =
TGZ =
DST = $(rootfs)/lib

LICENSE  = LGPL
LICFILE  = COPYING.LIB
UPSTREAM =
BINARIES =
PROVIDES = libstdc++ \
ld-linux \
libBrokenLocale \
libanl \
libc \
libcrypt \
libdl \
libgcc_s \
libm \
libnsl \
libnss_compat \
libnss_dns \
libnss_files \
libnss_hesiod \
libnss_nis \
libnss_nisplus \
libpthread \
libresolv \
librt \
libthread_db \
libutil
CATEGORY = libraries

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND =

DESCRIPTION = This package provides the standard C library.

fetch:
unpack:
prep:
build:

# The normal 'comply' script will not work for us.  So, we just copy
# the glibc sources ourselves.

SOURCES_DIR = $(shell ./findsources.sh)

stage:
ifneq ($(SOURCES_DIR),)
	$(Q) echo Found libc sources:
	$(Q) mkdir -p $(redist)/src
	$(Q) cp $(SOURCES_DIR)/* $(redist)/src
	$(Q) for f in $(SOURCES_DIR)/* ; do \
		echo "\t" $$f ; \
	done
endif

SRC     = $(shell ./findlibc.sh)
CXX_SRC = $(shell ./findstdcxx.sh)
GCC_SRC = $(shell ./findlibgcc.sh)
DST = $(rootfs)/lib
STAGE = $(stage)/lib

install:
	$(Q) echo "Found libc      in" $(SRC)
	$(Q) echo "Found libstdc++ in" $(CXX_SRC)
	$(Q) echo "Found libgcc_s  in" $(GCC_SRC)
	$(Q) mkdir -p $(STAGE)
	$(Q) mkdir -p $(DST)
	$(Q) for dest in $(DST) $(STAGE); do \
		cd $(SRC) && \
		tar cf - `find . -name lib\*.so\* -or -name ld\*so\*` | \
		(cd $$dest && tar xBf -); \
	done
	$(Q) cp -d $(CXX_SRC)/libstdc++.so* $(STAGE)
	$(Q) cp -d $(CXX_SRC)/libstdc++.so* $(DST)
	$(Q) cp -d $(GCC_SRC)/libgcc_s.so* $(STAGE)
	$(Q) cp -d $(GCC_SRC)/libgcc_s.so* $(DST)
	$(Q) rm -f $(DST)/debug/libstdc++.so*
#	Strip everything we can.
	$(Q) for f in `find $(DST) -type f` ; do \
		if $(CROSS_COMPILE)strip $$f ; then \
			echo "\t" $$f ; \
		fi \
	done
	$(Q) if [ -d $(SRC)/../lib64 ]; then \
		mkdir -p $(rootfs)/lib64 ; \
		cp -d $(SRC)/../lib64/* $(rootfs)/lib64 ; \
	fi

clean:
	$(Q) true

distclean: clean
	$(Q) true

include depend.mk
