FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://power-button-event"

do_install_append () {
	install -d ${D}${sysconfdir}/acpi/events
	install -m 0644 ${WORKDIR}/power-button-event ${D}${sysconfdir}/acpi/events
}
