# SLIM makefile for the 'initrd' package.
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

IMAGE   = $(build)/../$(BOARD)-initrd
OPTIONS = -U -b $(CONFIG_initrd_size) -N $(CONFIG_initrd_size) -i 1024

all: uboot-initrd

initrd:
	$(Q) genext2fs $(OPTIONS) -d $(rootfs) -D $(etc)/device-table $(IMAGE)
	$(Q) gzip -f $(IMAGE)

install: uboot-install
	$(Q) if [ -d "$(CONFIG_tftp_dir)" ]; then \
		echo "   CP      $(IMAGE).gz $(CONFIG_tftp_dir)" ; \
		cp $(IMAGE).gz $(CONFIG_tftp_dir) ; \
	fi

ifeq ($(CONFIG_uboot_initrd),y)

ifeq ($(karch),powerpc)
ARCH := ppc
else
ARCH := $(karch)
endif

uboot-initrd: initrd
	$(Q) mkimage \
		-A $(ARCH) -C gzip -O linux -T ramdisk \
		-d $(IMAGE).gz \
		-n $(BOARD)-initrd \
		$(IMAGE).gz.uboot

uboot-install:
	$(Q) if [ -d "$(CONFIG_tftp_dir)" ]; then \
		echo "   CP      $(IMAGE).gz.uboot $(CONFIG_tftp_dir)" ; \
		cp $(IMAGE).gz.uboot $(CONFIG_tftp_dir) ; \
	fi
else

uboot-initrd: initrd
uboot-install:

endif
