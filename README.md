# Riscv-builder

This is a meta repository that hosts only the top level makefile and scripts
that builds risc-v based Linux kernel suitable for running on the QEMU emulator.

# Usage

1. Download and build
    `risv-builder$  make`
     * Target `install_qemu` download, build and install QEMU for the riscv64 target
     * Target `install_buildroot` download, build and install busybox based minimal rootfs image. Also builds tool chain and the Linux kernel
     * Target `all` expends to `install_qemu` and `install_buildroot`

1. Directories
     * Source code checked out by git are under the `riscv-builder/src` directory
     * Binaries are installed under the `riscv-builder/bin` directory

1. Boot buildroot Linux
    `riscv-builder$   make run-br`
    * Boot Linux in CLI mode
    * Boot sequence are OPENSBI + Linux
    * Login as the `root` user. (Password: `riscv`)
    * Use CTRL-A X to quit QEMU 

1. Ssh into buildroot Linux
    * User `root` is allowed ssh from host into the RISC-V server. (Password: `riscv`)
    * Host port 2222 is mapped into guest port 22 (`ssh root@localhost -p 2222`)

1. Run Fedora Linux
    `riscv-builder$ make run-fedora`
    * Using fedora images 2020/01/08 release.
    * Download a large Fedora rootfs the first time this command runs.
    * CLI mode only

1. Run Fedora Linux GUI
    `riscv-builder$ make run-fedora-gui`
    * Similar to make run-fedora, expect running qemu with the virtio-gpu device and friends
    * Use `dnf install xclock twm xterm` to pull down X server packages
    * `startx` starts screen in graphics mode.

1. Run Debian Linux 
    `riscv-builder$ make run-debian`
    * Using Debian image built by Carlos Eduardo for experimenting with docker
    * https://medium.com/@carlosedp/docker-containers-on-risc-v-architecture-5bc45725624b
    * apt-get install works out of box. Should be able to install most of the packages
    * Docker installs and runs fine. Following the instructions from Carlos Eduardo
    * Docker pull and execute image works
    * The instruction for installing golang package is out of date. Golang 1.14 has released with experimental support for RISC-V
    * Installing golang 1.14 per instruction works. It can natively compile go source code. Example hello world program runs fine.
      
1. Run Yocto Linux 
    * `riscv-builder$ cd yocto; make init; make build-riscv-cli` to build the image
    * `riscv-builder$ make run-yocto` to run yocto Linux in CLI mode

1. Run Yocto Linux GUI
    * `riscv-builder$ cd yocto; make init; make build-riscv-gui` to build the image
    * `riscv-builder$ make run-yocto-gui` to run yocto Linux in GUI mode with weston/wayland
