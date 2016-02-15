# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils multilib python-any-r1

MY_P="rustc-${PV}"

DESCRIPTION="Systems programming language from Mozilla"
HOMEPAGE="http://www.rust-lang.org/"

SRC_URI="http://static.rust-lang.org/dist/${MY_P}-src.tar.gz
		 https://www.dropbox.com/sh/g3aka9nhvigqscx/AACWUsPiFDNvk6f3hzelbA0na/rust-1.6.0-stable-2016-01-20-c30b771-arm-unknown-linux-gnueabihf-aa63d1cf108dd6113052196b7d72c93591fb1983.tar.gz?dl=0 -> ${P}-armv7-bin.tar.gz"

LICENSE="|| ( MIT Apache-2.0 ) BSD-1 BSD-2 BSD-4 UoI-NCSA"
SLOT="stable"
KEYWORDS="~arm"

IUSE="clang debug doc libcxx system-llvm"
REQUIRED_USE="libcxx? ( clang )"

CDEPEND=">=app-eselect/eselect-rust-0.3_pre20150425
	libcxx? ( sys-libs/libcxx )
"
DEPEND="${CDEPEND}
	${PYTHON_DEPS}
	>=dev-lang/perl-5.0
	clang? ( sys-devel/clang )
	system-llvm? ( >=sys-devel/llvm-3.6.0[multitarget(-)]
		<sys-devel/llvm-3.7.0[multitarget(-)] )
"
RDEPEND="${CDEPEND}"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack "${MY_P}-src.tar.gz"    || die
	unpack "${P}-armv7-bin.tar.gz" || die
}

src_prepare() {
	local postfix="gentoo-${SLOT}"
	sed -i -e "s/CFG_FILENAME_EXTRA=.*/CFG_FILENAME_EXTRA=${postfix}/" mk/main.mk || die
	find mk -name '*.mk' -exec \
		 sed -i -e "s/-Werror / /g" {} \; || die
	epatch "${FILESDIR}/${PN}-1.1.0-install.patch"
	sed -i s/v6/v7/ src/librustc_back/target/arm_unknown_linux_gnueabihf.rs
	sed -i s/v6/v7/ mk/cfg/arm-unknown-linux-gnueabihf.mk
}

src_configure() {
	export CFG_DISABLE_LDCONFIG="notempty"

		LD_LIBRARY_PATH="${WORKDIR}"/lib:$LD_LIBRARY_PATH \
		"${ECONF_SOURCE:-.}"/configure \
		--disable-jemalloc \
		--disable-valgrind \
		--enable-ccache \
		--prefix="${EPREFIX}/usr" \
		--libdir="${EPREFIX}/usr/$(get_libdir)/${P}" \
		--mandir="${EPREFIX}/usr/share/${P}/man" \
		--release-channel=${SLOT} \
		--enable-llvm-static-stdcpp \
		$(use_enable clang) \
		$(use_enable debug) \
		$(use_enable debug llvm-assertions) \
		$(use_enable !debug optimize) \
		$(use_enable !debug optimize-cxx) \
		$(use_enable !debug optimize-llvm) \
		$(use_enable !debug optimize-tests) \
		$(use_enable doc docs) \
		$(use_enable libcxx libcpp) \
		$(usex system-llvm "--llvm-root=${EPREFIX}/usr" " ") \
		--enable-local-rust \
		--local-rust-root="${WORKDIR}" \
		--build=arm-unknown-linux-gnueabihf --host=arm-unknown-linux-gnueabihf  --target=arm-unknown-linux-gnueabihf || die
}

src_compile() {
	LD_LIBRARY_PATH="${WORKDIR}"/lib:$LD_LIBRARY_PATH emake VERBOSE=1
}

src_install() {
	unset SUDO_USER

	default

	mv "${D}/usr/bin/rustc" "${D}/usr/bin/rustc-${PV}" || die
	mv "${D}/usr/bin/rustdoc" "${D}/usr/bin/rustdoc-${PV}" || die
	mv "${D}/usr/bin/rust-gdb" "${D}/usr/bin/rust-gdb-${PV}" || die

	dodoc COPYRIGHT LICENSE-APACHE LICENSE-MIT

	dodir "/usr/share/doc/rust-${PV}/"
	mv "${D}/usr/share/doc/rust"/* "${D}/usr/share/doc/rust-${PV}/" || die
	rmdir "${D}/usr/share/doc/rust/" || die

	cat <<-EOF > "${T}"/50${P}
	LDPATH="/usr/$(get_libdir)/${P}"
	MANPATH="/usr/share/${P}/man"
	EOF
	doenvd "${T}"/50${P}

	cat <<-EOF > "${T}/provider-${P}"
	/usr/bin/rustdoc
	/usr/bin/rust-gdb
	EOF
	dodir /etc/env.d/rust
	insinto /etc/env.d/rust
	doins "${T}/provider-${P}"
}

pkg_postinst() {
	eselect rust update --if-unset

	elog "Rust installs a helper script for calling GDB now,"
	elog "for your convenience it is installed under /usr/bin/rust-gdb-${PV}."

	if has_version app-editors/emacs || has_version app-editors/emacs-vcs; then
		elog "install app-emacs/rust-mode to get emacs support for rust."
	fi

	if has_version app-editors/gvim || has_version app-editors/vim; then
		elog "install app-vim/rust-mode to get vim support for rust."
	fi

	if has_version 'app-shells/zsh'; then
		elog "install app-shells/rust-zshcomp to get zsh completion for rust."
	fi
}

pkg_postrm() {
	eselect rust unset --if-invalid
}
