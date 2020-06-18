require linux-stable.inc

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "beaglebone"

KERNEL_DEVICETREE ?= " \
    am335x-boneblack.dtb \
    am335x-boneblack-wireless.dtb \
    am335x-boneblue.dtb \
    am335x-bonegreen.dtb \
    am335x-bonegreen-wireless.dtb \
    am335x-pocketbeagle.dtb \
    \
    bbb-4dcape43t.dtb \
    bbb-4dcape43t-spi.dtb \
    bbb-4dcape70t.dtb \
    bbb-gen4-4dcape50t.dtb \
    bbb-nhd5cape.dtb \
    bbb-nhd7cape.dtb \
    bbb-bcc-s6.dtb \
"

LINUX_VERSION = "5.6"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:${THISDIR}/linux-stable-${LINUX_VERSION}/dts:"

S = "${WORKDIR}/git"

PV = "5.6.19"
SRCREV = "61aba373f5708f2aebc3f72078e51949a068aa6f"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
    file://0001-spidev-Add-a-generic-compatible-id.patch \
    file://0002-dts-Remove-bbb-cape-i2c-definitions.patch \
    file://0003-wlcore-Change-NO-FW-RX-BA-session-warnings-to-debug.patch \
    \
    file://bbb-dcan0.dtsi \
    file://bbb-dcan1.dtsi \
    file://bbb-i2c1.dtsi \
    file://bbb-i2c2.dtsi \
    file://bbb-spi0-spidev.dtsi \
    file://bbb-spi1-spidev.dtsi \
    file://bbb-uart1.dtsi \
    file://bbb-uart2.dtsi \
    file://bbb-uart4.dtsi \
    file://bbb-uart5.dtsi \
    file://bbb-4dcape43t-keypad.dtsi \
    file://bbb-4dcape70t-keypad.dtsi \
    \
    file://bbb-4dcape43t.dts \
    file://bbb-4dcape43t-spi.dts \
    file://bbb-4dcape70t.dts \
    file://bbb-gen4-4dcape50t.dts \
    file://bbb-nhd5cape.dts \
    file://bbb-nhd7cape.dts \
    file://bbb-bcc-s6.dts \
"

do_configure_prepend () {
    cp ${WORKDIR}/*.dtsi ${S}/arch/arm/boot/dts
    cp ${WORKDIR}/*.dts ${S}/arch/arm/boot/dts
}
