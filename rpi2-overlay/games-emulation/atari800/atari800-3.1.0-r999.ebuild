# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games autotools eutils

DESCRIPTION="Atari 800 emulator"
HOMEPAGE="http://atari800.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	mirror://sourceforge/${PN}/xf25.zip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~arm"
IUSE="ncurses oss readline +sdl"

NOTSDL_DEPS="
	sys-libs/ncurses:0
"
RDEPEND="sdl? ( =media-libs/libsdl-1.2.15-r999 )
	ncurses? ( ${NOTSDL_DEPS} )
	!sdl? ( !ncurses? ( ${NOTSDL_DEPS} ) )
	readline? ( sys-libs/readline:0
		sys-libs/ncurses:0 )
	media-libs/libpng:0
	sys-libs/zlib
	media-libs/raspberrypi2-userland"
DEPEND="${RDEPEND}
	app-arch/unzip"

src_prepare() {
	# remove some not-so-interesting ones
	rm -f DOC/{INSTALL.*,*.in,CHANGES.OLD} || die
	sed -i \
		-e '1s/ 1 / 6 /' \
		src/atari800.man || die
	sed -i \
		-e "/SYSTEM_WIDE_CFG_FILE/s:/etc:${GAMES_SYSCONFDIR}:" \
		src/cfg.c || die
	sed -i \
		-e "/share/s:/usr/share:${GAMES_DATADIR}:" \
		src/atari.c || die
	sed "s:/usr/share/games:${GAMES_DATADIR}:" \
		"${FILESDIR}"/atari800.cfg > "${T}"/atari800.cfg || die

	# Bug 544608
	epatch "${FILESDIR}/${P}-tgetent-detection.patch"
	pushd src > /dev/null && eautoreconf
	popd > /dev/null

	epatch "${FILESDIR}/src-configure.patch"
}

src_configure() {
	cd src && \
		egamesconf --target=rpi
}

src_compile() {
	emake -C src
}

src_install () {
	dogamesbin src/atari800
	newman src/atari800.man atari800.6
	dodoc README.1ST DOC/*
	insinto "${GAMES_DATADIR}/${PN}"
	doins "${WORKDIR}/"*.ROM
	insinto "${GAMES_SYSCONFDIR}"
	doins "${T}"/atari800.cfg
	prepgamesdirs
}
