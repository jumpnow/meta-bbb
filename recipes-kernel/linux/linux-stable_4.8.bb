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
 "

LINUX_VERSION = "4.8"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.8:"

S = "${WORKDIR}/git"

PR = "r8"

# v4.8.7
SRCREV = "567aeca9fbb7f1f00fc6bbdd6861010ce7ddaf22"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.8.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-dts-Revoke-Beaglebone-i2c2-cape-definitions.patch \
    file://0003-Add-ft5x06_ts-touchscreen-driver.patch \
    file://0004-dts-Add-custom-dts-files.patch \
    file://0005-tps65217-Enable-KEY_POWER-press-on-AC-loss-PWR_BUT.patch \
    file://0006-Remove-jitter-from-ti-touchscreen-driver.patch \
    file://0007-dts-Add-support-for-4dcape43-touchscreen.patch \
    file://0008-dts-Add-bonegreen-wireless-files.patch \
 "
