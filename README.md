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

Launch apps with `-platform linuxfb -plugin evdevkeyboard -plugin evdevmouse`

