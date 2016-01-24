require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2016.01:"

PV = "2016.01"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

UBOOT_LOCALVERSION = "-jumpnow"

# v2016.01+
SRCREV = "12f229ea8f6c8e20f8fd07906eafc853c4c354a9"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Remove-some-unused-boot-options.patch \
 "

SPL_BINARY = "MLO"
