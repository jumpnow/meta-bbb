#!/bin/bash

IMG=mender-test

if [ -z ${TOPDIR} ]; then
    cd ../..
    TOPDIR=${PWD}
    cd ${OLDPWD}
fi

if [ ! -d ${TOPDIR}/build ]; then
    echo "Build directory not found: ${TOPDIR}/build"
    exit 1
fi

local_conf=${TOPDIR}/build/conf/local.conf

if [ ! -f "${local_conf}" ]; then
    echo "File not found: $local_conf"
    exit 1
fi

if [ ! -d ${TOPDIR}/mender-keys ]; then
    echo "mender-keys directory not found: ${TOPDIR}/mender-keys"
    exit 1
fi

TMPDIR=$(grep "^TMPDIR" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')
NAME=$(grep "^MENDER_ARTIFACT_NAME" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')
MACHINE=$(grep "^MACHINE" ${local_conf} | awk '{ print $3; }' | sed 's/"//g')

UPLOAD_DIR=${TOPDIR}/upload

SRC="${TMPDIR}/deploy/images/${MACHINE}/${IMG}-image-${MACHINE}.ext4"
DST="${UPLOAD_DIR}/${NAME}-signed.mender"

PRIVATE_KEY="${TOPDIR}/mender-keys/private.key"
PUBLIC_KEY="${TOPDIR}/mender-keys/public.key"

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
echo "TMPDIR: $TMPDIR"
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
    echo "mender-artifact read result: $?"
else
    echo "Failed to create signed artifact"
fi
