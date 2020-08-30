# SLIM makefile for the 'ntp' package.

PKG = ntp
VER = 4.2.8
GET = wget
URL = http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2
PRG = ntpd ntpdate
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/sbin

LICENSE  = BSD
LICFILE  = $(SRC)/COPYRIGHT
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND = openssl.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = The Network Time Protocol Version 4 (NTP) distribution.

PATCH := $(shell pwd)/work-around-certain-glibc-versions.patch

ac_flags += --disable-all-clocks --disable-parse-clocks
ac_flags += \
	--with-crypto=openssl \
	--with-openssl-incdir=$(stage)/usr/include \
	--with-openssl-libdir=$(stage)/usr/lib \
	--with-yielding-select=yes \

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && patch -p1 < $(PATCH) $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./bootstrap $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cp ntp.conf $(rootfs)/etc
	$(Q) for p in $(PRG) ; do \
		cd $(SRC) && cp $$p/$$p $(DST) ; \
		$(CROSS_COMPILE)strip $(DST)/$$p ; \
	done
	mkdir -p ${rootfs}/etc
	grep -q '^ntp[[:space:]]*123/udp' ${rootfs}/etc/services 2>/dev/null ; \
	[ $$? -ne 0 ] && echo "ntp            123/udp     # Network Time Protocol" >> ${rootfs}/etc/services ; \
	grep -q '^ntp[[:space:]]*123/tcp' ${rootfs}/etc/services 2>/dev/null ; \
	[ $$? -ne 0 ] && echo "ntp            123/tcp     # Network Time Protocol" >> ${rootfs}/etc/services ; \
	echo > /dev/null

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
