SUMMARY = "Add usb mitm and logger capability to bbb"
HOMEPAGE = "http://www.jumpnowtek.com"

require console-image.bb

USB_TOOLS = " \
    libpcap libpcap-dev \
    libusb1 \
    python3-pyusb \
    usbutils usbutils-dev usbutils-python \
    usbproxy \
"

IMAGE_INSTALL += " \
    ${USB_TOOLS} \
"

export IMAGE_BASENAME = "usbproxy-image"
