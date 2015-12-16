#!/bin/sh
#
# Script to install a system onto the BBB eMMC
# This script handles the boot partition.
#
# This script should normally be run as
#
#  ./emmc_copy_boot.sh
#
# Assumes the following files are available in the local directory:
#
#   1) MLO-beaglebone
#   2) u-boot-beaglebone.img
#

MACHINE=beaglebone
DEV=/dev/mmcblk1p1

if [ -z "${SRCDIR}" ]; then
	SRCDIR=.
else
	if [ ! -d "${SRCDIR}" ]; then
		echo "Source directory not found: ${SRCDIR}"
		exit 1
	fi
fi

if [ ! -b ${DEV} ]; then
	echo "Block device not found: ${DEV}"
	exit 1
fi

if [ ! -d /media ]; then
	echo "Mount point /media does not exist";
	exit 1
fi

if [ ! -f ${SRCDIR}/MLO-${MACHINE} ]; then
	echo -e "File not found: ${SRCDIR}/MLO-${MACHINE}\n"
	exit 1
fi

if [ ! -f ${SRCDIR}/u-boot-${MACHINE}.img ]; then
	echo -e "File not found: ${SRCDIR}/u-boot-${MACHINE}.img\n"
	exit 1
fi

if [ ! -f "${SRCDIR}/emmc-uEnv.txt" ]; then
        echo "File not found: ${SRCDIR}/emmc-uEnv.txt"
        exit 1
fi

echo "Formatting FAT partition on $DEV"
mkfs.vfat -F 32 ${DEV} -n BOOT

echo "Mounting $DEV"
mount ${DEV} /media

echo "Copying MLO"
cp ${SRCDIR}/MLO-${MACHINE} /media/MLO

echo "Copying u-boot"
cp ${SRCDIR}/u-boot-${MACHINE}.img /media/u-boot.img

echo "Copying emmc-uEnv.txt to uEnv.txt"
cp ${SRCDIR}/emmc-uEnv.txt /media/uEnv.txt

echo "Unmounting ${DEV}"
umount ${DEV}

echo "Done"

