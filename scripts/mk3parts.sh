#!/bin/bash
#
# (c) Copyright 2012 Scott Ellis <scott@pansenti.com>
# Licensed under terms of GPLv2
#
# Based in large on the mksdcard.sh script from Steve Sakoman
# http://www.sakoman.com/category/3-bootable-sd-microsd-card-creation-script.html
#

if [ -n "$1" ]; then
	DRIVE=/dev/$1
else
	echo -e "\nUsage: sudo $0 <device>\n"
	echo -e "Example: sudo $0 sdb\n"
	exit 1
fi

if [ "$DRIVE" = "/dev/sda" ] ; then
	echo "Sorry, not going to format $DRIVE"
	exit 1
fi


echo -e "\nWorking on $DRIVE\n"

#make sure that the SD card isn't mounted before we start
if [ -b ${DRIVE}1 ]; then
	umount ${DRIVE}1
	umount ${DRIVE}2
	umount ${DRIVE}3
elif [ -b ${DRIVE}p1 ]; then
	umount ${DRIVE}p1
	umount ${DRIVE}p2
	umount ${DRIVE}p3
else
	umount ${DRIVE}
fi


SIZE=`fdisk -l $DRIVE | grep "Disk $DRIVE" | cut -d' ' -f5`

echo DISK SIZE – $SIZE bytes

if [ "$SIZE" -lt 4000000000 ]; then
	echo "Require an SD card of at least 4GB"
	exit 1
fi

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS – $CYLINDERS

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

## Standard 2 partitions
# Sectors are 512 bytes
# 0-127: 64KB, no partition, MBR then empty
# 128-131071: ~64 MB, dos partition, MLO, u-boot, kernel
# 131072-4194303: ~2GB, linux partition, root filesystem
# 4194304-end: 2GB+, linux partition, no assigned use

echo -e "\n=== Creating 3 partitions ===\n"
{
echo 128,130944,0x0C,*
echo 131072,4063232,0x83,-
echo 4194304,+,0x83,-
} | sfdisk --force -D -uS -H 255 -S 63 -C $CYLINDERS $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

