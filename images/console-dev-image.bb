SUMMARY = "A console development image for the beaglebone"

require console-image.bb

DEV_SDK = " \
    binutils binutils-symlinks \
    cmake \
    cpp cpp-symlinks \
    elfutils elfutils-binutils \
    gcc gcc-symlinks \
    g++ g++-symlinks \
    gettext \
    git \
    ldd \
    libstdc++ \
    libstdc++-dev \
    libtool \
    make \
    pkgconfig \
    python3-modules \
"

IMAGE_INSTALL += " \
    ${DEV_SDK} \
"

export IMAGE_BASENAME = "console-dev-image"
