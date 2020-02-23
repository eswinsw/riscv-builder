# Riscv-builder

This is a meta repository that hosts only the top level makefile and scripts
that builds risc-v based Linux kernel suitable for running on the QEMU emulator.

# Usage

1. Download and build
    `risv-builder$  make`
     * Target `install_qemu` download, build and install qemu for the riscv64 target
     * Target `install_buildroot` download, build and install busybox based minimal rootfs image. Also builds toolchain and the Linux kernel
     * Target `all` expends to `install_qemu` and `install_buildroot`

2. Directories
     * Source code checked out by git are under the `risv-builder/src` directory
     * Binaries are installed under the `riscv-builder/bin` directory

3. Boot Linux
    `riscv-builder$   make run`
    * Boot Linux in CLI mode
    * Boot Seqneuse are OPENSBI + Linux
    * Use CTRL-A X to quit QEMU 


## Limitation
    * Source code updates are not properly supported

## TODO
    * Linux GUI support
