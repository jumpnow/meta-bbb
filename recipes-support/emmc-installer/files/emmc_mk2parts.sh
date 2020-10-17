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

echo -e "\nWorking on $target_dev\n"

mount | grep -q $target_dev

if [ $? -eq 0 ]; then
	echo "Found mounted eMMC partitions"
	echo "Aborting"
	exit 1
fi

SIZE=`fdisk -l $target_dev | grep "$target_dev" | cut -d' ' -f5 | grep -o -E '[0-9]+'`

echo EMMC SIZE – $SIZE bytes

if [ "$SIZE" -lt 1800000000 ]; then
	echo "Require an eMMC of at least 2GB"
	exit 1
fi

echo -e "\nOkay, here we go ...\n"

echo -e "=== Zeroing the MBR ===\n"
dd if=/dev/zero of=$target_dev bs=1024 count=1024

# Minimum required 2 partitions
# Sectors are 512 bytes
# 0     : 64KB, no partition, MBR then empty
# 128   : 64MB, FAT partition, bootloader 
# 131200: 2GB+, linux partition, root filesystem

echo -e "\n=== Creating 2 partitions ===\n"
{
echo 128,131072,0x0C,*
echo ,,0x83,-
} | sfdisk $target_dev


sleep 1

echo -e "\n=== Done! ===\n"

