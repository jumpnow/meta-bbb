#!/bin/sh

find_root_device()
{
    local part=""
    local rdev=`stat -c %04D /`

    for file in $(find /dev -type b 2>/dev/null); do
        local pdev=$(stat -c %02t%02T $file)

        if [ "${pdev}" = "${rdev}" ]; then
            part=${file}
            break
        fi
    done

    # strip off the pX from end
    echo ${part} | sed -r 's/.{2}$//'
}

root_dev=$(find_root_device)

if [ -z $root_dev} ]; then
    echo "Unable to determine root device"
    exit 1
fi

if [ ${root_dev} == "/dev/mmcblk0" ]; then
    target_dev=/dev/mmcblk1
else
    target_dev=/dev/mmcblk0
fi

mount | grep -q ${target_dev}

if [ $? -eq 0 ]; then
    echo "Found mounted eMMC partitions."
    mount | grep ${target_dev}
    echo "Aborting"
    exit 1
fi

SIZE=`fdisk -l $target_dev | grep "$target_dev" | cut -d' ' -f5 | grep -o -E '[0-9]+'`

echo EMMC SIZE : $SIZE bytes

if [ "$SIZE" -lt 3000000000 ]; then
    echo "Require an eMMC of at least 3GB"
    exit 1
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$target_dev bs=1024 count=1024

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
} | sfdisk --no-reread $target_dev

sleep 1

echo -e "\n=== Done! ===\n"

