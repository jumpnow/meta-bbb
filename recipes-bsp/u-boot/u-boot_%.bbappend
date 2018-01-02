FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI_append = " file://0001-Add-environment-debug.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
