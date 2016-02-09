SUMMARY = "Convenience script to enable/disable the fb cursor"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://cursor-on \
           file://cursor-off \
          "

PR = "0"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 cursor-on ${D}${bindir}
    install -m 0755 cursor-off ${D}${bindir}
}

FILES_${PN} = "${bindir}"

