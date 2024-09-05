SUMMARY = "Qt6 test app"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS += "qtbase"

SRCREV = "056eadc053000a3d6a4f9c0a1961ceb07d18cf3d"
SRC_URI = "git://github.com/scottellis/tspress.git;protocol=https;branch=qt5"

S = "${WORKDIR}/git"

require recipes-qt/qt5/qt5.inc

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${B}/tspress ${D}${bindir}
}

FILES_${PN} = "${bindir}"

RDEPENDS:${PN} = "qtbase-plugins"
