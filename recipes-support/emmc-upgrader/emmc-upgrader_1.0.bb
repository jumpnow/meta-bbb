SUMMARY = "Scripts to support a BBB eMMC upgrade"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://init \
           file://default \
           file://manage_boot_flag_partition.sh \
           file://bbb_upgrader.sh \
          "

PR = "r4"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "boot-flags"
INITSCRIPT_PARAMS = "start 99 5 ."

do_install_append () {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 init ${D}${sysconfdir}/init.d/boot-flags

    install -d ${D}${sysconfdir}/default
    install -m 0644 default ${D}${sysconfdir}/default/boot-flags

    install -d ${D}${bindir}
    install -m 0755 manage_boot_flag_partition.sh ${D}${bindir}
    install -m 0755 bbb_upgrader.sh ${D}${bindir}
}

FILES_${PN} = "${sysconfdir} ${bindir}"

RDEPENDS_${PN} = "coreutils dosfstools e2fsprogs-mke2fs util-linux" 
