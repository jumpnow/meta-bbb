#!/bin/sh

export PATH=${PATH}:/usr/bin/qt5

export QT_QPA_PLATFORM=linuxfb

# to use tslib for input (no multi-touch)
#export QT_QPA_FB_TSLIB=1

# replace with correct /dev/input/eventX if this is wrong
#export TSLIB_TSDEVICE=/dev/input/touchscreen0
