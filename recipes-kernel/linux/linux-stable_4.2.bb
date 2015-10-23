require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = " \
    am335x-boneblack.dtb \
    bbb-hdmi.dtb \
    bbb-4dcape70t.dtb \
    bbb-nh5cape.dtb \
 "

LINUX_VERSION = "4.2"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.2:"

S = "${WORKDIR}/git"

PR = "r6"

# v4.2.4  
SRCREV = "190bd21bba09ed476d9359d3e8be20e8d9dcd8a4"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.2.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0005-dts-Add-some-dtsi-files-for-common-controllers.patch \
    file://0006-dts-Add-bbb-hdmi-dts.patch \
    file://0007-dts-Add-bbb-4dcape70t-dts.patch \
    file://0008-Add-ft5x06_ts-touchscreen-driver.patch \
    file://0009-dts-Add-bbb-nh5cape-dts.patch \
 "

