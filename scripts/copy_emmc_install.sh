#!/bin/bash

MACHINE=beaglebone
SUPPORT_SCRIPTS="emmc-uEnv.txt"

if [ "x${1}" = "x" ]; then
        echo "Usage: ${0} <block device> [ <image-type> ] ]"
        exit 0
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep '^/' | grep ${1}
    exit 1
fi

if [ ! -d /media/card ]; then
        echo "Mount point /media/card does not exist"
        exit 1
fi

if [ "x${2}" = "x" ]; then
        IMAGE=console
else
        IMAGE=${2}
fi

echo "IMAGE: $IMAGE"

if [ -z "$OETMP" ]; then
    # echo try to find it
    if [ -f ../../build/conf/local.conf ]; then
        OETMP=$(grep '^TMPDIR' ../../build/conf/local.conf | awk '{ print $3 }' | sed 's/"//g')

        if [ -z "$OETMP" ]; then
            OETMP=../../build/tmp
        fi
    fi
fi

if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
    echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
    exit 1
fi

SRCDIR=${OETMP}/deploy/images/${MACHINE}

echo "OETMP: $OETMP"

if [ ! -f ${SRCDIR}/MLO-${MACHINE} ]; then
        echo "File not found: ${SRCDIR}/MLO-${MACHINE}"
        exit 1
fi

if [ ! -f ${SRCDIR}/u-boot-${MACHINE}.img ]; then
        echo "File not found: ${SRCDIR}/u-boot-${MACHINE}.img"
        exit 1
fi

if [ ! -f "${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz" ]; then
        echo "File not found: ${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz"
        exit 1
fi

for file in $SUPPORT_SCRIPTS; do
    if [ ! -f ${SRCDIR}/${file} ]; then
        if [ ! -f ./${file} ]; then
            echo "Support script not found: ${file}"
            exit 1
    	fi
    fi
done

if [ -b ${1} ]; then
        DEV=${1}
elif [ -b "/dev/${1}2" ]; then
        DEV=/dev/${1}2
elif [ -b "/dev/${1}p2" ]; then
        DEV=/dev/${1}p2
else
        echo "Block device not found: /dev/${1}2 or /dev/${1}p2"
        exit 1
fi

echo "Mounting ${DEV} to /media/card"
sudo mount ${DEV} /media/card

if [ ! -d /media/card/home/root ]; then
    echo "Directory not found: /media/card/home/root"
    echo "Did you run copy_rootfs.sh first?"
    sudo umount ${DEV}
    exit 1
fi

echo "Creating /media/card/home/root/emmc directory"
sudo mkdir -p /media/card/home/root/emmc

echo "Copying files"
sudo cp ${SRCDIR}/MLO-${MACHINE} /media/card/home/root/emmc
sudo cp ${SRCDIR}/u-boot-${MACHINE}.img /media/card/home/root/emmc
sudo cp ${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz /media/card/home/root/emmc

for file in $SUPPORT_SCRIPTS; do
    if [ -f $SRCDIR/${file} ]; then
    	sudo cp ${SRCDIR}/${file} /media/card/home/root/emmc
    else
    	sudo cp ./${file} /media/card/home/root/emmc
    fi
done

echo "Unmounting ${DEV}"
sudo umount ${DEV}

echo "Done"
