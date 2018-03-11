SUMMARY = "Scripts to run during Mender upgrades"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "file://save-ssh-keys.sh.in"

inherit mender-state-scripts

S = "${WORKDIR}"

do_compile() {
    if [ -n ${MENDER_STORAGE_DEVICE} ]; then
        sed -e 's:@@ROOTDEV@@:${MENDER_STORAGE_DEVICE}:g' \
            "${WORKDIR}/save-ssh-keys.sh.in" > "${MENDER_STATE_SCRIPTS_DIR}/Download_Leave_01"
    fi
}
