#!/bin/sh
#
# Script to install a system onto the BBB eMMC.
# This script handles the root file system partition.
#
# Run it like this:
#
#  ./emmc_copy_rootfs.sh <image-file> [ <hostname> ]
#

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
    target_dev=/dev/mmcblk1p2
else
    target_dev=/dev/mmcblk0p2
fi

MACHINE=beaglebone

if [ -z "${SRCDIR}" ]; then
    SRCDIR=.
else
    if [ ! -d "${SRCDIR}" ]; then
            echo "Source directory not found: ${SRCDIR}"
            exit 1
    fi
fi

if [ "x${1}" = "x" ]; then
    echo -e "\nUsage: ${0} <image-name> [<hostname>]\n"
    exit 0
fi

if [ ! -d /media ]; then
    echo "Mount point /media does not exist"
    exit 1
fi

if [ ! -b $target_dev ]; then
    echo "Block device not found: $target_dev"
    exit 1
fi

if [ -f "${1}" ]; then
    FULLPATH="${1}"
elif [ -f "${SRCDIR}/${1}" ]; then
    FULLPATH="${SRCDIR}/${1}"
elif [ -f "${SRCDIR}/${1}-${MACHINE}.tar.xz" ]; then
    FULLPATH="${SRCDIR}/${1}-${MACHINE}.tar.xz"
elif [ -f "${SRCDIR}/${1}-image-${MACHINE}.tar.xz" ]; then
    FULLPATH="${SRCDIR}/${1}-image-${MACHINE}.tar.xz"
else
    echo "Rootfs image file not found."
    echo "Tried the following:"
    echo "${1}"
    echo "${SRCDIR}/${1}"
    echo "${SRCDIR}/${1}-${MACHINE}.tar.xz"
    echo "${SRCDIR}/${1}-image-${MACHINE}.tar.xz"
    exit 1
fi

if [ "x${2}" = "x" ]; then
    TARGET_HOSTNAME=$MACHINE
else
    TARGET_HOSTNAME=${2}
fi

echo -e "HOSTNAME: $TARGET_HOSTNAME\n"

echo "Formatting $target_dev as ext4"
mkfs.ext4 -q -F -L ROOT $target_dev

echo "Mounting $target_dev as /media"
mount $target_dev /media

echo "Extracting ${FULLPATH} to  /media"
EXTRACT_UNSAFE_SYMLINKS=1 tar -C /media -xJf ${FULLPATH}

echo "Generating a random-seed for urandom"
mkdir -p /media/var/lib/urandom
dd if=/dev/urandom of=/media/var/lib/urandom/random-seed bs=512 count=1
chmod 600 /media/var/lib/urandom/random-seed

echo "Writing ${TARGET_HOSTNAME} to /etc/hostname"
export TARGET_HOSTNAME
echo ${TARGET_HOSTNAME} > /media/etc/hostname

if [ -f ${SRCDIR}/interfaces ]; then
    echo "Writing interfaces to /media/etc/network/"
    cp ${SRCDIR}/interfaces /media/etc/network/interfaces
fi

if [ -f ${SRCDIR}/wpa_supplicant.conf ]; then
    echo "Writing wpa_supplicant.conf to /media/etc/"
    cp ${SRCDIR}/wpa_supplicant.conf /media/etc/wpa_supplicant.conf
fi

echo "Unmounting $target_dev"
umount $target_dev

echo "Done"
