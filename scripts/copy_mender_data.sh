#!/bin/bash

MACHINE=beaglebone

if [ ! -d /media/card ]; then
    echo "Temporary mount point [/media/card] not found"
    exit 1
fi

if [ -z "$OETMP" ]; then
    echo "Working from local directory"
    SRCDIR=.
else
    echo "OETMP: $OETMP"

    if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
        echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
        exit 1
    fi

    SRCDIR=${OETMP}/deploy/images/${MACHINE}
fi

if [ ! -f ${SRCDIR}/data.tar ]; then
    echo "File not found: ${SRCDIR}/data.tar"
    exit 1
fi

if [ -b ${1} ]; then
    DEV=${1}
elif [ -b "/dev/${1}4" ]; then
    DEV=/dev/${1}4
elif [ -b "/dev/${1}p4" ]; then
    DEV=/dev/${1}p4
else
    echo "Block device not found: /dev/${1}4 or /dev/${1}p4"
    exit 1
fi

sudo mkfs.ext4 -q ${DEV}

sudo mount ${DEV} /media/card

sudo tar xf ${SRCDIR}/data.tar -C /media/card --strip-components=1 

sudo mkdir /media/card/mender
export MACHINE
sudo -E bash -c 'echo "device_type=${MACHINE}" > /media/card/mender/device_type'
sudo chmod 444 /media/card/mender/device_type

sudo umount ${DEV}
