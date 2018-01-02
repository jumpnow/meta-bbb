#!/bin/bash

MACHINE=beaglebone
HOSTNAME=bbb
DSTDIR=~/bbb-mender/upload
IMG=mender-test
IMG_LONG="${IMG}-image-${MACHINE}"
CARDSIZE=4

if [ ! -d /media/card ]; then
    echo "Temporary mount point [/media/card] not found"
    exit 1
fi

if [ ! -d ${DSTDIR} ]; then
    echo "${DSTDIR} not found, attempting to create"
    mkdir -p ${DSTDIR}

    if [ $? -ne 0 ]; then
        echo "Failed to create ${DSTDIR}"
        exit 1
    fi
fi

if [ -z "${OETMP}" ]; then
    echo "OETMP environment variable not set"
    exit 1
fi

SRCDIR=${OETMP}/deploy/images/${MACHINE}

if [ ! -f "${SRCDIR}/${IMG_LONG}.tar.xz" ]; then
    echo "File not found: ${SRCDIR}/${IMG_LONG}.tar.xz"
    exit 1
fi

SDIMG=bbb-${IMG}-${CARDSIZE}gb.img

if [ -f "${DSTDIR}/${SDIMG}" ]; then
    rm ${DSTDIR}/${SDIMG}
fi

if [ -f "${DSTDIR}/${SDIMG}.xz" ]; then
    rm -f ${DSTDIR}/${SDIMG}.xz*
fi

echo "***** Creating the loop device *****"
LOOPDEV=`losetup -f`

echo "***** Creating an empty SD image file *****"
dd if=/dev/zero of=${DSTDIR}/${SDIMG} bs=1G count=${CARDSIZE}

echo "***** Partitioning the SD image file *****"
{
echo 16384,16384,0x0C,*
echo 32768,2097152,0x83,-
echo 2129920,2097152,0x83,-
echo 4227072,3145728,0x83,-
} | sfdisk ${DSTDIR}/${SDIMG}

sleep 1

echo "***** Attaching to the loop device *****"
sudo losetup -P ${LOOPDEV} ${DSTDIR}/${SDIMG}

echo "***** Copying the boot partition *****"
DEV=${LOOPDEV}p1
./copy_boot.sh ${DEV}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Copying the rootfs *****"
DEV=${LOOPDEV}p2
./copy_rootfs.sh ${DEV} ${IMG}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Copying the data partition *****"
DEV=${LOOPDEV}p4
./copy_mender_data.sh ${DEV}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Detatching loop device *****"
sudo losetup -D

echo "Skipping compression"
exit 1

echo "***** Compressing the SD card image *****"
sudo xz -9 ${DSTDIR}/${SDIMG}

echo "***** Creating an md5sum *****"
cd ${DSTDIR}
md5sum ${SDIMG}.xz > ${SDIMG}.xz.md5
cd ${OLDPWD}

echo "***** Done *****"
