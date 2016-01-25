# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit games git-r3

DESCRIPTION=""
HOMEPAGE=""
SRC_URI=""

LICENSE="GPL"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	media-libs/raspberrypi2-userland
"

EGIT_REPO_URI="git://github.com/RetroPie/reicast-emulator.git"

src_compile() {
	cd "${S}"/shell/linux
	emake platform=rpi2
}

src_install() {
	cd "${S}"/shell/linux
	emake platform=rpi2 PREFIX="${ED}"/usr/games install
}
