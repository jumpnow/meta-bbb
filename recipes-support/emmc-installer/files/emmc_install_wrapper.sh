#!/bin/sh

SUPPORT_SCRIPTS="emmc_copy_boot.sh emmc_copy_rootfs.sh"

if [ "x${1}" = "x" ]; then
	echo "No image name provided"
	exit 1
fi

IMAGE="${1}"

if [ "x${2}" = "x" ]; then
	HOSTNAME=`cat /etc/hostname`
else
	HOSTNAME="${2}"
fi

for script in $SUPPORT_SCRIPTS; do
	if [ ! -x /usr/bin/$script ]; then
		echo "Support script not found: /usr/bin/$script"
		exit 1
	fi
done

if [ -z "${PART_SCRIPT}" ]; then
	PART_SCRIPT=/usr/bin/emmc_mk2parts.sh
fi

if [ ! -x "${PART_SCRIPT}" ]; then
	echo "Partitioning script not found: ${PART_SCRIPT}"
	exit 1
fi

${PART_SCRIPT}

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_mk2parts.sh"
	exit 1
fi

/usr/bin/emmc_copy_boot.sh

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_copy_boot.sh"
	exit 1
fi

/usr/bin/emmc_copy_rootfs.sh ${IMAGE} ${HOSTNAME}

if [ $? -ne 0 ]; then
	echo "Script failed: emmc_copy_rootfs.sh ${IMAGE} ${HOSTNAME}"
	exit 1
fi

echo "Success!"
echo "Power off, remove SD card and power up" 

