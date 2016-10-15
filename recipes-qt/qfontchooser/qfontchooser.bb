SUMMARY = "Qt5 test app"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

SRCREV = "${AUTOREV}"
SRC_URI = "git://github.com/scottellis/qfontchooser.git"

PR = "r0"

S = "${WORKDIR}/git"

require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/qfontchooser ${D}${bindir}
}

FILES_${PN} = "${bindir}"

RDEPENDS_${PN} = "qtbase-plugins"
