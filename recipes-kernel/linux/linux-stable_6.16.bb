require linux-stable.inc

KERNEL_CONFIG_COMMAND = "oe_runmake_call -C ${S} CC="${KERNEL_CC}" O=${B} olddefconfig"

COMPATIBLE_MACHINE = "beaglebone"

KERNEL_DEVICETREE ?= " \
    ti/omap/am335x-boneblack.dtb \
    ti/omap/am335x-boneblack-wireless.dtb \
    ti/omap/am335x-boneblue.dtb \
    ti/omap/am335x-bonegreen.dtb \
    ti/omap/am335x-bonegreen-wireless.dtb \
    ti/omap/am335x-pocketbeagle.dtb \
    ti/omap/bbb-gen4-4dcape70t.dtb \
"

LINUX_VERSION = "6.16"

FILESEXTRAPATHS:prepend := "${THISDIR}/linux-stable-${LINUX_VERSION}:${THISDIR}/linux-stable-${LINUX_VERSION}/dts:"

S = "${UNPACKDIR}/git"

PV = "6.16.2"
SRCREV = "25bf10be219d37d2fb221c93816a913f5f735530"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-${LINUX_VERSION}.y \
    file://defconfig \
    file://bbb-gen4-4dcape70t.dts \
"

do_configure:prepend() {
    cp ${UNPACKDIR}/*.dts ${S}/arch/arm/boot/dts/ti/omap
}
