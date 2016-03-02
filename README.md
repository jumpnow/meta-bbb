This layer depends on:

    URI: git://git.yoctoproject.org/poky.git
    branch: jethro 
    revision: HEAD
    commit: b1f23d1

    URI: git://git.openembedded.org/meta-openembedded
    branch: jethro 
    revision: HEAD
    commit: dc56349

    URI: https://github.com/meta-qt5/meta-qt5.git
    branch: fido
    revision: HEAD
    commit: 9bfcf79

    meta-bbb layer maintainer: Scott Ellis <scott@jumpnowtek.com>


Instructions for using this layer can be found on the [jumpnowtek site][jumpnowtek-bbb].

Major Software Versions

* Yocto 2.0.1 [jethro] branch
* Linux kernel 4.4.3 (linux-stable)
* U-Boot 2016.01

The qt5-image includes [Qt 5.5.1][qt] built for framebuffer use only.

Launch Qt5 apps with the following args 

    -platform linuxfb

There is a demo qt5 app installed - [tspress][tspress].

There is a *spidev* loopback test app installed - [spiloop][spiloop].

The default dtb with the example `uEnv.txt` enables HDMI

* bbb-hdmi.dtb

There is a dtb without HDMI/display support, freeing up some GPIO pins and UART5

* bbb-nohdmi.dtb

And there are dtbs for a couple of touchscreen capes

* bbb-4dcape70.dtb - for the 4D Systems LCD, 7-inch, 800x480 touchscreen 
* bbb-nh5cape.dtb - for the NewHaven Capacitive, 5-inch, 800x480 touchscreen 

All the dtbs include the following

* /dev/spidev1.0 - pins P9.28 cs0, P9.29 d0, P9.30 d1, P9.31 sclk - d0 is MOSI
* /dev/i2c1 - pins P9.17 scl and P9.18 sda
* /dev/i2c2 - pins P9.19 scl and P9.20 sda


To switch between these dtbs, take a look at `uEnv.txt` on the boot partition.

You can mount the boot partition like this

    root@beaglebone~# mount /dev/mmcblk0p1 /mnt

    root@beaglebone:~# ls -l /mnt
    total 466
    -rwxr-xr-x 1 root root  64408 Jul 24 09:00 MLO
    -rwxr-xr-x 1 root root 410860 Jul 24 09:00 u-boot.img
    -rwxr-xr-x 1 root root   1112 Jul 24 09:00 uEnv.txt

You can either modify `fdtfile=` or you can modify `touchscreen_dtb=` and also
add a *use_touchscreen* file to the `/boot` directory on the root filesystem.

    root@beaglebone:~# touch > /boot/use_touchscreen

Those are just some examples. You can easily devise your own strategy for
choosing which *dtb* to load at boot.

To use the nh5cape you will need the `ft5x06_ts` touchscreen driver

    root@beaglebone:~# echo ft5x06_ts >> /dev/modules

You can load it manually with *modprobe*

    root@beaglebone:~# modprobe ft5x06_ts

Or add it to `/etc/modules` to have it load every boot

    root@beaglebone:~# echo ft5x06_ts >> /etc/modules


[jumpnowtek-bbb]: http://www.jumpnowtek.com/yocto/BeagleBone-Systems-with-Yocto.html
[qt]: http://www.qt.io/
[tspress]: https://github.com/scottellis/tspress
[spiloop]: https://github.com/scottellis/spiloop

