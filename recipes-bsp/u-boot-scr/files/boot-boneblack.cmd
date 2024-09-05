setenv bootdir /boot
setenv bootdev 0
setenv bootpart 2
setenv console ttyO0,115200n8
setenv fdtaddr 0x88000000
setenv fdtfile am335x-boneblack.dtb
setenv loadaddr 0x82000000
setenv mmcroot /dev/mmcblk${bootdev}p${bootpart} rootwait rw
setenv setbootargs setenv bootargs console=${console} root=${mmcroot}
setenv loadfdt load mmc ${bootdev}:${bootpart} ${fdtaddr} ${bootdir}/${fdtfile}
setenv loadimage load mmc ${bootdev}:${bootpart} ${loadaddr} ${bootdir}/zImage
if run loadfdt; then
    if run loadimage; then
        run setbootargs
        bootz ${loadaddr} - ${fdtaddr}
    fi
fi
