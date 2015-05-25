SUMMARY = "Core libraries and applications for Syntro"
HOMEPAGE = "http://www.pansenti.com"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

inherit qt4e

DEPENDS += "pkgconfig"

PR = "0"

SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/Syntro/SyntroCore.git"

S = "${WORKDIR}/git"

do_install() {
    export INSTALL_ROOT=${D}
    make install

    install -d ${D}${libdir}/pkgconfig/
    install -m 0644 ${S}/SyntroLib/syntro.pc ${D}${libdir}/pkgconfig/
}

FILES_${PN} = "${libdir} ${bindir}"

