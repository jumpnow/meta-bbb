SUMMARY = "A very basic image"
HOMEPAGE = "http://www.jumpnowtek.com"

IMAGE_LINGUAS = "en-us"

inherit image

IMAGE_INSTALL += " \
    kernel-modules \
    packagegroup-core-boot \
"

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

ROOTFS_POSTPROCESS_COMMAND += " \
    disable_bootlogd ; \
"

export IMAGE_BASENAME = "basic-image"
