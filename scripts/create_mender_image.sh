#!/bin/bash

if [ -z ${TOPDIR} ]; then
    cd ../..
    TOPDIR=${PWD}
    cd ${OLDPWD}
fi

img_name=mender-test

if [ ! -d /media/card ]; then
    echo "Temporary mount point [/media/card] not found"
    exit 1
fi

local_conf=${TOPDIR}/build/conf/local.conf

if [ ! -f $local_conf ]; then
    echo "File not found: $local_conf"
    exit 1
fi

MACHINE=$(grep "^MACHINE" ${TOPDIR}/build/conf/local.conf | awk '{ print $3; }' | sed 's/"//g')

if [ -z "${MACHINE}" ]; then
    echo "MACHINE definition not found in local.conf"
    exit 1
fi

TMPDIR=$(grep "^TMPDIR" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')

if [ -z "${TMPDIR}" ]; then
    if [ -d "${TOPDIR}/build/tmp" ]; then
        # assume the default
        TMPDIR=${TOPDIR}/build/tmp
    else
        echo "TMPDIR definition not found in local.conf"
        exit 1
    fi
fi

dstdir=${TOPDIR}/upload

if [ ! -d ${dstdir} ]; then
    echo "${dstdir} not found, attempting to create"
    mkdir -p ${dstdir}

    if [ $? -ne 0 ]; then
        echo "Failed to create ${dstdir}"
        exit 1
    fi
fi


srcdir=${TMPDIR}/deploy/images/${MACHINE}
img_long="${img_name}-image-${MACHINE}"

if [ ! -f "${srcdir}/${img_long}.tar.xz" ]; then
    echo "File not found: ${srcdir}/${img_long}.tar.xz"
    exit 1
fi

sdimg=${MACHINE}-${img_name}.img

if [ -f "${dstdir}/${sdimg}" ]; then
    rm ${dstdir}/${sdimg}
fi

if [ -f "${dstdir}/${sdimg}.xz" ]; then
    rm -f ${dstdir}/${sdimg}.xz*
fi

echo "***** Calculating partition sizes *****"

image_rootfs_size=$(grep "^IMAGE_ROOTFS_SIZE" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')

if [ -z "${image_rootfs_size}" ]; then
    echo "Missing IMAGE_ROOTFS_SIZE in local.conf"
    exit 1
fi

mender_boot_part_size_mb=$(grep "^MENDER_BOOT_PART_SIZE_MB" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')

if [ -z "${mender_boot_part_size_mb}" ]; then
    echo "Missing MENDER_BOOT_PART_SIZE_MB in local.conf"
    exit 1
fi

mender_data_part_size_mb=$(grep "^MENDER_DATA_PART_SIZE_MB" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')

if [ -z "${mender_data_part_size_mb}" ]; then
    echo "Missing MENDER_DATA_PART_SIZE_MB in local.conf"
    exit 1
fi

boot_env_sectors=$((8 * 1024 * 2))
boot_part_sectors=$(($mender_boot_part_size_mb * 1024 * 2))
rootfs_part_sectors=$(($image_rootfs_size * 2))
data_part_sectors=$(($mender_data_part_size_mb * 1024 * 2))

# p1_start assumes 8 MB of unpartitioned space
p1_start=$boot_env_sectors
p2_start=$(($p1_start + $boot_part_sectors))
p3_start=$(($p2_start + $rootfs_part_sectors))
p4_start=$(($p3_start + $rootfs_part_sectors))

pad_sectors=$((64 * 1024 * 2))
total_sectors=$(($p4_start + $data_part_sectors + $pad_sectors))

echo "***** Creating the loop device *****"
loopdev=`losetup -f`

echo "***** Creating an empty SD image file *****"
#dd if=/dev/zero of=${dstdir}/${sdimg} bs=1G count=${cardsize}
dd if=/dev/zero of=${dstdir}/${sdimg} bs=512 count=${total_sectors}


echo "***** Partitioning *****"
{
echo "$p1_start,$boot_part_sectors,0x0C,*"
echo "$p2_start,$rootfs_part_sectors,0x83,-"
echo "$p3_start,$rootfs_part_sectors,0x83,-"
echo "$p4_start,$data_part_sectors,0x83,-"
} | sfdisk ${dstdir}/${sdimg}

sleep 1

echo "***** Attaching to the loop device *****"
sudo losetup -P ${loopdev} ${dstdir}/${sdimg}

# copy scripts need an environment variable
export OETMP=${TMPDIR}

echo "***** Copying the boot partition *****"
dev=${loopdev}p1
./copy_boot.sh ${dev}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Copying the rootfs *****"
dev=${loopdev}p2
./copy_rootfs.sh ${dev} ${img_name}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Copying the data partition *****"
dev=${loopdev}p4
./copy_mender_data.sh ${dev}

if [ $? -ne 0 ]; then
    sudo losetup -D
    exit 1
fi

echo "***** Detatching loop device *****"
sudo losetup -D

echo "Skipping compression"
exit 1

echo "***** Compressing the SD card image *****"
sudo xz -9 ${dstdir}/${sdimg}

echo "***** Creating an md5sum *****"
cd ${dstdir}
md5sum ${sdimg}.xz > ${sdimg}.xz.md5
cd ${OLDPWD}

echo "***** Done *****"
