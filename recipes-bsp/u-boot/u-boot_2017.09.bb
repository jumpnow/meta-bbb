require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2017.09:"

PV = "2017.09"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

UBOOT_LOCALVERSION = "-jumpnow"

# v2017.09
SRCREV = "c98ac3487e413c71e5d36322ef3324b21c6f60f9"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Remove-unused-boot-options.patch \
    file://0002-Always-check-for-envboot-first.patch \
    file://0003-Skip-check-for-boot-scr.patch \
"

SPL_BINARY = "MLO"
