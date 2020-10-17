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

echo "Running partition script: ${PART_SCRIPT}"

${PART_SCRIPT}

if [ $? -ne 0 ]; then
    echo "Script failed: ${PART_SCRIPT}"
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

if [ ${PART_SCRIPT} == "/usr/bin/emmc_mk5parts.sh" ]; then
    echo "Formatting partition ${target_dev}p5 as FAT"
    mkfs.vfat -F 32 ${target_dev}p5 -n FLAG

    if [ $? -ne 0 ]; then
        echo "Failed formatting ${target_dev}p5"
        exit 1
    fi

    echo "Formatting partition ${target_dev}p6 as ext4"
    mkfs.ext4 -q -F ${target_dev}p6

    if [ $? -ne 0 ]; then
        echo "Failed formatting ${target_dev}p6"
        exit 1
    fi
fi

echo "Success!"
echo "Power off, remove SD card and power up"
