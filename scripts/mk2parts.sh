#!/bin/bash

function ver() {
        printf "%03d%03d%03d" $(echo "$1" | tr '.' ' ')
}

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


SIZE=`fdisk -l $DRIVE | grep "$DRIVE" | cut -d' ' -f5 | grep -o -E '[0-9]+`

echo DISK SIZE – $SIZE bytes

if [ "$SIZE" -lt 1800000000 ]; then
	echo "Require an SD card of at least 2GB"
	exit 1
fi

# new versions of sfdisk don't use rotating disk params
sfdisk_ver=`sfdisk --version | awk '{ print $4 }'`

if [ $(ver $sfdisk_ver) -lt $(ver 2.26.2) ]; then
        CYLINDERS=`echo $SIZE/255/63/512 | bc`
        echo "CYLINDERS – $CYLINDERS"
        SFDISK_CMD="sfdisk --force -D -uS -H255 -S63 -C ${CYLINDERS}"
else
        SFDISK_CMD="sfdisk"
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$DRIVE bs=1024 count=1024

# Minimum required 2 partitions
# Sectors are 512 bytes
# 0     : 64KB, no partition, MBR then empty
# 128   : 64 MB, FAT partition, bootloader 
# 131200: 2GB+, linux partition, root filesystem

echo -e "\n=== Creating 2 partitions ===\n"
{
echo 128,131072,0x0C,*
echo 131200,+,0x83,-
} | $SFDISK_CMD $DRIVE


sleep 1

echo -e "\n=== Done! ===\n"

