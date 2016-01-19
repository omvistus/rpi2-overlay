# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

DESCRIPTION="A portable, bytecode-compiled implementation of Common Lisp"
HOMEPAGE="http://clisp.sourceforge.net/"
SRC_URI="mirror://sourceforge/clisp/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm"
IUSE=""

RDEPEND=">=dev-libs/libsigsegv-2.4
		 >=dev-libs/ffcall-1.10
		 >=sys-libs/readline-5.0"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-arm.patch
}

src_configure() {
	ulimit -s unlimited
	./configure --prefix=/usr --with-readline --with-ffcall src
	cd "${S}"/src
	./makemake --prefix=/usr --with-readline --with-ffcall --with-dynamic-ffi > Makefile
}

src_compile() {
	ulimit -s unlimited
	cd "${S}"/src
	emake -j1
	sed -i 's,http://www.lisp.org/HyperSpec/,http://www.lispworks.com/reference/HyperSpec/,g' config.lisp
	emake -j1
}

src_install() {
	cd "${S}"/src
	make DESTDIR="${D}" prefix=/usr install || die "Installation failed"
	doman clisp.1
	dodoc ../SUMMARY README* ../src/NEWS ../unix/MAGIC.add ../ANNOUNCE
	export STRIP_MASK="*/usr/$(get_libdir)/clisp-${PV}/*/*"
	dohtml ../doc/impnotes.{css,html} ../doc/regexp.html ../doc/clisp.png
	dodoc ../doc/{CLOS-guide,LISP-tutorial}.txt
}
