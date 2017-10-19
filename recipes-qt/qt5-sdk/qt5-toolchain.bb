SUMMARY = "Meta package for building an installable Qt5 toolchain and SDK"
LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COREBASE}/LICENSE;md5=4d92cd373abda3937c2bc47fbc49d690 \
                    file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

inherit populate_sdk

RDEPENDS_${PN} += " \
    packagegroup-core-standalone-sdk-target \
    libsqlite3-dev \
    qtbase-dev \
    qtbase-mkspecs \
    qtbase-plugins \
    qtbase-staticdev \
    qttranslations-qt \
    qttranslations-qtbase \
    qttranslations-qtconfig \
    qttranslations-qthelp \
    qtconnectivity-dev \
    qtconnectivity-mkspecs \
    qttranslations-qtconnectivity \
    qtdeclarative-dev \
    qtdeclarative-mkspecs \
    qtdeclarative-tools \
    qtdeclarative-staticdev \
    qttranslations-qmlviewer \
    qttranslations-qtdeclarative \
    qtimageformats-dev \
    qtimageformats-plugins \
    qtlocation-dev \
    qtlocation-mkspecs \
    qtlocation-plugins \
    qttranslations-qtlocation \
    qtmultimedia-dev \
    qtmultimedia-mkspecs \
    qtmultimedia-plugins \
    qttranslations-qtmultimedia \
    qttranslations-qtscript \
    qtsensors-dev \
    qtsensors-mkspecs \
    qtsensors-plugins \
    qtserialport-dev \
    qtserialport-mkspecs \
    qtserialbus-dev \
    qtserialbus-mkspecs \
    qtsvg-dev \
    qtsvg-mkspecs \
    qtsvg-plugins \
    qtsystems-dev \
    qtsystems-mkspecs \
    qttools-dev \
    qttools-mkspecs \
    qttools-staticdev \
    qttools-tools \
    qtwebsockets-dev \
    qtwebsockets-mkspecs \
    qttranslations-qtwebsockets \
    qtwebchannel-dev \
    qtwebchannel-mkspecs \
    qtxmlpatterns-dev \
    qtxmlpatterns-mkspecs \
    qttranslations-qtxmlpatterns \
"

