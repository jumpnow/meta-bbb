#!/bin/bash

MACHINE=beaglebone
SUPPORT_SCRIPTS="emmc-uEnv.txt"

if [ "x${1}" = "x" ]; then
        echo -e "\nUsage: ${0} <block device> [ <image-type> ] ]\n"
        exit 0
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

if [ -z "$OETMP" ]; then
	if [ -d ${HOME}/bbb/build/tmp/deploy/images/${MACHINE} ]; then
		echo -e "\nUsing ${HOME}/elvaria/build/tmp"
		SRCDIR=${HOME}/bbb/build/tmp
	else
		echo -e "\nWorking from local directory"
		SRCDIR=.
	fi
else
        echo -e "\nOETMP: $OETMP"

        if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
                echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
                exit 1
        fi

        SRCDIR=${OETMP}/deploy/images/${MACHINE}
fi

if [ ! -f ${SRCDIR}/MLO-${MACHINE} ]; then
        echo -e "File not found: ${SRCDIR}/MLO-${MACHINE}\n"
        exit 1
fi

if [ ! -f ${SRCDIR}/u-boot-${MACHINE}.img ]; then
        echo -e "File not found: ${SRCDIR}/u-boot-${MACHINE}.img\n"
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

DEV=/dev/${1}2

if [ ! -b ${DEV} ]; then
	echo "Block device ${DEV} not found"
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

if [ ! -d /media/card/home/root/emmc ]; then
	echo "Creating /media/card/home/root/emmc directory"
	sudo mkdir /media/card/home/root/emmc
fi

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
