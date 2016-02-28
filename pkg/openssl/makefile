# SLIM makefile for the 'openssl' package.

PKG = openssl
VER = 1.0.2f
GET = wget
URL = http://www.openssl.org/source
PRG =
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/lib

LICENSE  = BSD
LICFILE  = $(SRC)/LICENSE
UPSTREAM =
BINARIES =
PROVIDES = libcrypto libssl
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND = zlib.stage
INSTALL_DEPEND =

DESCRIPTION = OpenSSL is robust, commercial-grade, fully featured, and \
Open Source toolkit implementing the Secure Sockets Layer (SSL v2/v3) \
and Transport Layer Security (TLS v1) protocols as well as a general \
purpose cryptography library.

PATCH = $(shell pwd)/cross-compile.patch

CIPHERS = no-idea no-md2 no-mdc2 no-rc2 no-rc5 no-sha0 no-smime \
no-rmd160 no-aes192 no-camellia no-ans1 no-krb5

OPTIONS = shared no-ec no-err no-fips no-hw no-threads zlib-dynamic \
no-engines no-sse2 no-perlasm

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && patch -p1 < $(PATCH) $(muffle)
	$(Q) cd $(SRC) && ./Configure linux-cross \
		--prefix=/usr -ldl -DOPENSSL_SMALL_FOOTPRINT \
		$(CIPHERS) $(OPTIONS) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) \
		EXTRA_CFLAGS="-I$(stage)/usr/include" \
		depend $(muffle)
	$(Q) mkdir -p $(stage)/usr
	$(Q) $(MAKE) -C $(SRC) \
		EXTRA_CFLAGS="-I$(stage)/usr/include" \
		CC="$(CROSS_COMPILE)gcc" \
		AR="$(CROSS_COMPILE)ar r" \
		RANLIB="$(CROSS_COMPILE)ranlib" \
		all build-shared $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) \
		EXTRA_CFLAGS="-I$(stage)/usr/include" \
		CC="$(CROSS_COMPILE)gcc" \
		AR="$(CROSS_COMPILE)ar r" \
		RANLIB="$(CROSS_COMPILE)ranlib" \
		INSTALL_PREFIX=$(stage) \
		install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -d $(stage)/usr/lib/libcrypto.so.* $(DST)
	$(Q) cp -d $(stage)/usr/lib/libssl.so.* $(DST)
	$(Q) chmod +w $(DST)/libcrypto.so.*
	$(Q) chmod +w $(DST)/libssl.so.*
	$(Q) $(CROSS_COMPILE)strip $(DST)/libcrypto.so.*
	$(Q) $(CROSS_COMPILE)strip $(DST)/libssl.so.*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
