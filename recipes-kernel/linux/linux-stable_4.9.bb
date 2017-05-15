require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel-base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = " \
    am335x-boneblack.dtb \
    am335x-bonegreen.dtb \
    am335x-bonegreen-wireless.dtb \
    bbb-hdmi.dtb \
    bbb-nohdmi.dtb \
    bbb-4dcape43t.dtb \
    bbb-4dcape70t.dtb \
    bbb-nh5cape.dtb \
    bbb-nhd7cape.dtb \
"

LINUX_VERSION = "4.9"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.9:"

S = "${WORKDIR}/git"

PR = "r27"

PV = "4.9.28"
SRCREV = "58cd97ff374b7c6c39c9a78595a5eb75a56a08ac"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.9.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-dts-Revoke-Beaglebone-i2c2-cape-definitions.patch \
    file://0003-Add-ft5x06-touchscreen-driver.patch \
    file://0004-Remove-jitter-from-ti-touchscreen-driver.patch \
    file://0005-dts-Add-bonegreen-wireless-files.patch \
    file://0006-dts-Add-custom-dts-files.patch \
    file://0007-wlcore-Change-no-NO_RX_BA_SESSION-warnings-to-debug.patch \
    file://0008-Add-dts-for-NewHaven-7-inch-display-cape.patch \
"
