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
    * Using fedora images referenced in Fu Wei's talk on 2019 RISC-V Summit
    * Download a large Fedora rootfs the first time this command runs.
    * Cli mode only
    * Known issue: `dnf install` does not work. Can be fixed by editing /etc/yum.repos.d/fedora-rsicv.repo file to fix the repo location.

1. Run Fedora Linux GUI
    `riscv-builder$ make run-fedora-gui`
    * Similar to make run-fedora, expect running qemu with the virtio-gpu device and friends
    * Use `dnf install xclock fwm xterm` to pull down X server packages
    * `startx` starts screen in graphisc mode.
    * Known issues: Input devices (Keyboard and mouse) are not working correctly.

1. Run Debian Linux 
    `riscv-builder$ make run-debian`
    * Using Debian image built by Carlos Eduardo for experimenting with docker
    * https://medium.com/@carlosedp/docker-containers-on-risc-v-architecture-5bc45725624b

## Limitation
    * Source code updates are not properly supported

## TODO
    * Linux GUI support
