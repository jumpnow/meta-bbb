This layer depends on:

    URI: git://git.yoctoproject.org/poky.git
    branch: fido 
    revision: HEAD
    commit: 12cc076 

    URI: git://git.openembedded.org/meta-openembedded
    branch: fido 
    revision: HEAD
    commit: 5b0305d 

    URI: https://github.com/meta-qt5/meta-qt5.git
    branch: fido
    revision: HEAD
    commit: 3ccdc23

    meta-bbb layer maintainer: Scott Ellis <scott@jumpnowtek.com>


Major Software Versions

* Yocto 1.8.0 [fido] branch
* Linux kernel 4.0.4 (linux-stable)
* U-Boot 2015.04

The qt5-image includes Qt 5.4.1 built for framebuffer use only.

Launch Qt5 gui apps with `-platform linuxfb -plugin evdevkeyboard -plugin evdevmouse [-plugin evdevtouch]`

There are a couple of custom dtbs built and installed in `/boot` on the rootfs
if you use the meta-bbb/scripts/copy_*.sh scripts.

* bbb-hdmi.dtb
* bbb-4dcape70t.dtb

And the stock dtb

* am335x-boneblack.dtb

On the TODO list is support for the 4dcape70t buttons. Not hard.

Both of the custom dtbs include support for SPI1 and I2C1 and I2C2 on
the P9 header.

Working on the newhaven 5-inch touchscreen dtb.

There is also a sample uEnv.txt in meta-bbb/scripts. Edit and copy that
to the `<TMPDIR>/deploy/images/beaglebone/` before running `copy_rootfs.sh`
and it will get copied too `/boot`.

Read the notes in uEnv.txt on switching dtbs.

