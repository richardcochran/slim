# SLIM makefile for the 'ubifs' package.
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

UBI_OPT := -e $(CONFIG_ubi_ebs) $(CONFIG_ubi_ext)
UBIFS   := $(imgdir)/$(BOARD)-ubifs
UBI_OUT := $(imgdir)/$(BOARD)-ubi
INI     := $(shell mktemp)

all:
	$(Q) echo "[$(CONFIG_ubi_volume_name)]"		>  $(INI)
	$(Q) echo "image=$(UBIFS)"			>> $(INI)
	$(Q) echo "mode=ubi"				>> $(INI)
	$(Q) echo "vol_alignment=1"			>> $(INI)
	$(Q) echo "vol_flags=autoresize"		>> $(INI)
	$(Q) echo "vol_id=0"				>> $(INI)
	$(Q) echo "vol_name=$(CONFIG_ubi_volume_name)"	>> $(INI)
	$(Q) echo "vol_size=$(CONFIG_ubi_volume_size)"	>> $(INI)
	$(Q) echo "vol_type=dynamic"			>> $(INI)
#
	$(Q) /usr/sbin/mkfs.ubifs $(UBI_OPT) -o $(UBIFS) -d $(rootfs) -D $(etc)/device-table
#
	$(Q) /usr/sbin/ubinize $(CONFIG_ubinize_opt) -o $(UBI_OUT) $(INI)
	$(Q) rm -f $(INI)

install:
	$(Q) if [ -d "$(CONFIG_tftp_dir)" ]; then \
		echo "   CP      $(UBI_OUT) $(CONFIG_tftp_dir)" ; \
		cp $(UBI_OUT) $(CONFIG_tftp_dir) ; \
	fi
