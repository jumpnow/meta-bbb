SUMMARY = "BBGW wireless support"

LICENSE = "GPL-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

SRC_URI = "file://init \
           file://default \
           file://TIInit_11.8.32.bts \
           file://wl18xx-conf.bin \
          "

PR = "r0"

S = "${WORKDIR}"

inherit update-rc.d

INITSCRIPT_NAME = "bt-init"
INITSCRIPT_PARAMS = "start 10 5 .  stop 25 0 6 ."

do_install_append () {
    install -d ${D}${sysconfdir}/init.d
    install -m 0755 init ${D}${sysconfdir}/init.d/bt-init

    install -d ${D}${sysconfdir}/default
    install -m 0666 default ${D}${sysconfdir}/default/bt-init

    install -d ${D}/lib/firmware/ti-connectivity
    install -m 0644 TIInit_11.8.32.bts ${D}/lib/firmware/ti-connectivity
    install -m 0644 wl18xx-conf.bin ${D}/lib/firmware/ti-connectivity
}

FILES_${PN} = "${sysconfdir} /lib"
