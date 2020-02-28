
.PHONY: all
all:  install-qemu install-buildroot

# For building a particular rlease, please define the BR_TAG to a release tag
# By default, BR_TAG is left undefined, meaning we will checkout the
# buildroot tree from the tip of eswin branch.
# BR_TAG = ew-0.1  # Baseline, busybox only

###########################################
# QEMU
###########################################

src/qemu:
	(cd src; git clone --branch eswin --single-branch https://github.com/eswinsw/qemu.git)

src/qemu/build: | src/qemu
	mkdir -p src/qemu/build
	(cd src/qemu/build; \
	../configure --target-list=riscv64-softmmu --enable-vnc --enable-sdl; \
	make )
	
bin/qemu-system-riscv64: | src/qemu/build
	cp src/qemu/build/riscv64-softmmu/qemu-system-riscv64 $@

bin/pc-bios: | src/qemu/build
	mkdir -p bin/pc-bios
	cp -r src/qemu/build/pc-bios bin

.PHONY: install-qemu
install-qemu: bin/qemu-system-riscv64 bin/pc-bios
	

###########################################
# Buildroot
###########################################

BR-IMAGES = Image fw_jump.elf rootfs.ext2
build_targets = $(addprefix src/buildroot/output/images/,$(BR-IMAGES))

.PHONY: co-br-tag
ifneq ($(BR_TAG),)
co-br-tag:
	(cd src/buildroot; git checkout tags/$(BR_TAG) -b $(BR_TAG))
else
co-br-tag:
	@:
endif

BR-CONFIG:=$(abspath configs/qemu_riscv64_virt_dev)

src/buildroot:
	(cd src; git clone --single-branch --branch eswin  https://github.com/eswinsw/buildroot.git)
	@$(MAKE) co-br-tag

$(build_targets): | src/buildroot
	(cd src/buildroot; make defconfig BR2_DEFCONFIG=$(BR-CONFIG) && make)

.PHONY: install-buildroot
install-buildroot:  | $(build_targets)
	mkdir -p bin/buildroot
	cp $(build_targets) bin/buildroot


######################################################
# Boot up RISC-V virt machine in QEMU with buildroot
######################################################
.PHONY: run-br
run-br:
	( \
	 cd bin; \
	 ./qemu-system-riscv64 -M virt -kernel ./buildroot/fw_jump.elf \
	 -device loader,file=./buildroot/Image,addr=0x80200000 \
	 -append 'rootwait root=/dev/vda ro' \
	 -drive file=buildroot/rootfs.ext2,format=raw,id=hd0 \
	 -device virtio-blk-device,drive=hd0 \
	 -netdev user,id=net0,hostfwd=tcp::2222-:22 \
	 -device virtio-net-device,netdev=net0 \
	 -nographic \
	)

######################################################
# Boot up RISC-V virt machine in QEMU with Fedora OS
######################################################
.PHONY: run-fedora
run-fedora:
	$(MAKE) -C fedora
