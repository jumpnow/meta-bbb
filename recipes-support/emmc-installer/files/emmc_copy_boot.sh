#!/bin/sh
#
# Script to install a system onto the BBB eMMC
# This script handles the boot partition.
#
# This script should normally be run as
#
#  ./emmc_copy_boot.sh
#
# Assumes the following files are available in the local directory:
#
#   1) MLO-beaglebone
#   2) u-boot-beaglebone.img
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
    target_dev=/dev/mmcblk1p1
else
    target_dev=/dev/mmcblk0p1
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

if [ ! -b ${target_dev} ]; then
    echo "Block device not found: ${target_dev}"
    exit 1
fi

if [ ! -d /media ]; then
    echo "Mount point /media does not exist";
    exit 1
fi

if [ ! -f ${SRCDIR}/MLO-${MACHINE} ]; then
    echo -e "File not found: ${SRCDIR}/MLO-${MACHINE}\n"
    exit 1
fi

if [ ! -f ${SRCDIR}/u-boot-${MACHINE}.img ]; then
    echo -e "File not found: ${SRCDIR}/u-boot-${MACHINE}.img\n"
    exit 1
fi

if [ ! -f "${SRCDIR}/emmc-uEnv.txt" ]; then
    echo "File not found: ${SRCDIR}/emmc-uEnv.txt"
    exit 1
fi

echo "Formatting FAT partition on $target_dev"
mkfs.vfat -F 32 ${target_dev} -n BOOT

echo "Mounting $target_dev"
mount ${target_dev} /media

echo "Copying MLO"
cp ${SRCDIR}/MLO-${MACHINE} /media/MLO

echo "Copying u-boot"
cp ${SRCDIR}/u-boot-${MACHINE}.img /media/u-boot.img

echo "Copying emmc-uEnv.txt to uEnv.txt"
cp ${SRCDIR}/emmc-uEnv.txt /media/uEnv.txt

echo "Unmounting ${target_dev}"
umount ${target_dev}

echo "Done"
