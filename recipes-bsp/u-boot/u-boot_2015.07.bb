require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2015.07:"

PV = "2015.07"
PR = "r3"

COMPATIBLE_MACHINE = "beaglebone"

# for identification
UBOOT_LOCALVERSION = "-jumpnow"

# v2015.07
SRCREV = "33711bdd4a4dce942fb5ae85a68899a8357bdd94"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Load-uEnv.txt-from-rootfs-partition.patch \
    file://0002-Remove-spl-warnings-for-unused-features.patch \
 "

SPL_BINARY = "MLO"

