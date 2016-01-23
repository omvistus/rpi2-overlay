# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="RetroArch joypad autoconfig files"
HOMEPAGE="https://github.com/libretro/retroarch-joypad-autoconfig/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/libretro/retroarch-joypad-autoconfig.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}"

src_install() {
	insinto /usr/share/retroarch/autoconfig/
	doins "${S}"/udev/*.cfg
}
