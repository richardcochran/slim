# SLIM makefile for the 'php' package.

PKG = php
VER = 5.3.1
GET = wget
URL = http://museum.php.net/php5
PRG = php-cgi
TGZ = $(PKG)-$(VER).tar.bz2
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/bin

LICENSE  = BSD
LICFILE  = $(SRC)/LICENSE
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND = zlib.stage openssl.stage
BUILD_DEPEND =
INSTALL_DEPEND = zlib.install openssl.install

DESCRIPTION = PHP is an HTML-embedded scripting language. Much of its \
syntax is borrowed from C, Java and Perl with a couple of unique \
PHP-specific features thrown in. The goal of the language is to allow \
web developers to write dynamically generated pages quickly.

ac_flags += \
--disable-all \
--enable-cgi \
--enable-magic-quotes \
--enable-session \
--disable-shared \
--with-config-file-path=/etc \
--with-zlib-dir="$(stage)/usr" \
--with-zlib="$(stage)/usr"

PWD    := $(shell pwd)
PATCH1 := $(PWD)/fix-dlopen.patch
PATCH2 := $(PWD)/fix-eabi-fp.patch
MDIR   := $(rootfs)/usr/lib/php
WWW    := $(rootfs)/www

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && patch -p1 < $(PATCH1) $(muffle)
	$(Q) cd $(SRC) && patch -p1 < $(PATCH2) $(muffle)
# Fails because of file not found.  Whatever.
#	$(Q) [ -f $(cache) ] && cp $(cache) $(SRC) || true
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) INSTALL_ROOT="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) INSTALL_ROOT="$(stage)" install $(muffle)

install: 
	$(Q) mkdir -p $(DST)
	$(Q) mkdir -p $(WWW)
	$(Q) cd $(stage)/usr/bin && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) mkdir -p $(MDIR)
	$(Q) cp php.ini $(rootfs)/etc
	$(Q) cp test.php $(WWW)
#	$(Q) cd $(SRC)/modules && cp *.so $(MDIR)
#	$(Q) $(CROSS_COMPILE)strip $(MDIR)/*.so

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
