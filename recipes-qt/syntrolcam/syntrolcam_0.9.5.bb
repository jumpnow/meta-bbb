SUMMARY = "Syntro Linux only camera application"
HOMEPAGE = "http://www.pansenti.com"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit qt4e pkgconfig

DEPENDS += "syntrocore"

PR = "0"

SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/Syntro/SyntroLCam.git"

S = "${WORKDIR}/git"

do_install() {
	export INSTALL_ROOT=${D}
	make install
}

FILES_${PN} = "${bindir}"

