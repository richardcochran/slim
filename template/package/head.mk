# SLIM makefile for the 'template' package.

PKG = template
VER = @VER@
GET = @GET@
URL = @URL@
PRG = template
TGZ = @TGZ@
SRC = @SRC@
DST = $(rootfs)/usr/bin

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION =

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

