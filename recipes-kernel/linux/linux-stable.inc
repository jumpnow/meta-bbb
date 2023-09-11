SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

LIC_FILES_CHKSUM ?= "file://COPYING;md5=bbea815ee2795b2f4230826c0c6b8814"

DEPENDS += "bc-native bison-native openssl-native util-linux-native xz-native"

inherit kernel
