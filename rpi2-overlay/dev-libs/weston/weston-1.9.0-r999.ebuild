# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="git://anongit.freedesktop.org/git/wayland/${PN}"
	GIT_ECLASS="git-r3"
	EXPERIMENTAL="true"
fi
VIRTUALX_REQUIRED="test"
RESTRICT="test"

inherit autotools readme.gentoo toolchain-funcs virtualx $GIT_ECLASS

DESCRIPTION="Wayland reference compositor"
HOMEPAGE="http://wayland.freedesktop.org/"

if [[ $PV = 9999* ]]; then
	SRC_URI="${SRC_PATCHES}"
	KEYWORDS="arm"
else
	SRC_URI="http://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~arm"
fi

LICENSE="MIT CC-BY-SA-3.0"
SLOT="0"
IUSE=""

REQUIRED_USE=""

RDEPEND="
	>=dev-libs/libinput-0.8.0
	>=dev-libs/wayland-1.9.0
	media-libs/lcms:2
	media-libs/libpng:0=
	media-libs/libwebp:0=
	virtual/jpeg:0=
	>=x11-libs/cairo-1.11.3
	x11-libs/libxkbcommon
	x11-libs/pixman
	x11-misc/xkeyboard-config
		>=sys-libs/mtdev-1.1.0
		>=virtual/udev-136
	sys-auth/pambase
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	if [[ ${PV} = 9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-X11-compositor \
		--disable-drm-compositor \
		--disable-wayland-compositor \
		--enable-weston-launch \
		--disable-simple-egl-clients \
		--disable-egl \
		--disable-libunwind \
		--disable-colord \
		--disable-resize-optimization \
		--disable-xwayland-test \
		--with-cairo=image \
		WESTON_NATIVE_BACKEND="rpi-backend.so"

}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	cd "${BUILD_DIR}" || die
	Xemake check
}

src_install() {
	default

	readme.gentoo_src_install
}
