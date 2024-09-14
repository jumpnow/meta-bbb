#!/bin/bash

MACHINE=beaglebone
mnt=/mnt

if [ "x${1}" = "x" ]; then
    echo  "Usage: ${0} <block device> [ <image-type> [<hostname>] ]"
    exit 0
fi

mount | grep '^/' | grep -q ${1}

if [ $? -ne 1 ]; then
    echo "Looks like partitions on device /dev/${1} are mounted"
    echo "Not going to work on a device that is currently in use"
    mount | grep '^/' | grep ${1}
    exit 1
fi

if [ ! -d ${mnt} ]; then
    echo "Temporary mount point [${mnt}] not found"
    exit 1
fi

if [ "x${2}" = "x" ]; then
    image=console
else
    image=${2}
fi

if [ -z "$OETMP" ]; then
    # echo try to find it
    if [ -f ../../build/conf/local.conf ]; then
        OETMP=$(grep '^TMPDIR' ../../build/conf/local.conf | awk '{ print $3 }' | sed 's/"//g')

        if [ -z "$OETMP" ]; then
            OETMP=../../build/tmp
        fi
    fi
fi

echo "OETMP: $OETMP"

if [ ! -d ${OETMP}/deploy/images/${MACHINE} ]; then
    echo "Directory not found: ${OETMP}/deploy/images/${MACHINE}"
    exit 1
fi

src=${OETMP}/deploy/images/${MACHINE}

echo "IMAGE: $image"

if [ "x${3}" = "x" ]; then
    target_hostname=$MACHINE
else
    target_hostname=${3}
fi

echo "HOSTNAME: $target_hostname"

if [ -f "${src}/${image}-image-${MACHINE}.rootfs.tar.gz" ]; then
    rootfs=${src}/${image}-image-${MACHINE}.rootfs.tar.gz
elif [ -f "${src}/${image}-${MACHINE}.rootfs.tar.gz" ]; then
    rootfs=${src}/${image}-${MACHINE}.rootfs.tar.gz
elif [ -f "${src}/${image}" ]; then
    rootfs=${src}/${image}
else
    echo "Rootfs file not found. Tried"
    echo " ${src}/${image}-image-${MACHINE}.rootfs.tar.gz"
    echo " ${src}/${image}-${MACHINE}.rootfs.tar.gz"
    echo " ${src}/${image}"
    exit 1
fi

if [ -b "/dev/${1}2" ]; then
        p2=/dev/${1}2
elif [ -b "/dev/${1}p2" ]; then
        p2=/dev/${1}p2
else
        echo "Block device not found: /dev/${1}2 or /dev/${1}p2"
        exit 1
fi

echo "Formatting $p2 as ext4"
sudo mkfs.ext4 -Fq -L ROOT $p2

echo "Mounting $p2 at $mnt"
sudo mount $p2 $mnt

echo "Extracting $rootfs"
sudo tar -C $mnt -xzf $rootfs

echo "Generating a random-seed for urandom"
mkdir -p "${mnt}/var/lib/systemd"
sudo dd if=/dev/urandom of="${mnt}/var/lib/systemd/random-seed" bs=512 count=1
sudo chmod 600 "${mnt}/var/lib/systemd/random-seed"

echo "Writing $target_hostname to ${mnt}/etc/hostname"
export mnt
export target_hostname
sudo -E bash -c 'echo $target_hostname > ${mnt}/etc/hostname'

sudo sync

echo "Unmounting $p2"
sudo umount $p2

echo "Done"

