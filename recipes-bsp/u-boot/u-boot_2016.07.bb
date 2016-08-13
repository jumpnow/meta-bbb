require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2016.07:"

PV = "2016.07"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

UBOOT_LOCALVERSION = "-jumpnow"

# v2016.07
SRCREV = "19ce924ff914f315dc2fdf79f357825c513aed6e"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Remove-some-unused-boot-options.patch \
 "

SPL_BINARY = "MLO"
