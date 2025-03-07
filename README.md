This layer depends on:

    URI: git://git.yoctoproject.org/poky.git
    branch: styhead

    URI: git://git.openembedded.org/meta-openembedded
    branch: styhead

    URI: git://git.yoctoproject.org/meta-security.git
    branch: styhead

    URI: https://code.qt.io/yocto/meta-qt6.git
    branch: 6.8


## How to Build and Flash eMMC

### 1. Build the Required Images
```sh
bitbake console-image
bitbake emmc-installer-image
```

### 2. Prepare the SD Card

#### Find the SD Card Device
```sh
cd bbb/meta-bbb/scripts
lsblk | grep sdd
```
Example Output:
```
sdd      8:48   1  29.7G  0 disk
├─sdd1   8:49   1    64M  0 part
└─sdd2   8:50   1  29.6G  0 part
```

#### Partition and Copy Files
```sh
sudo ./mk2parts.sh sdd
./copy_boot.sh sdd
./copy_rootfs.sh sdd emmc-installer
./copy_emmc_install.sh sdd console
```

### 3. Flash the eMMC

Boot the SD card and run the installer script:
```sh
root@beaglebone:~# emmc_installer.sh
```

Once booted, a service will automatically run to copy the console image to the eMMC. You can replace `console` with another image by passing it to the `copy_emmc_install.sh` script.

The process takes about **1-2 minutes**. The LEDs will enter 'cylon mode', cycling back and forth while flashing the eMMC. When the LEDs return to their normal state, the process is complete.

### 4. Monitor the Process
If you have a serial console connection, you can monitor the flashing process using:
```sh
root@beaglebone:~# journalctl -u emmc-installer -f
```
or check the job status with:
```sh
systemctl status emmc-installer
```

Latest commits:

    poky b2cf0d5cd0
    meta-openembedded c93994f1bb
    meta-security e2c44c8
    meta-qt6 5142300
