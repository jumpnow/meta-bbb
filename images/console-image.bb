SUMMARY = "A console development image"
HOMEPAGE = "http://www.jumpnowtek.com"

require images/basic-image.bb

WIFI = " \
    bbgw-wireless \
    crda \
    iw \
    linux-firmware-wl18xx \
    wpa-supplicant \
"

DEV_EXTRAS = " \
    serialecho \
    spiloop \
"

IMAGE_INSTALL += " \
    emmc-upgrader \
    ${DEV_EXTRAS} \
    ${WIFI} \
"

export IMAGE_BASENAME = "console-image"
