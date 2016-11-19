SUMMARY = "A Qt5 development image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require console-image.bb

QT_TOOLS = " \
    qtbase \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qtserialport-dev \
    qtserialport-mkspecs \
    qt5-env \
 "

FONTS = " \
    fontconfig \
    fontconfig-dev \
    fontconfig-utils \
    ttf-bitstream-vera \
"

TSLIB = " \
    tslib-conf \
    tslib-calibrate \
    tslib-dev \
    tslib \
 "

IMAGE_INSTALL += " \
    ${FONTS} \
    ${QT_TOOLS} \
    qcolorcheck \
    qfontchooser \
    qkeytest \
    qshowfonts \
    ${TSLIB} \
    tspress \
 "

export IMAGE_BASENAME = "qt5-image"
