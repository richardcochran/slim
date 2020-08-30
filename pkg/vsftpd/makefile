# SLIM makefile for the 'vsftpd' package.

BROKEN = 1

# /opt/x-tools/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/../lib/gcc/arm-linux-gnueabihf/8.3.0/../../../../arm-linux-gnueabihf/bin/ld: cannot find -lnsl
# collect2: error: ld returned 1 exit status

PKG = vsftpd
VER = slim
GET = git
URL = git://github.com/richardcochran/vsftpd.git
PRG = vsftpd
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM = 70a7d3e94b79c11ed5122a28d3a1a13d8b642d1c
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = vsftpd is an FTP server, or daemon. The 'vs' stands for \
Very Secure. It is also extremely fast and scalable, powering \
some of the largest and most prestigious sites on the internet.

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER) -u $(UPSTREAM)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:

build:
	$(Q) $(MAKE) -C $(SRC) CC=$(CROSS_COMPILE)gcc

stage:

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp $(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) mkdir -p $(rootfs)/usr/share/empty
	$(Q) mkdir -p $(rootfs)/etc
	$(Q) cp vsftpd.conf $(rootfs)/etc
	$(Q) $(start) -n 820 -f vsftpd.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
