#!/bin/sh

if [ -e /dev/input/touchscreen0 ]; then
    export QWS_MOUSE_PROTO=Tslib:/dev/input/touchscreen0
fi

# defaults for the Overo lcd43 touchscreen
# export QWS_SIZE=480x272
# export QWS_DISPLAY="linuxfb:mmHeight=53:mmWidth=95"

# defaults for a HDMI 1080p system, like the ST1080 goggles with duovero
# export QWS_SIZE=1920x1080

# for native development convenience
if [ -e /usr/share/qtopia/environment-setup ]; then
    source /usr/share/qtopia/environment-setup
    export OE_QMAKE_STRIP=/usr/bin/strip
fi

