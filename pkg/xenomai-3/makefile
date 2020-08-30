# SLIM makefile for the 'xenomai-3' package.

BROKEN = 1

# This still builds for the BBB, but it won't boot.  See the ipipe
# package for more info.

PKG = xenomai-3
VER = master
GET = git
URL = git://git.xenomai.org/xenomai-3.git
PRG = latency
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/xenomai

LICENSE  = GPL2
LICFILE  = $(SRC)/include/COPYING
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = main

PREP_DEPEND = ipipe.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Xenomai is a versatile Free Software framework for \
implementing and migrating real-time applications, based on standard \
APIs or accurate emulation of proprietary RTOS interfaces.

IPIPE_SRC = $(build)/ipipe

ac_flags += \
	--disable-doc-install \
	--enable-smp \
	--prefix=/usr/xenomai \
	--with-core=cobalt

#
# The Linux kernel build product depends on kernel architecture.
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
	$(Q) cd $(SRC) && ./scripts/prepare-kernel.sh \
		--arch=$(karch) --linux=../ipipe $(muffle)
ifdef kconfig
	$(Q) $(MAKE) -C $(IPIPE_SRC) ARCH=$(karch) menuconfig
else
	$(Q) $(MAKE) -C $(IPIPE_SRC) ARCH=$(karch) oldnoconfig $(muffle)
endif
	$(Q) printf "   BUILD    ipipe (for xenomai-3)\n"
	$(Q) $(MAKE) $(J) -C $(IPIPE_SRC) ARCH=$(karch) all $(KERNEL)
ifneq ($(kdtb),)
	$(Q) $(MAKE) -C $(IPIPE_SRC) ARCH=$(karch) all $(kdtb)
endif
	$(Q) printf "   STAGE    ipipe (for xenomai-3)\n"
	$(Q) mkdir -p $(stage)/usr/include
	$(Q) TMP=`mktemp -d`; \
		$(MAKE) $(J) -C $(IPIPE_SRC) ARCH=$(karch) INSTALL_HDR_PATH=$$TMP \
		headers_install; \
		cp -r $$TMP/include/* $(stage)/usr/include; \
		rm -Rf $$TMP
	$(Q) cd $(SRC) && ./scripts/bootstrap $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" SUDO=false install $(muffle)

install:
	$(Q) printf "   INSTALL  ipipe (for xenomai-3)\n"
	$(Q) grep -q CONFIG_MODULES=y $(IPIPE_SRC)/.config ; \
	if [ $$? = 0 ]; then \
	$(MAKE) $(J) -C $(IPIPE_SRC) ARCH=$(karch) INSTALL_MOD_PATH=$(rootfs) \
		INSTALL_MOD_STRIP="--strip-unneeded" \
		modules_install ; \
	fi
	$(Q) cp $(IPIPE_SRC)/$(BOOT)/$(KERNEL) $(imgdir)/$(BOARD)-$(KERNEL).xeno
ifeq ($(krfs),y)
	$(Q) mkdir -p $(rootfs)/boot
	$(Q) cp $(IPIPE_SRC)/$(BOOT)/$(KERNEL) $(rootfs)/boot/$(BOARD)-$(KERNEL).xeno
endif
ifneq ($(kdtb),)
	$(Q) cp $(IPIPE_SRC)/$(BOOT)/dts/$(kdtb) $(imgdir)/$(kdtb).xeno
ifeq ($(krfs),y)
	$(Q) cp $(IPIPE_SRC)/$(BOOT)/dts/$(kdtb) $(rootfs)/boot/$(kdtb).xeno
endif
endif
	$(Q) mkdir -p $(DST)/bin
	$(Q) cd $(stage)/usr/xenomai/bin && \
		for p in $(PRG); do \
			cp $$p $(DST)/bin; \
			$(CROSS_COMPILE)strip $(DST)/bin/$(PRG); \
		done
	$(Q) cp -a $(stage)/usr/xenomai/bin/dohell $(DST)/bin
	$(Q) mkdir -p $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libalchemy.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libanalogy.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libcobalt.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libcopperplate.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libpsos.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libsmokey.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libtrank.so* $(DST)/lib
	$(Q) cp -d $(stage)/usr/xenomai/lib/libvxworks.so* $(DST)/lib
	$(Q) $(CROSS_COMPILE)strip $(DST)/lib/lib*.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
