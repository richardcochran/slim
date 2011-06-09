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
HOSTCC         ?= gcc
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
export etc    = $(pwd)/config/$(BOARD)/etc
export catlic = $(pwd)/scripts/catlic.sh
export comply = $(pwd)/scripts/comply.sh
export fetch  = $(pwd)/scripts/fetch.sh
export needed = $(pwd)/scripts/needed.sh
export start  = $(pwd)/scripts/start.sh -d $(stage)/etc
export unpack = $(pwd)/scripts/unpack.sh

export karch = $(CONFIG_karch)
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

all_vols := manifest startup initrd jffs2 ubifs

$(foreach v, $(all_vols), $(eval $(call vol_template,$(v))))

volumes := $(foreach v, $(vol-y), $(stamp)/vol.$(v))

export CONFIG_initrd_size
export CONFIG_jffs2_ebs
export CONFIG_jffs2_pad
export CONFIG_jffs2_ext       := $(shell echo $(CONFIG_jffs2_ext))
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
	@echo making images: $(vol-y)
	$(Q) touch $@

#
# Clean up after ourselves.
#

clean:
	rm -Rf $(out)

distclean: clean
	$(MAKE) -C scripts/kconfig distclean
	rm -f $(config)

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

all_packages := $(notdir $(wildcard pkg/*))

$(foreach p,$(all_packages),$(eval $(call pkg_template,$(p))))

install := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).install)

#
# Create a manifest
#

pkg_manifest := $(foreach p, $(pkg-y), $(stamp)/pkg.$(p).manifest)

$(stamp)/manifest: $(install) $(pkg_manifest)
	$(Q) cat $(pkg_manifest) > $(redist)/manifest.txt
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

%/distclean:
	touch $(stamp)/pkg.$(notdir $*).prefetch
	$(Q) $(MAKE) -C $* -I$(pwd) distclean

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
# Help on the make targets.
#

help:
	printf "\nSimple Linux Image Maker\n\n"
	printf "Targets:\n"
	printf " all        - Build the image.\n"
	printf " menuconfig - Update current config utilising a menu based program.\n"
	printf " clean      - Remove all the build products.\n"
	printf " distclean  - Remove all the build products and the configuration file.\n"
	printf "\n"

#
# Many targets are not files at all.
#
.PHONY: all clean defconfig distclean help images menuconfig rescue
