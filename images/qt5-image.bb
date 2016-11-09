SUMMARY = "A Qt5 development image"
HOMEPAGE = "http://www.jumpnowtek.com"
LICENSE = "MIT"

require console-image.bb

QT_TOOLS = " \
    qtbase \
    qtbase-dev \
    qtbase-fonts \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-tools \
    qt5-env \
 "

TSLIB = " \
    tslib-conf \
    tslib-calibrate \
    tslib-dev \
    tslib \
 "

IMAGE_INSTALL += " \
    ${QT_TOOLS} \
    qcolorcheck \
    qfontchooser \
    qkeytest \
    qshowfonts \
    ${TSLIB} \
    tspress \
 "

export IMAGE_BASENAME = "qt5-image"
