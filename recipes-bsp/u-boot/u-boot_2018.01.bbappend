FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot-2018.01:"

SRC_URI += "file://0001-Set-custom-default-boot-command.patch"

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
