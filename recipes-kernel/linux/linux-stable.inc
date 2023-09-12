SUMMARY = "Linux kernel"
SECTION = "kernel"
LICENSE = "GPL-2.0-only"

LIC_FILES_CHKSUM ?= "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

DEPENDS += "bc-native bison-native openssl-native util-linux-native xz-native"

inherit kernel
