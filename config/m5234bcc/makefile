# SLIM makefile for the 'm5234bcc' board.
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

image:
	$(Q) $(CROSS_COMPILE)objcopy --output-target=binary \
		$(imgdir)/m5234bcc-vmlinux \
		$(imgdir)/m5234bcc-lnxbin
	$(Q) cat \
		$(imgdir)/m5234bcc-lnxbin $(imgdir)/m5234bcc-romfs > \
		$(imgdir)/m5234bcc-image
	$(Q) rm -f \
		$(imgdir)/m5234bcc-lnxbin
	$(Q) printf "\nBuild products in $(imgdir)\n\n"
	$(Q) find $(imgdir) -maxdepth 1 -type f | xargs ls -lh
	$(Q) printf "\n"
