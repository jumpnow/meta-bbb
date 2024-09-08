#!/bin/sh
#
# Script to install a system onto the BBB eMMC
#
# This script should normally be run as
#
#  emmc-copy-files.sh <partition> <srcdir>
#
# Assumes the following files are available in srcdir:
#
#   1) MLO
#   2) u-boot.img
#   3) boot.scr
#   4) rootfs.tar.gz
#
# The defaults would be like running this
#
#  emmc-copy-files.sh /dev/mmcblk1 /root/emmc
#

dev="${1:-mmcblk1}"
srcdir="${2-/root/emmc}"

mnt=/mnt

bootpart="/dev/${dev}p1"
rootpart="/dev/${dev}p2"

if [ ! -b "/dev/${dev}" ]; then
    echo "Block device not found: /dev/${dev}"
    exit 1
fi

if [ ! -b "${bootpart}" ]; then
    echo "Boot partition not found: ${bootpart}"
    exit 1
fi

if [ ! -b "${rootpart}" ]; then
    echo "Root partition not found: ${rootpart}"
    exit 1
fi

if [ ! -d "$srcdir" ]; then
    echo "Source directory not found: ${srcdir}"
    exit 1
fi

bootfiles=("MLO" "u-boot.img" "boot.scr")

for f in "${bootfiles[@]}"; do
    if [ ! -f ${srcdir}/${f} ]; then
        echo "File not found: ${srcdir}/${f}"
        exit 1
    fi
done

if [ ! -f ${srcdir}/rootfs.tar.gz ]; then
    echo "File not found: ${srcdir}/rootfs.tar.gz"
    exit 1
fi

echo "Formatting FAT partition ${bootpart}"
mkfs.vfat -F 32 ${bootpart} -n BOOT

echo "Mounting ${bootpart}"
mount ${bootpart} ${mnt}

for f in "${bootfiles[@]}"; do
    echo "Copying ${f}"
    cp ${srcdir}/${f} ${mnt}/${f}
done

echo "Unmounting ${bootpart}"
umount ${bootpart}

echo "Formatting ext4 partition ${rootpart}"
mkfs.ext4 -q -L ROOT ${rootpart}

echo "Mounting ${rootpart}"
mount ${rootpart} ${mnt}

echo "Extracting rootfs"
tar -C ${mnt} -xzf ${srcdir}/rootfs.tar.gz

echo "Copying hostname to new rootfs"
cp /etc/hostname ${mnt}/etc/hostname

sync

echo "Unmounting ${rootpart}"
umount ${rootpart}

echo "Done"
