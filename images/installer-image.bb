SUMMARY = "A minimal image used to launch an installer"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

IMAGE_LINGUAS = "en-us"

inherit core-image

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
 "

KERNEL_EXTRA_INSTALL = " \
    kernel-modules \
 "

IMAGE_INSTALL += " \
    emmc-installer \
 "

disable_bootlogd() {
    echo BOOTLOGD_ENABLE=no > ${IMAGE_ROOTFS}/etc/default/bootlogd
}

disable_rc5_scripts() {
    rm ${IMAGE_ROOTFS}/etc/rc5.d/S[0-8]*
}

ROOTFS_POSTPROCESS_COMMAND += " \
    disable_bootlogd ; \
    disable_rc5_scripts ; \
 "

export IMAGE_BASENAME = "installer-image"

