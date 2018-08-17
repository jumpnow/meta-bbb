SUMMARY = "USBProxy"
HOMEPAGE = "https://github.com/dominicgs/USBProxy"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=1484b9683e3fc1dd9f5cf802a23fe67c"

SRCREV = "c5fc739271558d7a94208ff232c234d2ae244dcb"
SRC_URI = "git://github.com/scottellis/USBProxy.git"

inherit cmake pkgconfig

DEPENDS = "libpcap"

S = "${WORKDIR}/git/src"

FILES_${PN} = "${bindir} ${libdir}"
