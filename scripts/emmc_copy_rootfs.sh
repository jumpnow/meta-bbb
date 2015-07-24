#!/bin/bash
#
# Script to install a system onto the BBB eMMC.
# This script handles the root fs partition.
#
# It should normally be invoked as:
#
#  ./emmc_copy_rootfs.sh mmcblk1 [<image>]
#
# where <image> is qt5 or console.
#
# Assumes the following files are available in the local directory:
#
#  1) zImage-am335x-boneblack.dtb
#  2) zImage-bbb-hdmi-dtb
#  3) zImage-bbb-4dcape70t.dtb
#  4) zImage-bbb-nh5cape.dtb
#  5) ${IMAGE}-image-beaglebone.tar.xz where ${IMAGE} is the 2nd arg to this script
#  6) emmc-uEnv.txt

MACHINE=beaglebone
DTB_LIST="am335x-boneblack bbb-hdmi bbb-4dcape70t bbb-nh5cape"
SRCDIR=.

if [ "x${1}" = "x" ]; then
	echo -e "\nUsage: ${0} <block device> [ <image-type> [<hostname>] ]\n"
	exit 0
fi

if [ ! -d /media ]; then
	echo "Mount point /media does not exist"
	exit 1
fi

if [ "x${2}" = "x" ]; then
        IMAGE=console
else
        IMAGE=${2}
fi

echo "IMAGE: $IMAGE"

if [ "x${3}" = "x" ]; then
        TARGET_HOSTNAME=$MACHINE
else
        TARGET_HOSTNAME=${3}
fi

echo -e "HOSTNAME: $TARGET_HOSTNAME\n"


if [ ! -f "${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz" ]; then
        echo "File not found: ${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz"
        exit 1
fi

for dtb in $DTB_LIST; do
	if [ ! -f ${SRCDIR}/zImage-${dtb}.dtb ]; then
		echo "DTB file not found: ${SRCDIR}/zImage-${dtb}.dtb"
		exit 1
	fi
done 

DEV=/dev/${1}p2

if [ -b $DEV ]; then
	echo "Formatting $DEV as ext4"
	mkfs.ext4 -q -L ROOT $DEV

	echo "Mounting $DEV"
	mount $DEV /media

	echo "Extracting ${IMAGE}-image-${MACHINE}.tar.xz to /media"
	tar -C /media -xJf ${SRCDIR}/${IMAGE}-image-${MACHINE}.tar.xz

	for dtb in $DTB_LIST; do
		echo "Copying ${dtb}.dtb to /media/boot/"
		cp ${SRCDIR}/zImage-${dtb}.dtb /media/boot/${dtb}.dtb
	done

	echo "Writing hostname to /etc/hostname"
	export TARGET_HOSTNAME
	echo ${TARGET_HOSTNAME} > /media/etc/hostname        

	if [ -f ${SRCDIR}/interfaces ]; then
		echo "Writing interfaces to /media/etc/network/"
		cp ${SRCDIR}/interfaces /media/etc/network/interfaces
	fi

	if [ -f ${SRCDIR}/wpa_supplicant.conf ]; then
		echo "Writing wpa_supplicant.conf to /media/etc/"
		cp ${SRCDIR}/wpa_supplicant.conf /media/etc/wpa_supplicant.conf
	fi

	echo "Unmounting $DEV"
	umount $DEV
else
	echo "Block device $DEV does not exist"
fi

echo "Done"

