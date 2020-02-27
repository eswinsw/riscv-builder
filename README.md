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

1. Boot Linux
    `riscv-builder$   make run`
    * Boot Linux in CLI mode
    * Boot sequence are OPENSBI + Linux
    * Login as the `root` user. (Password: `root`)
    * Use CTRL-A X to quit QEMU 

1. Ssh into Linux
    * User `root` is allowed ssh from host into the RISC-V server. (Password: `riscv`)
    * Host port 2222 is mapped into guest port 22 (`ssh root@localhost -p 2222`)

## Limitation
    * Source code updates are not properly supported

## TODO
    * Linux GUI support
