# Simple Linux Image Maker
# Copyright (C) 2011 OMICRON electronics GmbH.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License version 2 as
# published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA

#------------------------------------------------------------------------------
# Customizable variables
#------------------------------------------------------------------------------
BOARD          ?= generic
Q              ?= @

#------------------------------------------------------------------------------
# Do not change any of the following variables.
#------------------------------------------------------------------------------
out = $(BOARD)
pwd = $(shell pwd)

#
# Always include the configuration.
#
config = .config.$(BOARD)
-include $(config)

#
# Directories for the board's build products.
#
export imgdir = $(pwd)/$(out)
export build  = $(pwd)/$(out)/build
export dld    = $(pwd)/$(out)/download
export redist = $(pwd)/$(out)/redist
export rootfs = $(pwd)/$(out)/rootfs
export stage  = $(pwd)/$(out)/stage
export stamp  = $(out)/stamp

dirs = $(build) $(dld) download $(redist) $(rootfs) $(stage) $(stamp)

#
# Scripts for the package makefiles.
#
export brdcfg = $(pwd)/config/$(BOARD)/Config
export cache  = $(pwd)/config/$(BOARD)/config.cache
export etc    = $(pwd)/config/$(BOARD)/etc
export catlic = $(pwd)/scripts/catlic.sh
export comply = $(pwd)/scripts/comply.sh
export fetch  = $(pwd)/scripts/fetch.sh
export gitbase= $(pwd)/scripts/gitbase.awk
export needed = $(pwd)/scripts/needed.sh
export romdev = $(pwd)/scripts/romdev.sh
export start  = $(pwd)/scripts/start.sh -d $(stage)/etc
export unpack = $(pwd)/scripts/unpack.sh

export karch := $(shell echo $(CONFIG_karch))
export kvers := $(shell echo $(CONFIG_kvers))
export kcfg  := $(shell echo $(CONFIG_kcfg))
export kdtb  := $(shell echo $(CONFIG_kdtb))
export krfs  := $(shell echo $(CONFIG_krfs))
export ipipe_vers := $(shell echo $(CONFIG_ipipe_vers))
export liclist = OSS_LICENSE.TXT

#
# Variables for passing to autoconf.
#
export ac_env := \
	CC=$(CROSS_COMPILE)gcc \
	CFLAGS=$(CONFIG_cflags) \
	CPPFLAGS=-I$(stage)/usr/include \
	LDFLAGS=-L$(stage)/usr/lib

export ac_flags := \
	--build=i486-pc-linux-gnu \
	--cache-file=config.cache \
	--host=$(CONFIG_ac_target) \
	--prefix=/usr

all: $(dirs) $(stamp)/images

$(dirs):
	$(Q) mkdir -p $(build)
	$(Q) mkdir -p $(dld)
	$(Q) mkdir -p download
	$(Q) mkdir -p $(redist)
	$(Q) mkdir -p $(rootfs)
	$(Q) mkdir -p $(stage)
	$(Q) mkdir -p $(stamp)

depend := $(stamp)/depend
-include $(depend)

#
# Run the menuconfig for busybox, Linux, etc.
#

ifdef K
export kconfig = 1
endif

#
# Control the verbosity.
#

ifndef V
MAKEFLAGS += -s --no-print-directory
export muffle := 1>/dev/null
endif

#
# Create the image files.
#

define vol_template
vol-$$(CONFIG_$(1)) += $(1)
endef

all_vols := manifest startup initrd jffs2 romfs tarball ubifs

$(foreach v, $(all_vols), $(eval $(call vol_template,$(v))))

volumes := $(foreach v, $(vol-y), $(stamp)/vol.$(v))

export CONFIG_initrd_size
export CONFIG_uboot_initrd    := $(shell echo $(CONFIG_uboot_initrd))
export CONFIG_jffs2_ebs
export CONFIG_jffs2_pad
export CONFIG_jffs2_ext       := $(shell echo $(CONFIG_jffs2_ext))
export CONFIG_romfs_label
export CONFIG_tftp_dir        := $(shell echo $(CONFIG_tftp_dir))
export CONFIG_ubi_ebs
export CONFIG_ubi_ext         := $(shell echo $(CONFIG_ubi_ext))
export CONFIG_ubinize_opt     := $(shell echo $(CONFIG_ubinize_opt))
export CONFIG_ubi_volume_name := $(shell echo $(CONFIG_ubi_volume_name))
export CONFIG_ubi_volume_size := $(shell echo $(CONFIG_ubi_volume_size))

$(stamp)/vol.%:
	$(Q) printf "   IMAGE    vol/$*\n"
	$(Q) $(MAKE) -C vol -f $*.mk
	$(Q) touch $@

$(volumes): $(stamp)/manifest

$(stamp)/images: $(volumes)
	$(MAKE) -C config/$(BOARD) image
	$(Q) touch $@

#
# Clean up after ourselves.
#

clean:
	rm -Rf $(out)

distclean: clean
	$(MAKE) -C scripts/kconfig distclean
	rm -f $(config)
	rm -f .version

repopulate:
	$(Q) rm -Rf $(rootfs)
	$(Q) rm -f $(stage)/etc/startup-[0-9]*-*
	$(Q) rm -f $(install)
	$(MAKE) all

#
# The configuration file
#

define create_defconfig
	$(Q) cp config/$(BOARD)/slim_config $(config)
	$(Q) echo created $(config) using the defaults
endef

$(config):
	$(create_defconfig)

defconfig:
	$(create_defconfig)
	rm -f $(depend)

rescue:
	cp config/$(BOARD)/rescue_config $(config)
	rm -f $(depend)

#
# Create a the list of packages to include in the build.
#

define pkg_template
pkg-$$(CONFIG_$(1)) += $(1)
endef

all_packages := $(sort $(notdir $(wildcard pkg/*)))

$(foreach p,$(all_packages),$(eval $(call pkg_template,$(p))))

install := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).install)

#
# Create a manifest
#

version := $(shell $(pwd)/scripts/version.sh $(pwd))

.version: force
	@echo $(version) > .version.new; \
	cmp -s .version .version.new || cp .version.new .version; \
	rm -f .version.new;

force:

pkg_manifest := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).manifest)

$(stamp)/manifest: $(install) $(pkg_manifest) .version $(pwd)/scripts/version.sh
	$(Q) printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" \
		slim NA git https://github.com/richardcochran/slim.git \
		GPL2 $(pwd)/COPYING `cat .version` \
		> $(redist)/manifest.txt
	$(Q) cat $(pkg_manifest) >> $(redist)/manifest.txt
	$(Q) rm -f $(redist)/$(liclist)
	$(Q) for p in $(pkg-y) ; do \
		$(MAKE) -C pkg/$$p -I$(pwd) liclist pkg=$$p ; \
	done
	$(Q) $(pwd)/scripts/pretty_manifest.awk \
		-v board=$(BOARD) -v strip=$(pwd)/ \
		< $(redist)/manifest.txt \
		> $(redist)/manifest.html
	$(Q) $(pwd)/scripts/short_manifest.awk \
		-v board=$(BOARD) \
		< $(redist)/manifest.txt \
		> $(redist)/OSS_LICENSE.TSV
	$(Q) cp $(pwd)/scripts/pretty_manifest.css $(redist)/
	$(Q) touch $@

$(stamp)/pkg.%.manifest: $(stamp)/pkg.%.install
	$(Q) printf "   MANIFEST pkg/$*\n"
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) manifest OUTPUT=$(pwd)/$@ pkg=$*
	$(Q) touch $@

#
# prefetch fetch unpack prep build stage install
#

pkg_depend := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).depend)

$(depend): $(config) $(pkg_depend)
	[ -d $(stamp) ] && cat $(pkg_depend) > $(depend)

$(stamp)/pkg.%.depend: pkg/%/makefile
	$(Q) printf "   DEPEND   pkg/$*\n"
	$(Q) mkdir -p $(stamp)
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) depend OUTPUT=$(pwd)/$@ pkg=$*

$(stamp)/pkg.%.prefetch: pkg/%/makefile
	$(Q) printf "   PREFETCH pkg/$*\n"
	$(Q) touch $@

define step
	$(Q) printf "   %-8s pkg/$*\n" $(1)
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) $(2)
	$(Q) touch $@
endef

$(stamp)/pkg.%.fetch: $(stamp)/pkg.%.prefetch
	$(call step,FETCH,fetch)

$(stamp)/pkg.%.unpack: $(stamp)/pkg.%.fetch
	$(call step,UNPACK,unpack)

$(stamp)/pkg.%.prep: $(stamp)/pkg.%.unpack
	$(call step,PREP,prep)

$(stamp)/pkg.%.build: $(stamp)/pkg.%.prep
	$(call step,BUILD,build)

$(stamp)/pkg.%.stage: $(stamp)/pkg.%.build
	$(call step,STAGE,stage)

$(stamp)/pkg.%.install: $(stamp)/pkg.%.stage
	$(call step,INSTALL,install)

#
# Operate on individual packages.
#

define force
	$(Q) printf "   %-8s $*\n" $(1)
	$(Q) $(MAKE) -C $* -I$(pwd) $(2)
endef

%/fetch:
	$(call force,FETCH,fetch)
%/unpack:
	$(call force,UNPACK,unpack)
%/prep:
	$(call force,PREP,prep)
%/build:
	$(call force,BUILD,build)
%/stage:
	$(call force,STAGE,stage)
%/install:
	$(call force,INSTALL,install)

%/distclean:
	touch $(stamp)/pkg.$(notdir $*).prefetch
	$(Q) $(MAKE) -C $* -I$(pwd) distclean

%/update:
	touch $(stamp)/pkg.$(notdir $*).*

#
# Install finished images into a TFTP directory.
#

install_volume/%:
	$(Q) $(MAKE) -f vol/$*.mk install

install_volumes := $(foreach v, $(vol-y), install_volume/$(v))

install: $(install_volumes)

#
# Menu support
#

pkg/%/Kconfig:
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) Kconfig OUTPUT=$(pwd)/Kconfig.pkg pkg=$*

kc_body: $(foreach p,$(all_packages),pkg/$(p)/Kconfig)

kc_end:
	$(Q) printf "source \"config/Kconfig\"\n\n" > Kconfig
	$(Q) printf "menu \"Software Packages\"\n" >> Kconfig
	$(Q) printf "\n"                           >> Kconfig
	$(Q) for x in Kconfig.pkg.* ; do \
		category=`echo $$x | cut -f3 -d.` ; \
		printf "menu \"$$category\"\n\n"   >> Kconfig ; \
		cat $$x                            >> Kconfig ; \
		printf "endmenu\n\n"               >> Kconfig ; \
	done
	$(Q) printf "\n"                           >> Kconfig
	$(Q) printf "endmenu\n"                    >> Kconfig
	$(Q) printf "\n"                           >> Kconfig
	$(Q) printf "menu \"Image Options\"\n"     >> Kconfig
	$(Q) printf "\n"                           >> Kconfig
	$(Q) printf "source \"vol/Kconfig\"\n"     >> Kconfig
	$(Q) printf "\n"                           >> Kconfig
	$(Q) printf "endmenu\n"                    >> Kconfig
	$(Q) rm -f Kconfig.pkg* Kconfig.vol*

menuconfig: scripts/kconfig/mconf kc_body kc_end
	KCONFIG_CONFIG=$(config) scripts/kconfig/mconf Kconfig
	rm -f .config.old Kconfig

scripts/kconfig/mconf:
	$(Q) $(MAKE) -C scripts/kconfig mconf

#
# Target to create a baseline over the git packages.
#

gitbase_pkg := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).gitbase)

baseline: $(gitbase_pkg)

$(stamp)/pkg.%.gitbase:
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) baseline OUTPUT=$(pwd)/$@ pkg=$*

#
# Targets to help keep a developer's git mirror up to date.
#

gitdev_pkg := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).gitdev)

gitdev: $(gitdev_pkg)

$(stamp)/pkg.%.gitdev:
	$(Q) $(MAKE) -C pkg/$* -I$(pwd) gitdev OUTPUT=$(pwd)/$@ pkg=$*

#
# Targets to make new packages and boards.
#

ifeq ($(AC),yes)
genpkg_options += -a
endif
ifeq ($(GET),git)
genpkg_options += -g
endif

new_package:
	if [ x$(PKG) = x ] || [ x$(GET) = x ] || [ x$(AC) = x ] ; then \
		printf "\nPlease set all three needed variables, like so:\n\n"; \
		printf "\tmake new_package PKG=xyz GET=git|wget AC=yes|no\n\n"; \
		false; \
	fi
	mkdir -p pkg/$(PKG)
	./scripts/genpkg.sh $(genpkg_options) -d template/package -p $(PKG) > \
	pkg/$(PKG)/makefile

new_board:
	if [ -z $(BRD) ]; then echo Need a board name, BRD=xyz; false; fi
	mkdir -p config/$(BRD)
	touch config/$(BRD)/README.org
	cp -a config/generic/etc config/$(BRD)
	sed -e 's/generic/$(BRD)/g' config/generic/makefile > config/$(BRD)/makefile
	sed -e 's/generic/$(BRD)/g' config/generic/slim_config > config/$(BRD)/slim_config
	printf "\nA new board has been created under config/$(BRD).\n"
	printf "Please be sure to complete the following steps:\n\n"
	printf "\t1. Edit config/$(BRD)/etc/inittab to set the login terminals.\n"
	printf "\t2. Enter 'export BOARD=$(BRD)'\n"
	printf "\t3. Enter 'make menuconfig' and customize the Board Settings menu.\n\n"

#
# Help on the make targets.
#

help:
	printf "\nSimple Linux Image Maker\n\n"
	printf "Targets:\n"
	printf " all        - Build the image.\n"
	printf " menuconfig - Update current config utilising a menu based program.\n"
	printf " clean      - Remove all the build products.\n"
	printf " distclean  - Remove all the build products and the configuration file.\n"
	printf " install    - Copy finished image files into a TFTP directory.\n"
	printf "\n"

#
# Many targets are not files at all.
#
.PHONY: all clean defconfig distclean help images install menuconfig rescue
