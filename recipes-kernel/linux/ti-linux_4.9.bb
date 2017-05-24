require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = " \
    am335x-boneblack.dtb \
    am335x-bonegreen.dtb \
    am335x-bonegreen-wireless.dtb \
"

LINUX_VERSION = "4.9"
LINUX_VERSION_EXTENSION = "-ti-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/ti-linux-4.9:"

S = "${WORKDIR}/git"

PR = "r5"

PV = "4.9.29"
SRCREV= "28b6970466ab0e4f8a12b6f1fbdae284c2d51e07"
SRC_URI = " \
    git://git.ti.com/ti-linux-kernel/ti-linux-kernel.git;branch=ti-linux-4.9.y \
    file://defconfig \
    file://0001-spidev-Add-a-compatible-spidev-id.patch \
    file://0002-dts-Revoke-Beaglebone-i2c2-cape-definitions.patch \
    file://0003-Add-ft5x06-touchscreen-driver.patch \
    file://0004-Remove-jitter-from-ti-touchscreen-driver.patch \
    file://0005-dts-Add-bonegreen-wireless-files.patch \
    file://0006-wlcore-Change-no-NO_RX_BA_SESSION-warnings-to-debug.patch \
"
