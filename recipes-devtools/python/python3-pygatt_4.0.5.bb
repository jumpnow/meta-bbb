DESCRIPTION = "Python Bluetooth LE (Low Energy) and GATT Library"
HOMEPAGE = "https://github.com/peplin/pygatt"
SECTION = "devel/python"

DEPENDS = "bluez5 ${PYTHON_PN}-coverage-native ${PYTHON_PN}-nose-native python-pyflakes-native"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=29ff8f199c0ea20816e61937dcb62677"

inherit pypi setuptools3

SRC_URI = "https://files.pythonhosted.org/packages/10/1a/adf63764143593430e21500d34f00b8ff133f0c43462bcb3a11f35cfa3e3/pygatt-4.0.5.tar.gz"
SRC_URI[md5sum] = "dd6e7b5ce0e009bcf85e224922e80d6a"
SRC_URI[sha256sum] = "7f4e0ec72f03533a3ef5fdd532f08d30ab7149213495e531d0f6580e9fcb1a7d"

S = "${WORKDIR}/pygatt-${PV}"

RDEPENDS_${PN} += "\
    bluez5 \
    ${PYTHON_PN}-pyserial \
"
