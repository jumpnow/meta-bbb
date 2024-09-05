#!/bin/bash

MACHINE=beaglebone
mnt=/mnt

if [ "x${1}" = "x" ]; then
    echo "Usage: ${0} <block device>"
    exit 0
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep '^/' | grep ${1}
    exit 1
fi

if [ ! -d ${mnt} ]; then
    echo "Temporary mount point [${mnt}] not found"
    exit 1
fi

if [ -z "$OETMP" ]; then
    # echo try to find it
    if [ -f ../../build/conf/local.conf ]; then
        OETMP=$(grep '^TMPDIR' ../../build/conf/local.conf | awk '{ print $3 }' | sed 's/"//g')

        if [ -z "$OETMP" ]; then
            OETMP=../../build/tmp
        fi
    fi
fi

echo "OETMP: $OETMP"

if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
    echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
    exit 1
fi

src=${OETMP}/deploy/images/${MACHINE}

if [ ! -f ${src}/MLO-${MACHINE} ]; then
    echo "File not found: ${src}/MLO-${MACHINE}"
    exit 1
fi

if [ ! -f ${src}/u-boot-${MACHINE}.img ]; then
    echo "File not found: ${src}/u-boot-${MACHINE}.img"
    exit 1
fi

if [ ! -f ${src}/boot.scr ]; then
    echo "File not found: ${src}/boot.scr"
    exit1
fi

if [ -b ${1} ]; then
    dev=${1}
elif [ -b "/dev/${1}1" ]; then
    dev=/dev/${1}1
elif [ -b "/dev/${1}p1" ]; then
    dev=/dev/${1}p1
else
    echo "Block device not found: /dev/${1}1 or /dev/${1}p1"
    exit 1
fi

echo "Formatting FAT partition on $dev"
sudo mkfs.vfat -n BOOT ${dev}

echo "Mounting $dev at ${mnt}"
sudo mount ${dev} ${mnt}

echo "Copying MLO"
sudo cp ${src}/MLO-${MACHINE} ${mnt}/MLO

echo "Copying u-boot.img"
sudo cp ${src}/u-boot-${MACHINE}.img ${mnt}/u-boot.img

echo "Copying boot.scr"
sudo cp ${src}/boot.scr ${mnt}/boot.scr

echo "Unmounting ${dev}"
sudo umount ${dev}

echo "Done"

