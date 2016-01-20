# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# TODO: convert FusionSound #484250

EAPI=5
inherit autotools flag-o-matic toolchain-funcs eutils multilib-minimal

MY_P=SDL2-${PV}
DESCRIPTION="Simple Direct Media Layer"
HOMEPAGE="http://www.libsdl.org"
SRC_URI="http://www.libsdl.org/release/${MY_P}.tar.gz"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~arm"

IUSE="alsa custom-cflags dbus fusionsound gles haptic +joystick nas oss pulseaudio +sound static-libs +threads tslib udev +video"
REQUIRED_USE="
	alsa? ( sound )
	fusionsound? ( sound )
	gles? ( video )
	nas? ( sound )
	pulseaudio? ( sound )"

RDEPEND="
	alsa? ( >=media-libs/alsa-lib-1.0.27.2[${MULTILIB_USEDEP}] )
	dbus? ( >=sys-apps/dbus-1.6.18-r1[${MULTILIB_USEDEP}] )
	fusionsound? ( || ( >=media-libs/FusionSound-1.1.1 >=dev-libs/DirectFB-1.7.1[fusionsound] ) )
	gles? ( media-libs/raspberrypi2-userland )
	nas? ( >=media-libs/nas-1.9.4[${MULTILIB_USEDEP}] )
	pulseaudio? ( >=media-sound/pulseaudio-2.1-r1[${MULTILIB_USEDEP}] )
	tslib? ( >=x11-libs/tslib-1.0-r3[${MULTILIB_USEDEP}] )
	udev? ( >=virtual/libudev-208:=[${MULTILIB_USEDEP}] )
	"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	# https://bugzilla.libsdl.org/show_bug.cgi?id=1431
	epatch "${FILESDIR}"/${P}-static-libs.patch
	sed -i \
		-e 's/configure.in/configure.ac/' \
		Makefile.in || die
	mv configure.{in,ac} || die
	AT_M4DIR="/usr/share/aclocal acinclude" eautoreconf
}

multilib_src_configure() {
	use custom-cflags || strip-flags

	# sorted by `./configure --help`
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		$(use_enable sound audio) \
		$(use_enable video) \
		--enable-render \
		--enable-events \
		$(use_enable joystick) \
		$(use_enable haptic) \
		--enable-power \
		$(use_enable threads) \
		--enable-timers \
		--enable-file \
		--disable-loadso \
		--enable-cpuinfo \
		--enable-atomic \
		--enable-assembly \
		$(use_enable oss) \
		$(use_enable alsa) \
		--disable-alsa-shared \
		--disable-esd \
		$(use_enable pulseaudio) \
		--disable-pulseaudio-shared \
		--disable-arts \
		$(use_enable nas) \
		--disable-nas-shared \
		--disable-sndio \
		--disable-sndio-shared \
		$(use_enable sound diskaudio) \
		$(use_enable sound dummyaudio) \
		--disable-video-opengl \
		--disable-video-x11 \
		--disable-video-wayland \
		--disable-wayland-shared \
		--disable-video-cocoa \
		$(multilib_native_use_enable fusionsound) \
		--disable-fusionsound-shared \
		--disable-video-dummy \
		--disable-video-directfb \
		--enable-video-opengles \
		$(use_enable gles video-opengles) \
		$(use_enable udev libudev) \
		$(use_enable dbus) \
		$(use_enable tslib input-tslib) \
		--disable-directx \
		--disable-rpath \
		--disable-render-d3d \
		--without-x \
		--host=arm-raspberry-linux-gnueabihf
}

multilib_src_install() {
	emake DESTDIR="${D}" install
}

multilib_src_install_all() {
	use static-libs || prune_libtool_files
	dodoc {BUGS,CREDITS,README,README-SDL,README-hg,TODO,WhatsNew}.txt
}
