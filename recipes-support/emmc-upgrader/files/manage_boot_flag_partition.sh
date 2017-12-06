#!/bin/sh

MOUNT_DIR=/mnt/bootflags
FLAGS_PARTITION=/dev/mmcblk0p5

echo -e -n "\nChecking for an eMMC : "

ls /dev/mmc* | grep -q mmcblk0

if [ $? -eq 1 ]; then
	echo "FAIL"
        echo "There is no /dev/mmcblk0"
        exit 1
fi

echo "OK"

echo -e -n "Checking that there is no SD card : "

ls /dev/mmc* | grep -q mmcblk1

if [ $? -eq 0 ]; then
	echo "FAIL"
        echo "An SD card is present. Not going to continue." 
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


echo -e -n "Checking there is a /dev/mmcblk0p5 partition : "

fdisk -l /dev/mmcblk0 | grep -q mmcblk0p5

if [ $? -eq 1 ]; then
        echo "FAIL"
        echo "There is no /dev/mmcblk0p5 partition"
        exit 1
fi

echo "OK"

echo -e -n "Checking that ${FLAGS_PARTITION} is not in use : "

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

echo -e -n "Mounting ${FLAGS_PARTITION} read-only on ${MOUNT_DIR} : "

mount -t vfat -o ro ${FLAGS_PARTITION} ${MOUNT_DIR}

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Failed to mount ${FLAGS_PARTITION} on ${MOUNT_DIR} as type vfat"
	exit 1
fi

echo "OK"

echo -e -n "Checking flag files on ${FLAGS_PARTITION} : "

NEED_UPDATES=0

if [ "${CURRENT_ROOT}" = "/dev/mmcblk0p2" ]; then
	if [ ! -e ${MOUNT_DIR}/two ]; then
		NEED_UPDATES=1	
	fi

	if [ ! -e ${MOUNT_DIR}/two_ok ]; then
		NEED_UPDATES=1
	fi

	if [ -e ${MOUNT_DIR}/three ]; then
		NEED_UPDATES=1
	fi

	if [ -e ${MOUNT_DIR}/three_ok ]; then
		NEED_UPDATES=1
	fi
else
	if [ -e ${MOUNT_DIR}/two ]; then
		NEED_UPDATES=1	
	fi

	if [ -e ${MOUNT_DIR}/two_ok ]; then
		NEED_UPDATES=1
	fi

	if [ ! -e ${MOUNT_DIR}/three ]; then
		NEED_UPDATES=1
	fi

	if [ ! -e ${MOUNT_DIR}/three_ok ]; then
		NEED_UPDATES=1
	fi
fi

echo "OK"

echo -e -n "Unmounting ${FLAGS_PARTITION} : "

umount ${FLAGS_PARTITION} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Failed to unmount ${FLAGS_PARTITION}"
	exit 1
fi

echo "OK"

if [ ${NEED_UPDATES} -eq 0 ]; then
	# no updates required
	echo "Boot flags are up to date"
	exit 0
fi

echo -e -n "Mounting ${FLAGS_PARTITION} read-write on ${MOUNT_DIR} : "

mount -t vfat ${FLAGS_PARTITION} ${MOUNT_DIR} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Failed to mount ${FLAGS_PARTITION} on ${MOUNT_DIR} as type vfat"
	exit 1
fi

echo "OK"

echo -e -n "Updating flags partition : "

if [ "${CURRENT_ROOT}" = "/dev/mmcblk0p2" ]; then
	if [ ! -e ${MOUNT_DIR}/two ]; then
		touch ${MOUNT_DIR}/two
	fi

	if [ ! -e ${MOUNT_DIR}/two_ok ]; then
		touch ${MOUNT_DIR}/two_ok
	fi

	if [ -e ${MOUNT_DIR}/two_tried ]; then
		rm ${MOUNT_DIR}/two_tried
	fi

	rm -rf ${MOUNT_DIR}/three*
else
	if [ ! -e ${MOUNT_DIR}/three ]; then
		touch /mnt/three
	fi

	if [ ! -e ${MOUNT_DIR}/three_ok ]; then
		touch ${MOUNT_DIR}/three_ok
	fi

	if [ -e ${MOUNT_DIR}/three_tried ]; then
		rm ${MOUNT_DIR}/three_tried
	fi

	rm -rf ${MOUNT_DIR}/two*
fi

echo "OK"

echo -e -n "Unmounting ${FLAGS_PARTITION} : "

umount ${FLAGS_PARTITION} 

if [ $? -ne 0 ]; then
	echo "FAIL"
	echo "Failed to unmount ${FLAGS_PARTITION}"
	exit 1
fi

echo "OK"
