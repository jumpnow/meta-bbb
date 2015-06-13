require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel_base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = " \
    am335x-boneblack.dtb \
    bbb-hdmi.dtb \
    bbb-4dcape70t.dtb \
    bbb-nh5cape.dtb \
 "

LINUX_VERSION = "4.0"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.0:"

S = "${WORKDIR}/git"

PR = "r1"

# v4.0.5 = be4cb235441a691ee63ba5e00843a9c210be5b8a
SRCREV = "be4cb235441a691ee63ba5e00843a9c210be5b8a"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.0.y \
    file://defconfig \
    file://0001-Add-bbb-spi1-spidev-dtsi.patch \
    file://0002-Add-bbb-i2c1-dtsi.patch \
    file://0003-Add-bbb-i2c2-dtsi.patch \
    file://0004-Add-bbb-hdmi-dts.patch \
    file://0005-Add-bbb-4dcape70t-dts.patch \
    file://0006-Add-ft5x06-touchscreen-driver.patch \
    file://0007-Add-bbb-nh5cape-dts.patch \
 "

