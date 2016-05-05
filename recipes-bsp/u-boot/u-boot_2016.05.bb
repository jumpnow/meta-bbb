require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2016.05:"

PV = "2016.05"
PR = "r2"

COMPATIBLE_MACHINE = "beaglebone"

UBOOT_LOCALVERSION = "-jumpnow"

# v2016.05-rc3+
SRCREV = "bbca7108db79076d3a9a9c112792d7c4608a665c"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Remove-some-unused-boot-options.patch \
 "

SPL_BINARY = "MLO"
