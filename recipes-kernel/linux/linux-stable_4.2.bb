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

PR = "r5"

# v4.2.3  
SRCREV = "fcba09f2b0bf27eeaa1d4d439edb649585f35040"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.2.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-mmc-Allow-writes-to-mmcblkboot-partitions.patch \
    file://0003-Revert-usb-musb-dsps-just-start-polling-already.patch \
    file://0005-dts-Add-some-dtsi-files-for-common-controllers.patch \
    file://0006-dts-Add-bbb-hdmi-dts.patch \
    file://0007-dts-Add-bbb-4dcape70t-dts.patch \
    file://0008-Add-ft5x06_ts-touchscreen-driver.patch \
    file://0009-dts-Add-bbb-nh5cape-dts.patch \
 "

