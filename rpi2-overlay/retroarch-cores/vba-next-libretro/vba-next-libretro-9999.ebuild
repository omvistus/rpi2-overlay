# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="libretro implementation of VBA Next. (Game Boy Advance)"
HOMEPAGE="https://github.com/libretro/vba-next"
SRC_URI=""

EGIT_REPO_URI="https://github.com/libretro/vba-next.git"

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
	emake -f Makefile.libretro platform=armvhardfloatunix TILED_RENDERING=1 HAVE_NEON=1 || die "emake failed"
}

src_install() {
	insinto /usr/$(get_libdir)/libretro
	doins "${S}"/vba_next_libretro.so
	insinto /usr/share/libretro/info/
	doins "${WORKDIR}"/infos/dist/info/vba_next_libretro.info
}
