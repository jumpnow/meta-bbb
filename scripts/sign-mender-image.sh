#!/bin/bash

MACHINE=beaglebone
IMG=mender-test

TOPDIR="${HOME}/bbb-mender/build"

if [ ! -d ${TOPDIR} ]; then
    echo "TOPDIR directory not found: ${TOPDIR}"
    exit 1
fi

OETMP=$(grep TMPDIR ${TOPDIR}/conf/local.conf | awk '{ print $3; }' | sed 's/"//g')
NAME=$(grep MENDER_ARTIFACT_NAME ${TOPDIR}/conf/local.conf | awk '{ print $3; }' | sed 's/"//g')
UPLOAD_DIR=${HOME}/bbb-mender/upload

SRC="${OETMP}/deploy/images/${MACHINE}/${IMG}-image-${MACHINE}.ext4"
DST="${UPLOAD_DIR}/${NAME}-signed.mender"

PRIVATE_KEY="${HOME}/bbb-mender/mender-keys/private.key"
PUBLIC_KEY="${HOME}/bbb-mender/mender-keys/public.key"

MENDER="/usr/local/bin/mender-artifact"


if [ ! -x ${MENDER} ]; then
    echo "mender-artifact utility not found"
    exit 1
fi

if [ ! -f ${SRC} ]; then
    echo "Source rootfs file not found: ${SRC}"
    exit 1
fi

if [ ! -d ${UPLOAD_DIR} ]; then
    echo "Creating upload directory: ${UPLOAD_DIR}"

    mkdir -p ${UPLOAD_DIR}

    if [ $? -ne 0 ]; then
        echo "Failed to create upload directory: ${UPLOAD_DIR}"
        exit 1
    fi
fi

if [ ! -f ${PRIVATE_KEY} ]; then
    echo "Private signing key not found: ${PRIVATE_KEY}"
    exit 1
fi

if [ ! -f ${PUBLIC_KEY} ]; then
    echo "Public key not found: ${PUBLIC_KEY}"
    exit 1
fi

if [ -f ${DST} ]; then
    echo "Removing existing artifact: ${DST}"
    rm ${DST}
fi

echo "Creating artifact using the following parameters"
echo "OETMP: $OETMP"
echo "Artifact name: ${NAME}"
echo "Private key: ${PRIVATE_KEY}"
echo "Public key: ${PUBLIC_KEY}"
echo "Source: ${SRC}"
echo ""
echo "Running mender-artifact to create signed artifact"
echo ""

${MENDER} write rootfs-image -t ${MACHINE} -n ${NAME} -u ${SRC} -k ${PRIVATE_KEY} -o ${DST} 

if [ $? -eq 0 ]; then
    echo "Wrote artifact to ${DST}"
    echo "Checking artifact"
    echo ""
    ${MENDER} read ${DST} -k ${PUBLIC_KEY} 
    echo ""
else
    echo "Failed to create signed artifact"
fi
