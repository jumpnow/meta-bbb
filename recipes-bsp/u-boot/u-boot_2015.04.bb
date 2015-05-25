require u-boot.inc

PV = "2015.04"

COMPATIBLE_MACHINE = "beaglebone"

# for identification
UBOOT_LOCALVERSION = "-jumpnow"

# v2015.04
SRCREV = "f33cdaa4c3da4a8fd35aa2f9a3172f31cc887b35"
SRC_URI = " \
    git://git.denx.de/u-boot.git;branch=master;protocol=git \
 "

SPL_BINARY = "MLO"

