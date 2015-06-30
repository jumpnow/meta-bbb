#!/bin/bash
#
# Script to install a system onto the BBB eMMC
# This script handles the boot partition.
#
# This script should normally be run as
#
#  ./emmc_copy_boot.sh mmcblk1
#
# Assumes the following files are available in the local directory:
#
#   1) MLO-beaglebone
#   2) u-boot-beaglebone.img
#

MACHINE=beaglebone

if [ "x${1}" = "x" ]; then
	echo -e "\nUsage: ${0} <block device>\n"
	exit 0
fi

if [ ! -d /media ]; then
	echo "Mount point /media does not exist";
	exit 1
fi

if [ -z "$OETMP" ]; then
	echo -e "\nWorking from local directory"
    SRCDIR=.
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

DEV=/dev/${1}p1

if [ -b $DEV ]; then
	echo "Formatting FAT partition on $DEV"
	mkfs.vfat -F 32 ${DEV} -n BOOT

	echo "Mounting $DEV"
	mount ${DEV} /media

	echo "Copying MLO"
	cp ${SRCDIR}/MLO-${MACHINE} /media/MLO

	echo "Copying u-boot"
	cp ${SRCDIR}/u-boot-${MACHINE}.img /media/u-boot.img

	echo "Unmounting ${DEV}"
	umount ${DEV}
else
	echo -e "\nBlock device not found: $DEV\n"
fi

echo "Done"

