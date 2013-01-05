# SLIM makefile for the 'basefiles' package.

PKG = basefiles
VER =
GET = NOOP
URL =
PRG =
TGZ =
SRC =
DST =

LICENSE  = GPL2
LICFILE  =
UPSTREAM =
BINARIES =
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND =

DESCRIPTION = This package provides the basic structure of the root \
file system and the most essential configuration files.

fetch:
unpack:
prep:
build:
stage:

DIR = bin dev etc home/slim lib mnt proc root sbin tmp sys usr \
var/lib var/lock var/log var/run

DIR += \
etc/network/if-down.d \
etc/network/if-post-down.d \
etc/network/if-pre-up.d \
etc/network/if-up.d

ETC = fstab group inittab passwd shadow shutdown.sh

install:
	$(Q) for d in $(DIR); do mkdir -p $(rootfs)/$$d; done
	$(Q) chmod 1777 $(rootfs)/tmp
	$(Q) cd $(rootfs)/var && ln -s -f ../tmp tmp
	$(Q) for f in $(ETC); do cp $(etc)/$$f $(rootfs)/etc/$$f; done
	$(Q) cp $(etc)/hotplug $(rootfs)/sbin
	$(Q) cp $(etc)/interfaces $(rootfs)/etc/network
	$(Q) mkdir -p $(rootfs)/root/.ssh/
	$(Q) chmod -R go-rwx $(rootfs)/root/
	$(Q) cp $(etc)/authorized_keys $(rootfs)/root/.ssh

clean:
	$(Q) rm -Rf $(rootfs)/var/tmp

distclean: clean

include depend.mk
