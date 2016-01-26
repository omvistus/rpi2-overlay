# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: convert FusionSound #484250

EAPI=5
inherit autotools flag-o-matic toolchain-funcs eutils

MY_P=SDL2-${PV}
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="http://www.libsdl.org"
SRC_URI="http://www.libsdl.org/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~arm"

IUSE=""
REQUIRED_USE=""

RDEPEND="
	>=media-libs/alsa-lib-1.0.27.2
	>=sys-apps/dbus-1.6.18-r1
	media-libs/raspberrypi2-userland
	>=virtual/libudev-208:= 
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	strip-flags

	# sorted by `./configure --help`
	ECONF_SOURCE="${S}" econf   \
		--host=armv7l-raspberry-linux-gnueabihf \
		--enable-sdl-dlopen \
	    --disable-arts --disable-esd --disable-nas \
	    --enable-alsa \
	    --disable-pulseaudio \
	    --disable-video-wayland \
	    --without-x --disable-video-x11 --disable-x11-shared \
	    --disable-video-x11-xcursor --disable-video-x11-xinerama \
	    --disable-video-x11-xinput --disable-video-x11-xrandr \
	    --disable-video-x11-scrnsaver --disable-video-x11-xshape \
	    --disable-video-x11-vm --disable-video-opengl \
	    --disable-video-directfb --disable-rpath \
	    --enable-video-opengles
}

src_install() {
	emake DESTDIR="${D}" install
}
