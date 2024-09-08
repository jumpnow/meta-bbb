#!/bin/bash

MACHINE=beaglebone
mnt=/mnt

if [ "x${1}" = "x" ]; then
    echo  "Usage: ${0} <block device> [ <image-type> [<hostname>] ]"
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

if [ "x${2}" = "x" ]; then
    image=console
else
    image=${2}
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

echo "EMMC IMAGE: $image"

if [ -f "${src}/${image}-image-${MACHINE}.rootfs.tar.gz" ]; then
    rootfs=${src}/${image}-image-${MACHINE}.rootfs.tar.gz
elif [ -f "${src}/${image}-${MACHINE}.rootfs.tar.gz" ]; then
    rootfs=${src}/${image}-${MACHINE}.rootfs.tar.gz
elif [ -f "${src}/${image}" ]; then
    rootfs=${src}/${image}
else
    echo "Rootfs file not found. Tried"
    echo " ${src}/${image}-image-${MACHINE}.rootfs.tar.gz"
    echo " ${src}/${image}-${MACHINE}.rootfs.tar.gz"
    echo " ${src}/${image}"
    exit 1
fi

if [ -b ${1} ]; then
        dev=${1}
elif [ -b "/dev/${1}2" ]; then
        dev=/dev/${1}2
elif [ -b "/dev/${1}p2" ]; then
        dev=/dev/${1}p2
else
        echo "Block device not found: /dev/${1}2 or /dev/${1}p2"
        exit 1
fi

dst="/mnt/home/root/emmc"

echo "Mounting $dev at ${mnt}"
sudo mount $dev $mnt

echo "Creating ${dst} directory"
sudo mkdir -p ${dst}

sudo rm -rf ${dst}/*

echo "Copying ${src}/MLO-${MACHINE}"
sudo cp ${src}/MLO-${MACHINE} ${dst}/MLO

echo "Copying ${src}/u-boot-${MACHINE}.img"
sudo cp ${src}/u-boot-${MACHINE}.img ${dst}/u-boot.img

echo "Copying ${src}/emmc-boot.scr"
sudo cp ${src}/emmc-boot.scr ${dst}/boot.scr

echo "Copying ${rootfs}"
sudo cp ${rootfs} ${dst}/rootfs.tar.gz

sudo sync

echo "Unmounting $dev"
sudo umount $dev

echo "Done"

