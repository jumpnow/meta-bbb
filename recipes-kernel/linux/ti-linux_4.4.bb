require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = " \
    am335x-boneblack.dtb \
    bbb-hdmi.dtb \
    bbb-nohdmi.dtb \
 "

LINUX_VERSION = "4.4"
LINUX_VERSION_EXTENSION = "-ti-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/ti-linux-4.4:"

S = "${WORKDIR}/git"

PR = "r10"

PV = "4.4.56"
SRCREV = "fa8344bccf3f0b66d14a04479f53d06984e7a2a3"
SRC_URI = " \
    git://git.ti.com/ti-linux-kernel/ti-linux-kernel.git;branch=ti-linux-4.4.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-dts-Revoke-Beaglebone-i2c2-definitions.patch \
    file://0003-Add-ft5x06_ts-touchscreen-driver.patch  \
    file://0004-dts-Add-custom-bbb-dts-files.patch \
 "
