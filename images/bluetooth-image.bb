SUMMARY = "A bluetooth development image"
HOMEPAGE = "http://www.jumpnowtek.com"

require console-image.bb

BT_SUPPORT = " \
    bluez5 \
    bluez5-dev \
"

IMAGE_INSTALL += " \
    ${BT_SUPPORT} \
"

export IMAGE_BASENAME = "bluetooth-image"
