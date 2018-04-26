FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += "file://0001-Remove-unused-boot-options.patch \
            file://0002-Always-check-for-envboot-first.patch \
            file://0003-Skip-check-for-boot-scr.patch \
           "

UBOOT_SUFFIX = "img"
SPL_BINARY = "MLO"
