#!/bin/sh

DEV=/dev/mmcblk1

echo -e "\nWorking on $DEV\n"

mount | grep -q $DEV

if [ $? -eq 0 ]; then
	echo "Found mounted eMMC partitions"
	echo "Aborting"
	exit 1
fi

SIZE=`fdisk -l $DEV | grep "Disk $DEV" | cut -d' ' -f5`

echo EMMC SIZE – $SIZE bytes

if [ "$SIZE" -lt 1800000000 ]; then
	echo "Require an eMMC of at least 2GB"
	exit 1
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DEV bs=1024 count=1024

# Minimum required 2 partitions
# Sectors are 512 bytes
# 0     : 64KB, no partition, MBR then empty
# 128   : 64MB, FAT partition, bootloader 
# 131200: 2GB+, linux partition, root filesystem

echo -e "\n=== Creating 2 partitions ===\n"
{
echo 128,131072,0x0C,*
echo 131200,+,0x83,-
} | sfdisk $DEV


sleep 1

echo -e "\n=== Done! ===\n"

