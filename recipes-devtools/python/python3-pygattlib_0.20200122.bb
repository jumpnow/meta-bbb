DESCRIPTION = "Python library to access Bluetooth LE devices"
HOMEPAGE = "http://bitbucket.org/OscarAcena/pygattlib"
SECTION = "devel/python"

DEPENDS = "bluez5 boost"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit pypi setuptools3

SRC_URI = "https://files.pythonhosted.org/packages/b1/d8/03cc2843e7235b7d2f55af7b3abec3cb94e14c0036dde10b505b6fe55f35/gattlib-0.20200122.tar.gz"
SRC_URI[md5sum] = "8a29d60d585a09f6dbbfa67d082e4e73"
SRC_URI[sha256sum] = "e7bc9f073cd32d9259cfb7e5b12c76f45e29316259d1d9a7872333bc63cb3bbd"


S = "${WORKDIR}/gattlib-${PV}"

RDEPENDS_${PN} += "\
    bluez5 \
    ${PYTHON_PN}-fcntl \
"
