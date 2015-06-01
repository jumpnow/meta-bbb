require u-boot.inc

PV = "2015.04"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

# for identification
UBOOT_LOCALVERSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2015.04:"

# v2015.04
SRCREV = "f33cdaa4c3da4a8fd35aa2f9a3172f31cc887b35"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Load-uEnv-txt-from-rootfs-boot-dir.patch \
 "

SPL_BINARY = "MLO"

