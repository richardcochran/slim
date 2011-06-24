# SLIM makefile for the 'jffs2' package.
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

IMAGE   = $(imgdir)/$(BOARD)-rootfs
OPTIONS = --pad=$(CONFIG_jffs2_pad) -e $(CONFIG_jffs2_ebs) $(CONFIG_jffs2_ext)

all:
	$(Q) mkfs.jffs2 $(OPTIONS) -o $(IMAGE) -d $(rootfs) -D $(etc)/device-table

install:
	$(Q) if [ -d "$(CONFIG_tftp_dir)" ]; then \
		echo "   CP      $(IMAGE) $(CONFIG_tftp_dir)" ; \
		cp $(IMAGE) $(CONFIG_tftp_dir) ; \
	fi
