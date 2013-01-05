# SLIM makefile for the 'blob' package.

PKG = blob
VER =
GET = NOOP
URL =
PRG =
TGZ =
SRC =
DST = $(rootfs)/root

LICENSE  = Proprietary
LICFILE  =
UPSTREAM =
BINARIES =
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Just copy any kind of blob into the file system.

fetch:
unpack:
prep:
build:
stage:
install:
	$(Q) mkdir -p $(DST)
	$(Q) cp -a blob $(DST)

clean:
distclean:

include depend.mk
