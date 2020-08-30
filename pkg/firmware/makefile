# SLIM makefile for the 'firmware' package.

PKG = firmware
VER =
GET = NOOP
URL =
PRG =
TGZ =
SRC =
DST = $(rootfs)/lib/firmware

LICENSE  = Proprietary
LICFILE  =
UPSTREAM =
BINARIES =
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Installs fimrware images into the file system.

fetch:
unpack:
prep:
build:
stage:
install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -a fw/* $(DST)

clean:
distclean:

include depend.mk

