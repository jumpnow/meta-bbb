require recipes-kernel/linux/linux-yocto.inc

KERNEL_IMAGETYPE = "zImage"

COMPATIBLE_MACHINE = "beaglebone"

RDEPENDS_kernel_base += "kernel-devicetree"

KERNEL_DEVICETREE_beaglebone = "am335x-boneblack.dtb \
    bbb-4dcape70t.dtb"

LINUX_VERSION = "4.0"
LINUX_VERSION_EXTENSION = "-jumpnow"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-stable-4.0:"

S = "${WORKDIR}/git"

# v4.0.4 = 8b660f48b5734edc272a008a34207cf1a249fcf7 
SRCREV = "8b660f48b5734edc272a008a34207cf1a249fcf7"
SRC_URI = " \
    git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git;branch=linux-4.0.y \
    file://0001-Add-dts-for-4dcape70t.patch \
    file://defconfig \
 "

