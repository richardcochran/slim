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

config = .config.$(BOARD)
-include $(config)

all: images

images: packages
	@echo making images

packages:
	@echo making packages

clean:
	rm -Rf $(out)

distclean: clean
	$(MAKE) -C scripts/kconfig distclean
	rm -f $(config)

#
# Control the verbosity.
#

ifdef V
NL = "\n"
else
MAKEFLAGS += -s --no-print-directory
export muffle = 1>/dev/null
endif

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

all_packages = $(notdir $(wildcard pkg/*))

$(foreach p,$(all_packages),$(eval $(call pkg_template,$(p))))

#
# Create a the list of image types to include in the build.
#

define vol_template
vol-$$(CONFIG_$(1)) += $(1)
endef

all_vols = $(notdir $(wildcard vol/*))

$(foreach v,$(all_vols),$(eval $(call vol_template,$(v))))

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
# Many targets are not files at all.
#
.PHONY: all clean defconfig distclean menuconfig rescue
