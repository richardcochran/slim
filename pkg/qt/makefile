# SLIM makefile for the 'qt' package.

BROKEN = 1

# Cloning into bare repository 'qt'...
# fatal: unable to connect to gitorious.org:
# gitorious.org[0: 64.13.172.37]: errno=Connection timed out

PKG = qt
VER = v4.6.3
GET = git
URL = git://gitorious.org/qt/qt.git
PRG =
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/lib

LICENSE  = LGPL2
LICFILE  = $(SRC)/LICENSE.LGPL
UPSTREAM =
BINARIES =
PROVIDES = libQtXml libQtCore libQtTest libQtGui libQtNetwork libQtSql
CATEGORY = libraries

PREP_DEPEND = tslib.stage zlib.stage openssl.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Qt is a cross-platform C++ application framework. \
Qt offers a rich set of widgets that provide standard GUI functionality.

qt_flags := \
	-I $(stage)/usr/include -L $(stage)/usr/lib -L $(stage)/usr/lib/ts \
	-confirm-license \
	-embedded $(karch) \
	-exceptions \
	-little-endian \
	-no-feature-CURSOR \
	-no-largefile \
	-no-multimedia \
	-no-neon \
	-no-opengl \
	-no-phonon \
	-no-phonon-backend \
	-no-qt3support \
	-no-script \
	-no-scripttools \
	-no-svg \
	-no-webkit \
	-nomake demos \
	-nomake docs \
	-nomake examples \
	-nomake translations \
	-opensource \
	-prefix /usr \
	-qt-gfx-vnc \
	-qt-mouse-tslib \
	-release \
	-xmlpatterns \
	-xplatform qws/linux-SLIM-g++

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) mkdir -p $(SRC)/mkspecs/qws/linux-SLIM-g++
	$(Q) cp qplatformdefs.h $(SRC)/mkspecs/qws/linux-SLIM-g++
	$(Q) sed \
		-e "s @CROSS_COMPILE@ $(CROSS_COMPILE) g" \
		-e "s @STAGE@ $(stage) g" \
		qmake.conf > $(SRC)/mkspecs/qws/linux-SLIM-g++/qmake.conf
	$(Q) cd $(SRC) && ./configure $(qt_flags) $(muffle)

build:
	$(Q) $(MAKE) $(J) -C $(SRC) INSTALL_ROOT="$(stage)" all $(muffle)
	$(Q) $(MAKE) $(J) -C $(SRC) INSTALL_ROOT="$(stage)" sub-xmlpatterns $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) INSTALL_ROOT="$(stage)" install $(muffle)
	$(Q) $(MAKE) -C $(SRC) INSTALL_ROOT="$(stage)" sub-xmlpatterns-install_subtargets $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) for x in $(stage)/usr/lib/libQt*.so* ; do \
		cp -d $$x $(DST) ; \
	done
	$(Q) $(CROSS_COMPILE)strip $(DST)/libQt*.so*

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
