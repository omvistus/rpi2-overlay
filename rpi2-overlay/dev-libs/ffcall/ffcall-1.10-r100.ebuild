# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs

DESCRIPTION="foreign function call libraries"
HOMEPAGE="http://www.haible.de/bruno/packages-ffcall.html"
SRC_URI="http://archive.raspbian.org/raspbian/pool/main/f/${PN}/${PN}_${PV}+cvs20100619.orig.tar.gz"

LICENSE="|| ( GPL-2 LGPL-2 )"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${PN}

src_configure() {
	econf \
		--datadir="${EPREFIX}"/usr/share/doc/${PF} \
		--enable-shared \
		--disable-static \
		--with-pic
}

src_compile() {
	make -j1
}

src_install() {
	dodoc NEWS README
	dodir /usr/share/man
	default
	prune_libtool_files
}
