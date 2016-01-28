# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="libretro implementation of mupen64plus (Nintendo64)"
HOMEPAGE="https://github.com/libretro/mednafen-libretro"
SRC_URI=""

EGIT_REPO_URI="https://github.com/libretro/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	git-r3_fetch https://github.com/libretro/libretro-super.git HEAD
	git-r3_checkout https://github.com/libretro/libretro-super.git \
		"${WORKDIR}"/infos
	git-r3_fetch
	git-r3_checkout
}

src_compile() {
	emake platform=rpi2
}

src_install() {
	insinto /usr/$(get_libdir)/libretro
	doins "${S}"/mupen64plus_libretro.so
	insinto /usr/share/libretro/info/
	doins "${WORKDIR}"/infos/dist/info/mupen64plus_libretro.info
}
