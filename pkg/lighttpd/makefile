# SLIM makefile for the 'lighttpd' package.

PKG = lighttpd
VER = 1.4.25
GET = wget
URL = http://download.lighttpd.net/lighttpd/releases-1.4.x
PRG = lighttpd
TGZ = $(PKG)-$(VER).tar.bz2
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/sbin

LICENSE  = BSD
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND = openssl.stage
BUILD_DEPEND = openssl.install
INSTALL_DEPEND = fcgi.install php.install

DESCRIPTION = lighttpd a secure, fast, compliant and very flexible \
web-server which has been optimized for high-performance \
environments. It has a very low memory footprint compared to other \
webservers and takes care of cpu-load.

WWW = $(rootfs)/www
MOD = $(rootfs)/usr/lib/lighttpd

MODULES = alias dirlisting fastcgi indexfile staticfile

ac_flags += --disable-rpath --enable-shared --libdir=/usr/lib/lighttpd \
--sysconfdir=/etc/lighttpd --with-openssl="$(stage)/usr" --with-zlib \
--without-attr --without-bzip2 --without-fam --without-gdbm \
--without-ldap --without-lua --without-memcache --without-mysql \
--without-pcre --without-valgrind --without-webdav-locks \
--without-webdav-props

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) mkdir -p $(MOD)
	$(Q) mkdir -p $(WWW)
	$(Q) cp $(stage)/usr/sbin/$(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) for m in $(MODULES); do \
		cp $(stage)/usr/lib/lighttpd/mod_$$m.so $(MOD) ; \
		$(CROSS_COMPILE)strip $(MOD)/mod_$$m.so ; \
	done
	$(Q) $(start) -n 810 -f lighttpd.init
	$(Q) cp lighttpd.conf $(rootfs)/etc
	$(Q) cp index.html $(WWW)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
