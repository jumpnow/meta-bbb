#!/bin/bash

if [ -n "$1" ]; then
    DRIVE=/dev/$1
else
    echo -e "\nUsage: sudo $0 <device>\n"
    echo -e "Example: sudo $0 sdb\n"
    exit 1
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep ${1}
    exit 1
fi

echo -e "\nWorking on $DRIVE\n"

SIZE=`fdisk -l $DRIVE | grep "Disk $DRIVE" | cut -d' ' -f5`

echo DISK SIZE – $SIZE bytes

if [ "$SIZE" -lt 1800000000 ]; then
    echo "Require an SD card of at least 2GB"
    exit 1
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

# Default to 2 partitions
# Sectors are 512 bytes
# 0-127: 64KB, no partition, MBR then empty
# 128-131199: 64 MB, FAT partition, MLO, u-boot
# 131200-end: 2GB+, linux partition, kernel and root filesystem

echo -e "\n=== Creating 2 partitions ===\n"
{
echo 128,131072,0x0C,*
echo ,+,0x83,-
} | sfdisk $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

