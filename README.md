This layer depends on:

    URI: git://git.yoctoproject.org/poky.git
    branch: fido 
    revision: HEAD
    commit: eb4a134

    URI: git://git.openembedded.org/meta-openembedded
    branch: fido 
    revision: HEAD
    commit: 5b0305d

    URI: https://github.com/meta-qt5/meta-qt5.git
    branch: fido
    revision: HEAD
    commit: fc02638 

    meta-bbb layer maintainer: Scott Ellis <scott@jumpnowtek.com>


Instructions for using this layer can be found on the [jumpnowtek site][jumpnowtek-bbb].

Major Software Versions

* Yocto 1.8.0 [fido] branch
* Linux kernel 4.1.0-rc8 (linux-stable)
* U-Boot 2015.04

The qt5-image includes [Qt 5.4.2][qt] built for framebuffer use only.

Launch Qt5 apps with the following args 

    -platform linuxfb [-plugin evdevkeyboard] [-plugin evdevmouse] [-plugin evdevtouch]

There is a demo qt5 app installed - [tspress][tspress].

There is a *spidev* loopback test app installed - [spiloop][spiloop].

The default dtb enables HDMI

* bbb-hdmi.dtb

There are dtbs for a couple of touchscreen capes installed in `/boot`

* bbb-4dcape70.dtb - for the 4D Systems LCD, 7-inch, 800x480 touchscreen 
* bbb-nh5cape.dtb - for the NewHaven Capacitive, 5-inch, 800x480 touchscreen 

All dtbs add the following

* /dev/spidev1.0 - pins P9.28 cs0, P9.29 d0, P9.30 d1, P9.31 sclk - d0 is MOSI
* /dev/i2c1 - pins P9.17 scl and P9.18 sda, 100 kHz
* /dev/i2c2 - pins P9.19 scl and P9.20 sda, 400 kHz


To switch between these dtbs, take a look at `/boot/uEnv.txt`.

You can modify either `fdtfile=` or `touchscreen_dtb=` also adding a *use_touchscreen*
file to the `/boot` directory.

    touch > /boot/use_touchscreen


To use the nh5cape you also need to add the touchscreen driver to /etc/modules

    echo ft5x06_ts >> /dev/modules


[jumpnowtek-bbb]: http://www.jumpnowtek.com/yocto/BeagleBone-Systems-with-Yocto.html
[qt]: http://www.qt.io/
[tspress]: https://github.com/scottellis/tspress
[spiloop]: https://github.com/scottellis/spiloop

