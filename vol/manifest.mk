# SLIM makefile for the 'manifest' package.
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

DST = $(rootfs)/etc/manifest
WWW = $(rootfs)/www/redist

LICS = $(shell cd $(redist) && find . -type f | grep -v ./src/)

all:
	$(Q) mkdir -p $(DST)
	$(Q) cp $(redist)/manifest.txt $(DST)
	$(Q) mkdir -p $(WWW)
	$(Q) cd $(redist) && tar cf - $(LICS) | (cd $(WWW) && tar xf -)
	$(Q) cd $(WWW) && rm -f manifest.txt manifest.html pretty_manifest.css
	$(Q) ./license_list.awk < $(redist)/manifest.txt > $(WWW)/manifest.txt
