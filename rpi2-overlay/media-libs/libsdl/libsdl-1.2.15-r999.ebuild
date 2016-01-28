# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit git-r3

DESCRIPTION="SDL 1.2 Multimedia Library"
HOMEPAGE="http://www.libsdl.org"
SRC_URI=""

EGIT_REPO_URI="git://github.com/vanfanel/SDL-1.2.15-raspberrypi.git"

LICENSE=""
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND="
	media-libs/alsa-lib
	media-libs/raspberrypi2-userland
	${DEPEND}"

src_configure() {
	./MAC_ConfigureSDL12-rpi2.sh
}

src_install() {
	emake DESTDIR="${D}" install
}
