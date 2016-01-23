# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="RetroArch Assets files"
HOMEPAGE="https://github.com/libretro/retroarch-assets"
SRC_URI=""

EGIT_REPO_URI="git://github.com/libretro/retroarch-assets.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dodir /usr/share/retroarch/assets/
	cp -R "${S}"/* "${D}"/usr/share/retroarch/assets/
}
