# SLIM makefile for the 'generic' board.
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
	$(Q) printf "\nBuild products in $(imgdir)\n\n"
	$(Q) find $(imgdir) -maxdepth 1 -type f | xargs ls -lh
	$(Q) printf "\n"

#
#  In a real embedded system, you might combine the file system and
#  kernel images in the board's build directory into one big upgrade
#  image, using 'tar' or 'cat' for example.
#
