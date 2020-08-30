# SLIM makefile for the 'ipipe' package.

BROKEN = 1

# This still builds for the BBB, but it won't boot.  The upstream
# ipipe repo ends its support at kernel 4.9.x, and after that there
# are per-arch repos.  What a mess. Even the more recent repos are
# lagging a year behind, currently 4.19.x at the time of this writing.
#
# See:
#    https://gitlab.denx.de/Xenomai

PKG = ipipe
VER = $(ipipe_vers)
GET = git
URL = git://git.xenomai.org/ipipe.git
PRG = ipipe
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST =

LICENSE  = GPL2
LICFILE  = $(SRC)/COPYING
UPSTREAM =
BINARIES =
PROVIDES =
CATEGORY = main

PREP_DEPEND =
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = The Linux kernel is heart of any GNU/Linux powered computer. \
This package provides a kernel with the ipipe extension for use with xenomai. \
Note that this package only fetches and unpacks the sources. The actual build \
is done by the xenomai package.

#
# Look for a board specific configuration file.
#
CFG = $(shell [ -f $(brdcfg).$(PKG) ] && echo $(brdcfg).$(PKG) || echo Config)

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) if [ -f $(CFG) ]; then \
		cp $(CFG) $(SRC)/.config; \
	fi

build:
stage:
install:
clean:

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
