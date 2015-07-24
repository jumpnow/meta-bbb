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

LINUX_VERSION = "4.1"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.1:"

S = "${WORKDIR}/git"

PR = "r5"

# v4.1.3  
SRCREV = "c8bde72f9af412de57f0ceae218d648640118b0b"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.1.y \
    file://defconfig \
    file://0001-spidev-Add-generic-compatible-dt-id.patch \
    file://0002-Add-bbb-spi1-spidev-dtsi.patch \
    file://0003-Add-bbb-i2c1-dtsi.patch \
    file://0004-Add-bbb-i2c2-dtsi.patch \
    file://0005-Add-bbb-hdmi-dts.patch \
    file://0006-Add-bbb-4dcape70t-dts.patch \
    file://0007-Add-ft5x06-touchscreen-driver.patch \
    file://0008-Add-bbb-nh5cape-dts.patch \
    file://0009-Add-4dcape70t-button-dtsi.patch \
    file://0010-4dcape70t-dts-include-button-dtsi-comment-out-spi.patch \
    file://0011-mmc-Allow-writes-to-mmcblkboot-partitions.patch \
 "

