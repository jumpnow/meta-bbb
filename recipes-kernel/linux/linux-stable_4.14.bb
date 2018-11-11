require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=d7810fab7487fb0aad327b76f1be7cd7"

COMPATIBLE_MACHINE = "beaglebone"

KERNEL_DEVICETREE ?= " \
    am335x-boneblack.dtb \
    am335x-boneblack-wireless.dtb \
    am335x-bonegreen.dtb \
    am335x-bonegreen-wireless.dtb \
    bbb-hdmi.dtb \
    bbb-nohdmi.dtb \
    bbb-4dcape43t.dtb \
    bbb-4dcape70t.dtb \
    bbb-nh5cape.dtb \
    bbb-nhd7cape.dtb \
"

LINUX_VERSION = "4.14"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:"

S = "${WORKDIR}/git"

PV = "4.14.80"
SRCREV = "0b047cbc44ae7d0cea41a99cd7ec1f009360a605"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-dts-Revoke-Beaglebone-i2c2-cape-definitions.patch \
    file://0003-wlcore-Change-NO-FW-RX-BA-session-warnings-to-debug.patch \
    file://0004-Add-ft5x06-touchscreen-driver.patch \
    file://0005-dts-Add-custom-dts-files.patch \
"
