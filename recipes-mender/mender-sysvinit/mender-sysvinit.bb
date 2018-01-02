SUMMARY = "Start the mender daemon"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://init"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "mender.sh"
INITSCRIPT_PARAMS = "start 35 5 .  stop 70 0 6 ."

do_install_append () {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 init ${D}${sysconfdir}/init.d/mender.sh
}

FILES_${PN} = "${sysconfdir}"
