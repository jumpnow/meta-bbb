SUMMARY = "U-boot script for beaglebone boards"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

COMPATIBLE_MACHINE = "beaglebone"

inherit deploy nopackages

DEPENDS = "u-boot-mkimage-native"

SRC_URI = " \
    file://boot-bonegreen.cmd \
    file://boot-boneblack.cmd \
"

# bonegreen as default dtb for now
do_compile() {
    mkimage -A arm -T script -C none -n "Boot script" -d "${WORKDIR}/boot-bonegreen.cmd" boot.scr
}

do_deploy() {
    install -d ${DEPLOYDIR}
    install -m 0644 boot.scr ${DEPLOYDIR}/boot.scr
}

addtask deploy before do_build after do_compile
