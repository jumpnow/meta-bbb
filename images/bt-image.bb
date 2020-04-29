SUMMARY = "A console development image with bluetooth support"

require console-image.bb

BT = " \
    bluez5 \
    bluez5-dev \
    bluez5-noinst-tools \
    bluez5-obex \
    bluez5-testtools \
"

PYTHON_BT = " \
    python3-pybluez \
    python3-pygatt \
    python3-pygattlib \
"

IMAGE_INSTALL += " \
    ${BT} \
    ${PYTHON_BT} \
"

export IMAGE_BASENAME = "bt-image"
