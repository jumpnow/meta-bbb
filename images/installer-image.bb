SUMMARY = "A minimal image used to launch an installer"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

IMAGE_LINGUAS = "en-us"

inherit core-image

IMAGE_INSTALL += " \
    emmc-installer \
 "

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

fixup_rc_scripts() {
    rm ${IMAGE_ROOTFS}/etc/rcS.d/S37populate-volatile.sh
    rm ${IMAGE_ROOTFS}/etc/rc5.d/S[0-8]*
    cd ${IMAGE_ROOTFS}/etc/rc5.d
    ln -sf ../init.d/emmc-installer S99emmc-installer
}

ROOTFS_POSTPROCESS_COMMAND += " \
    disable_bootlogd ; \
    fixup_rc_scripts ; \
 "

export IMAGE_BASENAME = "installer-image"
