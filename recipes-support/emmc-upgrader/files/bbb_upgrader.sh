#!/bin/sh

MOUNT_DIR=/mnt/upgrade
FLAGS_PARTITION=/dev/mmcblk0p5

if [ "x${1}" = "x" ]; then
	echo "Usage: ${0} <full-path-to-new-image-file>"
	exit 1
fi

if [ ! -f "${1}" ]; then
	echo "Image file not found: ${1}"
	exit 1
fi

echo -e -n "Checking for an eMMC : "

ls /dev/mmc* | grep -q mmcblk0

if [ $? -eq 1 ]; then
	echo "FAIL"
	echo "No /dev/mmcblk0. Can't handle this."
	exit 1
fi

echo "OK"

echo -e -n "Checking that there is no SD card : "

ls /dev/mmc* | grep -q mmcblk1

if [ $? -eq 0 ]; then
	echo "FAIL"
	echo "An SD card is present. Please remove and try again."
	exit 1
fi

echo "OK"

echo -e -n "Finding the current root partition : "

cat /proc/cmdline | grep -q mmcblk0p2

if [ $? -eq 0 ]; then
	CURRENT_ROOT=/dev/mmcblk0p2
else
	cat /proc/cmdline | grep -q mmcblk0p3

	if [ $? -eq 0 ]; then
		CURRENT_ROOT=/dev/mmcblk0p3
	else
		echo "FAIL"
		echo "Current root device is not mmcblk0p2 or mmcblk0p3"
		exit 1
	fi
fi

echo "${CURRENT_ROOT}"

if [ "${CURRENT_ROOT}" == "/dev/mmcblk0p2" ]; then
	NEW_ROOT=/dev/mmcblk0p3
else
	NEW_ROOT=/dev/mmcblk0p2
fi

echo "The new root will be : ${NEW_ROOT}" 


echo -e -n "Checking the new root partition size : "

SECTORS=`fdisk -l /dev/mmcblk0 | grep $NEW_ROOT | awk '{ print $4 }'`

# since it's more work to parse the Size units, use Sectors
# 2097152 sectors * 512 bytes/sector = 1GB
if [ ${SECTORS} -lt 2000000 ]; then
	echo "FAIL"
	echo "The new root partition [ ${NEW_ROOT} ] is too small, at least 1GB is required."
	echo ""
	echo "Here is the current partitioning of [ /dev/mmcblk0 ]"
	echo ""
	fdisk -l /dev/mmcblk0 
	exit 1
fi

echo "OK"

echo -e -n "Checking for a ${FLAGS_PARTITION} partition : "

fdisk -l /dev/mmcblk0 | grep -q ${FLAGS_PARTITION} 

if [ $? -eq 1 ]; then
	echo "FAIL"
	echo "There is no ${FLAGS_PARTITION} partition"
	exit 1
fi

echo "OK"

echo -e -n "Checking the ${FLAGS_PARTITION} flag partition size : "

SECTORS=`fdisk -l /dev/mmcblk0 | grep ${FLAGS_PARTITION} | awk '{ print $4 }'`

if [ $SECTORS -ne 131072 ]; then
	echo "FAIL"
	echo "The size of the flag partition ${FLAGS_PARTITION} is unexpected."
	echo ""
	echo "Here is the current partitioning of [ /dev/mmcblk0 ]"
	echo ""
	fdisk -l /dev/mmcblk0 
	exit 1
fi

echo "OK"

echo -e -n "Check that ${FLAGS_PARTITION} is not in use : "

mount | grep -q ${FLAGS_PARTITION}

if [ $? -eq 0 ]; then
	echo "FAIL"
	echo "${FLAGS_PARTITION} is already mounted"
	exit 1
fi

echo "OK"

echo -e -n "Checking if ${MOUNT_DIR} mount point exists : "

if [ ! -d ${MOUNT_DIR} ]; then
        echo "NO"

        echo -e -n "Attempting to create mount point ${MOUNT_DIR} :"

        mkdir ${MOUNT_DIR}

        if [ $? -eq 1 ]; then
                echo "FAIL"
                exit 1
        else
                echo "OK"
        fi
else
        echo "OK"

        echo -e -n "Checking that ${MOUNT_DIR} is not in use : "

        mount | grep -q ${MOUNT_DIR}

        if [ $? -eq 0 ]; then
                echo "FAIL"
                echo "${MOUNT_DIR} is in use by another mounted filesystem"
                exit 1
        fi

        echo "OK"
fi

echo -e -n "Formatting partition ${NEW_ROOT} as ext4 : "

mkfs.ext4 -q -F ${NEW_ROOT}

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error formatting the new root partition [ ${NEW_ROOT} ]"
	exit 1
fi

echo "OK"

echo -e -n "Mounting ${NEW_ROOT} on ${MOUNT_DIR} : "

mount ${NEW_ROOT} ${MOUNT_DIR} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error mounting partition ${NEW_ROOT} on ${MOUNT_DIR}"
	exit 1
fi

echo "OK"

echo -e -n "Extracting new root filesystem ${1} to ${MOUNT_DIR} : "

tar -C ${MOUNT_DIR} -xJf ${1}

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error extracting the root filesystem"
	umount ${NEW_ROOT}
	exit 1
fi

echo "OK"

echo -e -n "Copying config files from current system : "

cp /etc/fstab ${MOUNT_DIR}/etc/fstab

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error copying /etc/fstab to new system"
	umount ${NEW_ROOT}
	exit 1
fi

cp /etc/hostname ${MOUNT_DIR}/etc/hostname

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error copying /etc/hostname to new system"
	umount ${NEW_ROOT}
	exit 1
fi

mkdir ${MOUNT_DIR}/mnt/upgrade

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error creating /mnt/upgrade directory on new system"
	umount ${NEW_ROOT}
	exit 1
fi 

mkdir ${MOUNT_DIR}/bootflags

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error creating /mnt/bootflags directory on new system"
	umount ${NEW_ROOT}
	exit 1
fi 

echo "OK"

echo -e -n "Unmounting ${NEW_ROOT} : "

umount ${NEW_ROOT}

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Error unmounting ${NEW_ROOT}"
	exit 1
fi

echo "OK"

echo -e -n "Mounting the flag partition ${FLAGS_PARTITION} on ${MOUNT_DIR} : "

mount ${FLAGS_PARTITION} ${MOUNT_DIR} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Failed to mount ${FLAGS_PARTITION}";
	exit 1
fi

echo "OK"

if [ "${NEW_ROOT}" == "/dev/mmcblk0p3" ]; then
	echo -e -n "Creating file ${MOUNT_DIR}/three : "
	touch ${MOUNT_DIR}/three

	if [ $? -ne 0 ]; then
		echo "FAIL"
		echo "Failed to create flag file /three"
		exit 1
	fi

	echo "OK"

	if [ -f ${MOUNT_DIR}/three_tried ]; then
		echo -e -n "Deleting file ${MOUNT_DIR}/three_tried :"
		rm ${MOUNT_DIR}/three_tried

		if [ $? -ne 0 ]; then
			echo "FAIL"
			exit 1
		fi

		echo "OK"
	fi

	if [ -f ${MOUNT_DIR}/two ]; then
		echo -e -n "Deleting file ${MOUNT_DIR}/two : "
		rm ${MOUNT_DIR}/two
		
		if [ $? -ne 0 ]; then
			echo "FAIL"
			echo "Failed to delete old flag file ${MOUNT_DIR}/two"
			exit 1
		fi

		echo "OK"
	fi
else
	echo -e -n "Creating file ${MOUNT_DIR}/two : "
	touch ${MOUNT_DIR}/two

	if [ $? -ne 0 ]; then
		echo "FAIL"
		echo "Failed to create flag file /two"
		exit 1
	fi

	echo "OK"

	if [ -f ${MOUNT_DIR}/two_tried ]; then
		echo -e -n "Deleting file ${MOUNT_DIR}/two_tried :"
		rm ${MOUNT_DIR}/two_tried

		if [ $? -ne 0 ]; then
			echo "FAIL"
			exit 1
		fi

		echo "OK"
	fi

	if [ -f ${MOUNT_DIR}/three ]; then
		echo -e -n "Deleting file ${MOUNT_DIR}/three : "
		rm ${MOUNT_DIR}/three

		if [ $? -ne 0 ]; then
			echo "FAIL"
			echo "Failed to delete old flag file ${MOUNT_DIR}/three"
			exit 1
		fi

		echo "OK"
	fi
fi

echo -e -n "Unmounting ${FLAGS_PARTITION} from ${MOUNT_DIR} : "

umount ${FLAGS_PARTITION} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Fail to unmount ${FLAGS_PARTITION}"
	exit 1
fi

echo "OK"

echo -e "\nA new system was installed onto : ${NEW_ROOT}"
echo -e "\nReboot to use the new system."
