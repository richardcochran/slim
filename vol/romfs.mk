# SLIM makefile for the 'romfs' package.
#
# Copyright (C) 2011 Richard Cochran <richardcochran@gmail.com>
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

IMAGE   = $(imgdir)/$(BOARD)-romfs
OPTIONS = -V $(CONFIG_romfs_label)

all:
	$(Q) $(romdev) $(rootfs) $(etc)/device-table
	$(Q) genromfs $(OPTIONS) -f $(IMAGE) -d $(rootfs)

install:
	$(Q) if [ -d "$(CONFIG_tftp_dir)" ]; then \
		echo "   CP      $(IMAGE) $(CONFIG_tftp_dir)" ; \
		cp $(IMAGE) $(CONFIG_tftp_dir) ; \
	fi
