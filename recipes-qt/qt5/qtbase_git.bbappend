FILESEXTRAPATHS_append := "${THISDIR}/qtbase:"

SRC_URI += "file://Do-not-declare-platformTextureList-when-not-used.patch"

PACKAGECONFIG_append = " accessibility linuxfb"
