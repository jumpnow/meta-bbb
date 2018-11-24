SUMMARY = "A Qt5 development image"
HOMEPAGE = "http://www.jumpnowtek.com"

require console-image.bb

QT_DEV_TOOLS = " \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-tools \
    qtserialport-dev \
    qtserialport-mkspecs \
"

QT_TOOLS = " \
    qtbase \
    qtbase-plugins \
    qtserialport \
    qt5-env \
"

FONTS = " \
    fontconfig \
    fontconfig-utils \
    ttf-bitstream-vera \
"

TSLIB = " \
    tslib \
    tslib-calibrate \
    tslib-conf \
"

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_DEV_TOOLS} \
    ${QT_TOOLS} \
    qcolorcheck-tools \
    ${TSLIB} \
    tspress-tools \
"

export IMAGE_BASENAME = "qt5-image"
