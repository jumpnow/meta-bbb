SUMMARY = "USBProxy"
HOMEPAGE = "https://github.com/dominicgs/USBProxy"
LICENSE = "GPLv2"
LIC_FILES_CHKSUM = "file://${WORKDIR}/git/LICENSE;md5=1484b9683e3fc1dd9f5cf802a23fe67c"

SRCREV = "d237d257306742c69ab24e87022e256e1cb1f85d"
SRC_URI = "git://github.com/scottellis/USBProxy.git"

inherit cmake pkgconfig

DEPENDS = "libpcap libusb1"

S = "${WORKDIR}/git/src"

FILES_${PN} = "${bindir} ${libdir}"
