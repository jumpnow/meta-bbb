SUMMARY = "Installs an image to the eMMC of a beaglebone"

IMAGE_LINGUAS = "en-us"

inherit image

CORE_OS = " \
    openssh openssh-keygen openssh-sftp-server \
    packagegroup-core-boot \
    tzdata \
"

EXTRA_TOOLS = " \
    bzip2 \
    coreutils \
    diffutils \
    dosfstools \
    e2fsprogs-mke2fs \
    emmc-installer \
    file \
    findutils \
    grep \
    iproute2-ifstat iproute2-ip iproute2-nstat iproute2-ss \
    less \
    mtd-utils \
    parted \
    procps \
    sysfsutils \
    tar \
    util-linux \
    util-linux-blkid \
    unzip \
    wget \
    zip \
"

IMAGE_INSTALL += " \
    ${CORE_OS} \
    ${EXTRA_TOOLS} \
"

set_local_timezone() {
    ln -sf /usr/share/zoneinfo/EST5EDT ${IMAGE_ROOTFS}/etc/localtime
    echo 'America/New_York' > ${IMAGE_ROOTFS}/etc/timezone
}

ROOTFS_POSTPROCESS_COMMAND += " \
    set_local_timezone ; \
"

export IMAGE_BASENAME = "emmc-installer-image"
