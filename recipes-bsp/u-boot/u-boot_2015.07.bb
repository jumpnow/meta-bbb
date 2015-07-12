require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2015.07:"

PV = "2015.07"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

# for identification
UBOOT_LOCALVERSION = "-jumpnow"

# v2015.07-rc3
SRCREV = "2650dbcf8a9ddfee4c5bf2d1c961c303988c9f97"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Load-uEnv.txt-from-boot.patch \
 "

SPL_BINARY = "MLO"

