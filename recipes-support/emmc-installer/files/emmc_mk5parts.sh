#!/bin/sh

DEV=/dev/mmcblk1

mount | grep -q ${DEV} 

if [ $? -eq 0 ]; then
	echo "Found mounted eMMC partitions."
	echo "Aborting"
	exit 1
fi

DEV=/dev/mmcblk1

SIZE=`fdisk -l $DEV | grep "Disk $DEV" | cut -d' ' -f5`

echo EMMC SIZE : $SIZE bytes

if [ "$SIZE" -lt 3800000000 ]; then
	echo "Require an eMMC of at least 4GB"
	exit 1
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DEV bs=1024 count=1024

## 5 partitions
# Sectors are 512 bytes
# 0-127: 64KB, no partition, MBR
# p1: 64MB, FAT partition, bootloader
# p2: 1GB, linux partition, first root filesystem
# p3: 1GB, linux partition, second root filesystem
# p4: extended partition
# p5: 64MB, FAT partition
# p6: ~2GB, linux partition

echo -e "\n=== Creating 5 partitions ===\n"
{
echo 128,131072,0x0C,*
echo ,2097152,0x83,-
echo ,2097152,0x83,-
echo ,,E
echo ,131072,0x0C,-
echo ,+,0x83,-
} | sfdisk $DEV

sleep 1

echo -e "\n=== Done! ===\n"

