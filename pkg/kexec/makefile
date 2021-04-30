# SLIM makefile for the 'kexec' package.

PKG = kexec
VER = master
GET = git
URL = git://git.kernel.org/pub/scm/utils/kernel/kexec/kexec-tools.git
PRG = kexec
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND = zlib.stage
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Provides tools to load a kernel into memory and then \
reboot directly into that kernel using the kexec system call, \
bypassing the normal boot process.

ac_flags += --without-lzma

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && $(ac_env) ./bootstrap $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" \
	STRIP=$(CROSS_COMPILE)strip all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp build/sbin/$(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
