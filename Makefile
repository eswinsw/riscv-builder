
.PHONY: all
all:  install-qemu install-buildroot

###########################################
# QEMU
###########################################

src/qemu:
	(cd src; git clone https://github.com/qemu/qemu.git)

src/qemu/build: | src/qemu
	mkdir -p src/qemu/build
	(cd src/qemu/build; ../configure --target-list=riscv64-softmmu && make)
	
bin/qemu-system-riscv64: | src/qemu/build
	cp src/qemu/build/riscv64-softmmu/qemu-system-riscv64 $@

.PHONY: install-qemu
install-qemu: bin/qemu-system-riscv64
	

###########################################
# Buildroot
###########################################

BR-IMAGES = Image fw_jump.elf rootfs.ext2
build_targets = $(addprefix src/buildroot/output/images/,$(BR-IMAGES))

src/buildroot:
	(cd src; git clone https://github.com/buildroot/buildroot.git)

$(build_targets): | src/buildroot
	(cd src/buildroot; make qemu_riscv64_virt_defconfig && make)

.PHONY: install-buildroot
install-buildroot:  | $(build_targets)
	mkdir -p bin/buildroot
	cp $(build_targets) bin/buildroot
	

###########################################
# Boot up RISC-V virt machine in QEMU
###########################################
.PHONY: run
run:
	( \
	 cd bin; \
	 ./qemu-system-riscv64 -M virt -kernel ./buildroot/fw_jump.elf \
	 -device loader,file=./buildroot/Image,addr=0x80200000 \
	 -append 'rootwait root=/dev/vda ro' \
	 -drive file=buildroot/rootfs.ext2,format=raw,id=hd0 \
	 -device virtio-blk-device,drive=hd0 \
	 -netdev user,id=net0 \
	 -device virtio-net-device,netdev=net0 \
	 -nographic \
	)
