#!/bin/bash

dev="${1:-mmcblk1}"
srcdir="${2:-/home/root/emmc}"

partition_script="/usr/bin/emmc_mk2parts.sh"
copy_script="/usr/bin/emmc_copy_files.sh"
cylon_script="/usr/bin/cylon.sh"

if [ ! -b /dev/${dev} ]; then
    echo "Block device not found: /dev/${dev}"
    exit 1
fi

if [ ! -d "${srcdir}" ]; then
    echo "Source directory not found: ${srcdir}"
    exit 1
fi

scripts=("${partition_script}" "${copy_script}" "${cylon_script}")

for script in "${scripts[@]}"; do
    if [ ! -x "${script}" ]; then
        echo "Support script not found: ${script}"
        exit 1
    fi
done

echo "Starting ${cylon_script}"
${cylon_script} &

trap cleanup SIGHUB SIGINT SIGQUIT SIGABRT SIGTERM

cleanup()
{
    killall cylon.sh
}

echo "Running partitioning script: ${partition_script}"

if ! ${partition_script} ${dev}; then
    echo "Script failed: ${partition_script}"
    exit 1
fi

if ! ${copy_script} ${dev} ${srcdir}; then
    echo "Script failed: ${copy_script}"
    exit 1
fi

killall cylon.sh
