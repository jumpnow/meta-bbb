require u-boot.inc

FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2017.05:"

PV = "2017.05"
PR = "r1"

COMPATIBLE_MACHINE = "beaglebone"

UBOOT_LOCALVERSION = "-jumpnow"

# v2017.05
SRCREV = "64c4ffa9fa223f7ae8640f9c8f3044bfa0e3bfda"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
    file://0001-Remove-unused-boot-options.patch \
    file://0002-Set-custom-bootcommand-always-envboot-first.patch \
    file://0003-Skip-check-for-boot-scr.patch \
"

SPL_BINARY = "MLO"
