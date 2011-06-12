# SLIM makefile for the 'startup_script' package.
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

SRC = $(stage)/etc
DST = $(rootfs)/etc

all:
	$(Q) mkdir -p $(rootfs)/etc
	$(Q) mkdir -p $(SRC)
	$(Q) cp $(etc)/startup.sh $(SRC)/startup-000-board
	$(Q) printf "#!/bin/sh \n" > $(rootfs)/etc/startup.sh
	$(Q) for f in $(SRC)/startup-[0-9]*-*; do \
		echo                >> $(rootfs)/etc/startup.sh; \
		echo -n "# "        >> $(rootfs)/etc/startup.sh; \
		echo `basename $$f` >> $(rootfs)/etc/startup.sh; \
		cat $$f             >> $(rootfs)/etc/startup.sh; \
	done
