#!/bin/bash

MACHINE=beaglebone
HOSTNAME=bbb
DSTDIR=~/bbb/upload
IMG=qt5

if [ ! -d /media/card ]; then
        echo "Temporary mount point [/media/card] not found"
        exit 1
fi

if [ "x${1}" = "x" ]; then
	CARDSIZE=2
else
	if [ "${1}" -eq 1 ]; then
		CARDSIZE=1
	elif [ "${1}" -eq 2 ]; then
		CARDSIZE=2
	elif [ "${1}" -eq 4 ]; then
		CARDSIZE=4
	else
		echo "Unsupported card size: ${1}"
		exit 1
	fi
fi

if [ -z "${OETMP}" ]; then
	echo "OETMP environment variable not set"
	exit 1
fi

SRCDIR=${OETMP}/deploy/images/${MACHINE}

if [ ! -f ${SRCDIR}/MLO-${MACHINE} ]; then
        echo -e "File not found: ${SRCDIR}/MLO-${MACHINE}\n"
        exit 1
fi

if [ ! -f ${SRCDIR}/u-boot-${MACHINE}.img ]; then
        echo -e "File not found: ${SRCDIR}/u-boot-${MACHINE}.img\n"
        exit 1
fi

if [ ! -f "${SRCDIR}/${IMG}-image-${MACHINE}.tar.xz" ]; then
	echo "File not found: ${SRCDIR}/${IMG}-image-${MACHINE}.tar.xz"
	exit 1
fi

if [ ! -f "${SRCDIR}/installer-image-${MACHINE}.tar.xz" ]; then
	echo "File not found: ${SRCDIR}/installer-image-${MACHINE}.tar.xz"
	exit 1
fi

if [ ! -f "./emmc-uEnv.txt" ]; then
	echo "File not found: ./emmc-uEnv.txt"
	exit 1
fi

SDIMG=bbb-${IMG}-installer-${CARDSIZE}gb.img

if [ -f "${DSTDIR}/${SDIMG}" ]; then
	rm ${DSTDIR}/${SDIMG}
fi

if [ -f "${DSTDIR}/${SDIMG}.xz" ]; then
	rm -f ${DSTDIR}/${SDIMG}.xz*
fi

echo -e "\n***** Creating the loop device *****"
LOOPDEV=`losetup -f`

echo -e "\n***** Creating an empty SD image file *****"
dd if=/dev/zero of=${DSTDIR}/${SDIMG} bs=${CARDSIZE}G count=1

echo -e "\n***** Partitioning the SD image file *****"
sudo fdisk ${DSTDIR}/${SDIMG} <<END
o
n
p
1

+32M
n
p
2


t
1
e
a
1
w
END

echo -e "\n***** Attaching to the loop device *****"
sudo losetup -P ${LOOPDEV} ${DSTDIR}/${SDIMG}

echo -e "\n***** Copying the boot partition *****"
DEV=${LOOPDEV}p1

if [ -b "${DEV}" ]; then
	echo "Formatting FAT partition on ${DEV}"
	sudo mkfs.vfat -F 16 -n BOOT -I  ${DEV}

        echo "Mounting $DEV at /media/card"
        sudo mount ${DEV} /media/card

        echo "Copying MLO"
        sudo cp ${SRCDIR}/MLO-${MACHINE} /media/card/MLO

        echo "Copying u-boot"
        sudo cp ${SRCDIR}/u-boot-${MACHINE}.img /media/card/u-boot.img

        if [ -f ${SRCDIR}/uEnv.txt ]; then
                echo "Copying ${SRCDIR}/uEnv.txt to /media/card"
                sudo cp ${SRCDIR}/uEnv.txt /media/card
        elif [ -f ./uEnv.txt ]; then
                echo "Copying ./uEnv.txt to /media/card"
                sudo cp ./uEnv.txt /media/card
        fi

        echo "Unmounting ${DEV}"
        sudo umount ${DEV}
else
	echo "Block device not found: ${DEV}"
	sudo losetup -D
	exit
fi

echo -e "\n***** Copying the rootfs *****"
DEV=${LOOPDEV}p2

if [ -b "${DEV}" ]; then
        echo "Formatting $DEV as ext4"
        sudo mkfs.ext4 -F -q -L ROOT $DEV

        echo "Mounting $DEV at /media/card"
        sudo mount $DEV /media/card

        echo "Extracting installer-image-${MACHINE}.tar.xz to /media/card"
        sudo tar -C /media/card -xJf ${SRCDIR}/installer-image-${MACHINE}.tar.xz

        echo "Writing ${TARGET_HOSTNAME} to /etc/hostname"
        export TARGET_HOSTNAME=${HOSTNAME}
        sudo -E bash -c 'echo ${TARGET_HOSTNAME} > /media/card/etc/hostname'

        if [ -f ${SRCDIR}/interfaces ]; then
                echo "Writing interfaces to /media/card/etc/network/"
                sudo cp ${SRCDIR}/interfaces /media/card/etc/network/interfaces
        fi

        if [ -f ${SRCDIR}/wpa_supplicant.conf ]; then
                echo "Writing wpa_supplicant.conf to /media/card/etc/"
                sudo cp ${SRCDIR}/wpa_supplicant.conf /media/card/etc/wpa_supplicant.conf
        fi

	echo "Copying eMMC image files"
	sudo mkdir /media/card/home/root/emmc
	sudo cp ${SRCDIR}/MLO-${MACHINE} /media/card/home/root/emmc
	sudo cp ${SRCDIR}/u-boot-${MACHINE}.img /media/card/home/root/emmc
	sudo cp ${SRCDIR}/${IMG}-image-${MACHINE}.tar.xz /media/card/home/root/emmc
	sudo cp ./emmc-uEnv.txt /media/card/home/root/emmc

        echo "Unmounting $DEV"
        sudo umount $DEV
else
	echo "Block device not found: ${DEV}"
	sudo losetup -D
	exit
fi

echo -e "\n***** Detatching loop device *****"
sudo losetup -D

echo -e "\n***** Compressing the SD card image *****"
sudo xz -9 ${DSTDIR}/${SDIMG}

echo -e "\n***** Creating an md5sum *****"
cd ${DSTDIR}
md5sum ${SDIMG}.xz > ${SDIMG}.xz.md5
cd ${OLDPWD}

echo -e "\n***** Done *****\n"
