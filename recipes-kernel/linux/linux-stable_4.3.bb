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

LINUX_VERSION = "4.3"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.3:"

S = "${WORKDIR}/git"

PR = "r1"

# v4.3-rc7  
SRCREV = "32b88194f71d6ae7768a29f87fbba454728273ee"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=master \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0003-dts-Revoke-Beaglebone-i2c2-definitions.patch \
    file://0004-dts-Add-some-dtsi-files-for-common-controllers.patch \
    file://0005-dts-Add-bbb-hdmi-dts.patch \
    file://0006-dts-Add-bbb-4dcape70t-dts.patch \
    file://0007-Add-ft5x06_ts-touchscreen-driver.patch \
    file://0008-dts-Add-bbb-nh5cape-dts.patch \
 "

