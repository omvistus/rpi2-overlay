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
		--disable-pulseaudio    \
		--disable-esd           \
		--disable-video-mir     \
		--disable-video-wayland \
		--disable-video-x11     \
		--disable-video-opengl  \
		--host=armv7l-raspberry-linux-gnueabihf
}

src_install() {
	emake DESTDIR="${D}" install
}
