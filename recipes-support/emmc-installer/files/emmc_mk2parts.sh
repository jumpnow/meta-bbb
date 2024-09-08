#!/bin/bash

dev="${1:-mmcblk1}"

if [ ! -b /dev/${dev} ]; then
    echo "Block device not found: /dev/${dev}"
    exit 1
fi

mount | grep '^/' | grep -q ${dev}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${dev} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep ${1}
    exit 1
fi

echo "Working on /dev/${dev}"

echo "Zeroing the MBR"
dd if=/dev/zero of=/dev/${dev} bs=1024 count=1024

# Default to 2 partitions
# Sectors are 512 bytes
# 0-127: 64KB, no partition, MBR then empty
# 128-131199: 64 MB, FAT partition, MLO, u-boot, boot.scr
# 131200-end: 2GB+, linux partition, kernel, dtbs and root filesystem

echo "Creating 2 partitions"
{
echo 128,131072,0x0C,*
echo ,+,0x83,-
} | sfdisk /dev/${dev}

sleep 1

echo "Done"
