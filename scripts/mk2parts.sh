#!/bin/bash
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
elif [ -b ${DRIVE}p1 ]; then
	umount ${DRIVE}p1
	umount ${DRIVE}p2
else
	umount ${DRIVE}
fi


SIZE=`fdisk -l $DRIVE | grep "Disk $DRIVE" | cut -d' ' -f5`

echo DISK SIZE – $SIZE bytes

if [ "$SIZE" -lt 1800000000 ]; then
	echo "Require an SD card of at least 2GB"
	exit 1
fi

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS – $CYLINDERS

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

# Standard 2 partitions
# Sectors are 512 bytes
# 0-127: 64KB, no partition, MBR then empty
# 128-131071: ~64 MB, dos partition, MLO, u-boot, kernel
# 131072-end: 2GB+, linux partition, root filesystem

echo -e "\n=== Creating 2 partitions ===\n"
{
echo 128,130944,0x0C,*
echo 131072,,,-
} | sfdisk --force -D -uS -H 255 -S 63 -C $CYLINDERS $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

