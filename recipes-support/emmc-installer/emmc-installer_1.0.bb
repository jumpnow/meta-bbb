SUMMARY = "Scripts to support a BBB eMMC installation"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

SRC_URI = "\
    file://emmc-installer.service \
    file://emmc-installer-default \
    file://emmc_installer.sh \
    file://emmc_mk2parts.sh \
    file://emmc_copy_files.sh \
    file://cylon.sh \
"

S = "${WORKDIR}"

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "emmc-installer.service"

do_install () {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/emmc-installer.service ${D}${systemd_system_unitdir}

    install -d ${D}${sysconfdir}/default
    install -m 0644 ${S}/emmc-installer-default ${D}${sysconfdir}/default/emmc-installer

    install -d ${D}${bindir}
    install -m 0755 ${S}/emmc_installer.sh ${D}${bindir}
    install -m 0755 ${S}/emmc_mk2parts.sh ${D}${bindir}
    install -m 0755 ${S}/emmc_copy_files.sh ${D}${bindir}
    install -m 0755 ${S}/cylon.sh ${D}${bindir}
}

RDEPENDS:${PN} = "bash coreutils dosfstools e2fsprogs-mke2fs util-linux" 

FILES:${PN} = "${systemd_system_unitdir} ${sysconfdir} ${bindir}"
