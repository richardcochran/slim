# SLIM makefile for the 'avahi' package.

PKG = avahi
VER = v0.6.25
GET = git
URL = git://git.0pointer.de/avahi.git
PRG = avahi-autoipd
TGZ = $(PKG).tgz
SRC = $(build)/$(PKG)
DST = $(rootfs)/usr/sbin

LICENSE  = LGPL2
LICFILE  = $(SRC)/LICENSE
UPSTREAM =
BINARIES = $(PRG)
PROVIDES =
CATEGORY = networking

PREP_DEPEND = libdaemon.stage
BUILD_DEPEND =
INSTALL_DEPEND = basefiles.install

DESCRIPTION = Avahi is a free, LGPL mDNS/DNS-SD implementation.

ac_env += PKG_CONFIG_PATH=$(stage)/usr/lib/pkgconfig

ac_flags += \
	--disable-dbus \
	--disable-doxygen-doc \
	--disable-gdbm \
	--disable-glib \
	--disable-gobject \
	--disable-gtk \
	--disable-manpages \
	--disable-mono \
	--disable-monodoc \
	--disable-pygtk \
	--disable-python \
	--disable-python-dbus \
	--disable-qt3 \
	--disable-qt4 \
	--disable-stack-protector \
	--with-autoipd-user=root \
	--with-autoipd-group=root \
	--with-distro=none \
	--with-xml=none \
	--localstatedir=/var \
	--sysconfdir=/etc

fetch:
	$(Q) $(fetch) -m $(GET) -f $(TGZ) -s $(URL) -t $(VER)

unpack:
	$(Q) $(unpack) -d $(build) -f $(TGZ)

prep:
	$(Q) cd $(SRC) && NOCONFIGURE=1 ./bootstrap.sh $(muffle)
	$(Q) cd $(SRC) && $(ac_env) ./configure $(ac_flags) $(muffle)

build:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" all $(muffle)

stage:
	$(Q) $(MAKE) -C $(SRC) DESTDIR="$(stage)" install $(muffle)

install:
	$(Q) mkdir -p $(DST)
	$(Q) cd $(SRC) && cp avahi-autoipd/$(PRG) $(DST)
	$(Q) $(CROSS_COMPILE)strip $(DST)/$(PRG)
	$(Q) mkdir -p $(rootfs)/etc/avahi
	$(Q) cp avahi-autoipd.action $(rootfs)/etc/avahi
#	$(Q) $(start) -n 800 -f avahi.init

clean:
	$(Q) $(MAKE) -C $(SRC) distclean || echo nothing to clean

distclean:
	$(Q) rm -Rf $(SRC)
	$(Q) rm -f $(dld)/$(TGZ)

include depend.mk
