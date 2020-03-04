
# Use google's repo tool to set up and checkout tree
.PHONY: init
init:
	repo init -u git://github.com/riscv/meta-riscv  -b master -m tools/manifests/riscv-yocto.xml
	repo sync
	repo start work --all

# download and build packages. This step takes a long time
.PHONY: build-riscv-cli
build-riscv-cli:
	(. ./meta-riscv/setup.sh; \
	 MACHINE=qemuriscv64 bitbake core-image-full-cmdline \
	)

.PHONY: build-riscv-gui
build-riscv-gui:
	(. ./meta-riscv/setup.sh; \
	 MACHINE=qemuriscv64 bitbake core-image-weston \
	)


.PHONY: shell
shell:
	(. ./meta-riscv/setup.sh; export MACHINE=qemuriscv64; \
	 bash \
	 )

# Run yocto in cli mode
.PHONY: run
run:
	(. ./meta-riscv/setup.sh; \
	 MACHINE=qemuriscv64 runqemu nographic \
	 )

# Run yocto GUI using weston/wayland
QEMU-BIN := $(abspath ../bin/qemu-system-riscv64)
.PHONY: run-gui
run-gui:  | $(IMAGES)
	( \
	 cd build/tmp-glibc/deploy/images/qemuriscv64; \
	 $(QEMU-BIN) -M virt  -smp 2 -m 1G \
	 -kernel fw_jump.elf \
	 -object rng-random,filename=/dev/urandom,id=rng0 \
	 -device virtio-rng-device,rng=rng0 \
	 -device virtio-blk-device,drive=hd0 \
	 -device loader,file=./Image,addr=0x80200000 \
	 -drive file=./core-image-weston-qemuriscv64-20200304083829.rootfs.ext4,format=raw,id=hd0 \
	 -device virtio-net-device,netdev=usernet \
	 -device virtio-gpu-pci,xres=1024,yres=768 \
	 -device virtio-keyboard-pci \
	 -device virtio-mouse-pci \
	 -device virtio-tablet-pci \
	 -netdev user,id=usernet,id=net0,hostfwd=tcp::2222-:22 \
	 -append 'rootwait root=/dev/vda rw earlycon=sbi' \
	 -display gtk \
	)

