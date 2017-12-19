# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils rpm versionator

DESCRIPTION="Web component of 1C ERP system"
HOMEPAGE="http://v8.1c.ru/"

DOWNLOADPAGE="http://ftp.linuxbuh.ru/1c83/server"

MY_PV="$(replace_version_separator 3 '-' )"
MY_PN="1c-enterprise83-ws"
SRC_URI="x86? ( $DOWNLOADPAGE/${MY_PN}_${MY_PV}_i386.tar.gz
	    nls? ( $DOWNLOADPAGE/${MY_PN}-nls_${MY_PV}_i386.tar.gz ) )
	amd64? ( $DOWNLOADPAGE/${MY_PN}_${MY_PV}_amd64.tar.gz
	    nls? ( $DOWNLOADPAGE/${MY_PN}-nls_${MY_PV}_amd64.tar.gz ) )"


LICENSE="1CEnterprise_en"
KEYWORDS="amd64 x86"
RESTRICT="mirror strip"

#SLOT="$(get_version_component_range 1-2)"
SLOT="0"

IUSE="-nls -pax_kernel"

RDEPEND="=app-office/1c-enterprise83-common-${PV}:${SLOT}"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_install() {
	dodir /opt
	mv "${WORKDIR}"/opt/* "${D}"/opt
}

pkg_postinst() {
	elog "You need to configure fonts for the web compoment of 1C ERP system by exec"
	if use x86 ; then
	    elog "/opt/1C/v83/i386/utils/config_server /usr/share/fonts/corefont"
	elif use amd64 ; then
	    elog "/opt/1C/v83/x86_64/utils/config_server /usr/share/fonts/corefont"
	fi
	elog "or you may get an error \"Failed to initialize graphics subsystem!\""
	if use pax_kernel ; then
	    elog ""
	    elog "You may have to disable MPROTECT for the /usr/sbin/apache2 binary"
	    elog "Otherwise, the PAX-kernel will not allow the web-server to work"
	    elog "with 1C web-component apache module."
	fi
}