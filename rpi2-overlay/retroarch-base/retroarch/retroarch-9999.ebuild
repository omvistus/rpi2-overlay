# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{3_2,3_3,3_4} )

inherit games python-single-r1 git-r3 flag-o-matic

DESCRIPTION="Universal frontend for libretro-based emulators for the Raspberry Pi 2"
HOMEPAGE="http://www.libretro.com/"
SRC_URI=""

EGIT_REPO_URI="git://github.com/libretro/RetroArch.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm"

# To avoid fatal dependency failures for users enabling the "python" USE flag, a
# default "python_single_target_python*" USE flag *MUST* be set below to the
# default version of Python 3 for default Portage profiles.
IUSE="assets database joypad_autoconfig +cpu_flags_arm_neon overlays python_single_target_python3_3 +python_single_target_python3_4"

RDEPEND="
	assets? ( retroarch-base/retroarch-assets )
	database? ( retroarch-base/libretro-database )
	joypad_autoconfig? ( retroarch-base/retroarch-joypad-autoconfig )
	=media-libs/libsdl2-2.0.3-r999[alsa,joystick]
	dev-libs/libxml2
	sys-libs/zlib
	"

DEPEND="virtual/pkgconfig
	${RDEPEND}"

pkg_setup() {
	games_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-python.patch"

	#changing default options to a more sensible default
	sed -i retroarch.cfg \
		-e 's:# libretro_directory =:libretro_directory = "'${EROOT}'usr/'$(get_libdir)'/libretro/":' \
		-e 's:# libretro_info_path =:libretro_info_path = "'${EROOT}'usr/share/libretro/info/":' \
		-e 's:# joypad_autoconfig_dir =:joypad_autoconfig_dir = "'${EROOT}'usr/share/retroarch/autoconfig/":' \
		-e 's:# rgui_browser_directory =:rgui_browser_directory = "~/":' \
		-e 's:# assets_directory =:assets_directory = "'${EROOT}'usr/share/retroarch/assets/":' \
		-e 's:# rgui_config_directory =:rgui_config_directory = "~/.config/retroarch/":' \
		-e 's:# video_shader_dir =:video_shader_dir = "'${EROOT}'usr/share/libretro/shaders/":' \
		-e 's:# video_filter_dir =:video_filter_dir = "'${EROOT}'usr/'$(get_libdir)'/retroarch/filters/video/":' \
		-e 's:# audio_filter_dir =:audio_filter_dir = "'${EROOT}'usr/'$(get_libdir)'/retroarch/filters/audio/":' \
		-e 's:# overlay_directory =:overlay_directory = "'${EROOT}'usr/share/libretro/overlays/":' \
		-e 's:# content_database_path =:content_database_path = "'${EROOT}'usr/share/libretro/data/":' \
		-e 's:# cheat_database_path =:cheat_database_path = "'${EROOT}'usr/share/libretro/cheats/":' \
		-e 's:# system_directory =:system_directory = "~/.local/share/retroarch/system/":' \
		-e 's:# savestate_directory =:savestate_directory = "~/.local/share/retroarch/savestates/":' \
		-e 's:# savefile_directory =:savefile_directory = "~/.local/share/retroarch/savefiles/":' \
		-e 's:# content_directory =:content_directory = "~/":' \
		-e 's:# screenshot_directory =:screenshot_directory = "~/.local/share/retroarch/screenshots/":' \
		-e 's:# extraction_directory =:extraction_directory = "'${EROOT}'tmp/":' \
	|| die
}

src_configure() {
	./configure --prefix=/usr --global-config-dir=/etc/games  \
		--disable-x11   \
		--disable-pulse \
		--disable-oss   \
		--disable-al \
		--enable-floathard \
		--enable-materialui \
		$(use_enable cpu_flags_arm_neon neon) \
	|| die
}

src_compile() {
	emake
	emake -C gfx/video_filters/
	emake -C audio/audio_filters/
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc README.md
	insinto /usr/$(get_libdir)/retroarch/filters/video/
	doins "${S}"/gfx/video_filters/*.so
	doins "${S}"/gfx/video_filters/*.filt
	insinto /usr/$(get_libdir)/retroarch/filters/audio/
	doins "${S}"/audio/audio_filters/*.so
	doins "${S}"/audio/audio_filters/*.dsp
	keepdir /usr/$(get_libdir)/libretro/
	keepdir /usr/share/libretro/info/
	keepdir /usr/share/libretro/shaders/
	keepdir /usr/share/libretro/overlays/
	keepdir /usr/share/libretro/cheats/
	keepdir /usr/share/libretro/data/
	keepdir /usr/share/retroarch/assets/
	keepdir /usr/share/retroarch/autoconfig/
	prepgamesdirs
}

pkg_preinst() {
	if ! has_version "=${CATEGORY}/${P}"; then
		first_install="1"
	fi
}

pkg_postinst() {
	if [[ "${first_install}" == "1" ]]; then
		ewarn ""
		ewarn "You need to make sure that all directories exist or you must modify your retroarch.cfg accordingly."
		ewarn "To create the needed directories for your user run as \$USER (not as root!):"
		ewarn ""
		ewarn "\$ mkdir -p ~/.local/share/retroarch/{savestates,savefiles,screenshots,system}"
		ewarn ""
		ewarn "This message will only be displayed once!"
		ewarn ""
	fi
}
