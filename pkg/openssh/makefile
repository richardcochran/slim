# SLIM makefile for the 'openssh' package.

PKG = openssh
VER = 7.1p2
GET = wget
URL = ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable
PRG = scp sftp ssh ssh-keygen
TGZ = $(PKG)-$(VER).tar.gz
SRC = $(build)/$(PKG)-$(VER)
DST = $(rootfs)/usr/bin

LICENSE  = BSD
LICFILE  = $(SRC)/LICENCE
UPSTREAM =
BINARIES = $(PRG) sshd sftp-server
PROVIDES =
CATEGORY = networking

PREP_DEPEND = zlib.stage openssl.stage
BUILD_DEPEND =
INSTALL_DEPEND = zlib.install openssl.install basefiles.install

DESCRIPTION = The Secure SHell, a port of the OpenBSD OpenSSH to Linux.

ac_flags += \
	--sysconfdir=/etc/ssh \
	--disable-strip \
	--disable-etc-default-login \
	--disable-lastlog \
	--disable-utmp \
	--disable-utmpx \
	--disable-wtmp \
	--disable-wtmpx \
	--without-bsd-auth \
	--without-kerberos5 \
	--without-pam

SBIN = $(rootfs)/usr/sbin
ETC  = $(rootfs)/etc

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) for p in $(PRG); do cp $(SRC)/$$p $(DST); done
	$(Q) for p in $(PRG); do $(CROSS_COMPILE)strip $(DST)/$$p; done
	$(Q) mkdir -p $(SBIN)
	$(Q) cp $(SRC)/sshd $(SBIN)
	$(Q) $(CROSS_COMPILE)strip $(SBIN)/sshd
	$(Q) mkdir -p $(rootfs)/usr/libexec
	$(Q) cp $(SRC)/sftp-server $(rootfs)/usr/libexec
	$(Q) $(CROSS_COMPILE)strip $(rootfs)/usr/libexec/sftp-server
	$(Q) mkdir -p $(ETC)/ssh
	$(Q) cp sshd_config $(ETC)/ssh
	$(Q) cd $(SRC) && cp moduli $(ETC)/ssh
	$(Q) mkdir -p $(ETC)/ssh/backup
	$(Q) touch $(ETC)/ssh/default_key
	$(Q) chmod go-r ssh_host_dsa_key ssh_host_rsa_key
	$(Q) cp -d ssh_host_dsa_key ssh_host_rsa_key $(ETC)/ssh/
	$(Q) $(start) -n 950 -f openssh.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)

include depend.mk
