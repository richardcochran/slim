# SLIM makefile for the 'linux' package.

PKG = linux
VER = v3.2
GET = git
URL = git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
PRG = linux
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
This package builds quite a recent kernel, with a configuration	supporting \
the specific hardware on the board.

#
# Look for a board specific configuration file.
#
CFG = $(shell [ -f $(brdcfg).$(PKG) ] && echo $(brdcfg).$(PKG) || echo Config)

#
# Build product depends on kernel architecture.
#
ifeq ($(karch),arm)
KERNEL = zImage
BOOT = arch/arm/boot
else ifeq ($(karch),m68k)
KERNEL = vmlinux
BOOT =
else ifeq ($(karch),powerpc)
KERNEL = uImage
BOOT = arch/powerpc/boot
else ifeq ($(karch),x86)
KERNEL = bzImage
BOOT = arch/x86/boot
endif

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cp $(CFG) $(SRC)/.config
	$(Q) $(MAKE) -C $(SRC) ARCH=$(karch) oldnoconfig $(muffle)
ifdef kconfig
	$(Q) $(MAKE) -C $(SRC) ARCH=$(karch) menuconfig
endif

build:
	$(Q) $(MAKE) $(J) -C $(SRC) ARCH=$(karch) all $(KERNEL)

stage:
	$(Q) $(MAKE) $(J) -C $(SRC) ARCH=$(karch) INSTALL_HDR_PATH=$(stage)/usr \
		headers_install

install:
	$(Q) grep -q CONFIG_MODULES=y $(SRC)/.config ; \
	if [ $$? = 0 ]; then \
	$(MAKE) $(J) -C $(SRC) ARCH=$(karch) INSTALL_MOD_PATH=$(rootfs) \
		modules_install ; \
	fi
	$(Q) cp $(SRC)/$(BOOT)/$(KERNEL) $(imgdir)/$(BOARD)-$(KERNEL)

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
