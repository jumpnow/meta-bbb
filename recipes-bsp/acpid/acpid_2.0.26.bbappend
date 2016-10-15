FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://powerbtn-acpi-support.sh \
    file://events/powerbtn-acpi-support \
    file://init \
"


do_install_append() {
    install -d ${D}/etc/acpi/
    install -m 0755 ${WORKDIR}/powerbtn-acpi-support.sh ${D}/etc/acpi/
    install -m 0644 ${WORKDIR}/events/powerbtn-acpi-support ${D}/etc/acpi/events/
}
