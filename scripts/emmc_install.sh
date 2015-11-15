#!/bin/bash

SUPPORT_SCRIPTS="emmc_mk2parts.sh emmc_mk4parts.sh emmc_copy_boot.sh emmc_copy_rootfs.sh"

if [ "x${1}" = "x" ]; then
	IMAGE=console
else
	IMAGE=${1}
fi

for file in $SUPPORT_SCRIPTS; do
	if [ ! -f ./$file ]; then
		echo "Support script not found: $file"
		exit 1
	fi
done

./emmc_mk2parts.sh mmcblk1

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_mk2parts.sh mmcblk1"
	exit 1
fi

./emmc_copy_boot.sh mmcblk1

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_copy_boot.sh mmcblk1"
	exit 1
fi

./emmc_copy_rootfs.sh mmcblk1 ${IMAGE}

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_copy_rootfs.sh mmcblk1 ${IMAGE}"
	exit 1
fi

echo "Success!"
echo "Power off, remove SD card and power up" 

