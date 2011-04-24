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

dirs = $(build) $(dld) $(redist) $(rootfs) $(stage) $(stamp)

#
# Scripts for the package makefiles.
#
export comply = $(pwd)/scripts/comply.sh
export fetch  = $(pwd)/scripts/fetch.sh
export needed = $(pwd)/scripts/needed.sh
export start  = $(pwd)/scripts/start.sh -d $(stage)/etc
export unpack = $(pwd)/scripts/unpack.sh

all: $(dirs) $(stamp)/images

$(dirs):
	$(Q) mkdir -p $(build)
	$(Q) mkdir -p $(dld)
	$(Q) mkdir -p $(redist)
	$(Q) mkdir -p $(rootfs)
	$(Q) mkdir -p $(stage)
	$(Q) mkdir -p $(stamp)

packages:
	@echo making packages: $(pkg-y)

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

all_vols := $(notdir $(wildcard vol/*))

$(foreach v, $(all_vols), $(eval $(call vol_template,$(v))))

volumes := $(foreach v, $(vol-y), $(stamp)/vol.$(v))

$(stamp)/vol.%:
	$(Q) printf "   IMAGE    vol/$*\n"
	$(Q) touch $@

$(volumes): $(stamp)/manifest

$(stamp)/images: packages $(volumes)
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
#	rm -f $(depend)

rescue:
	cp config/$(BOARD)/rescue_config $(config)
#	rm -f $(depend)

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

$(stamp)/manifest: $(install)
	@echo Create a manifest
	$(Q) touch $@

#
# prefetch fetch unpack prep build stage install
#

$(stamp)/pkg.%.prefetch: pkg/%/makefile
	$(Q) printf "   PREFETCH pkg/$*\n"
	$(Q) touch $@

$(stamp)/pkg.%.fetch: $(stamp)/pkg.%.prefetch
	$(Q) printf "   FETCH    pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) fetch
	$(Q) touch $@

$(stamp)/pkg.%.unpack: $(stamp)/pkg.%.fetch
	$(Q) printf "   UNPACK   pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) unpack
	$(Q) touch $@

$(stamp)/pkg.%.prep: $(stamp)/pkg.%.unpack
	$(Q) printf "   PREP     pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) prep
	$(Q) touch $@

$(stamp)/pkg.%.build: $(stamp)/pkg.%.prep
	$(Q) printf "   BUILD    pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) build
	$(Q) touch $@

$(stamp)/pkg.%.stage: $(stamp)/pkg.%.build
	$(Q) printf "   STAGE    pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) stage
	$(Q) touch $@

$(stamp)/pkg.%.install: $(stamp)/pkg.%.stage
	$(Q) printf "   INSTALL  pkg/$*\n"
#	$(Q) $(MAKE) -C pkg/$* -I$(pwd) install
	$(Q) touch $@

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
.PHONY: all clean defconfig distclean help images menuconfig packages rescue
