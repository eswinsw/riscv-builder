
.PHONY: all
all: download

INSTALL-DIR :=$(abspath ../bin/fedora)
IMAGES := $(INSTALL-DIR)/fedora.rootfs $(INSTALL-DIR)/fw_payload-uboot-qemu-virt-smode.elf
UBOOT-IMAGE := https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/Fedora-Developer-Rawhide-20200108.n.0-fw_payload-uboot-qemu-virt-smode.elf
ROOTFS-IMAGE := https://dl.fedoraproject.org/pub/alt/risc-v/repo/virt-builder-images/images/Fedora-Developer-Rawhide-20200108.n.0-sda.raw.xz

$(INSTALL-DIR):
	mkdir =p $(INSTALL-DIR)


$(INSTALL-DIR)/fedora.rootfs:  | $(INSTALL-DIR)
	@mkdir -p dl
	(cd dl; wget -q $(ROOTFS-IMAGE); unxz *.xz ; mv *.raw $@ )
	@rm -rf dl


$(INSTALL-DIR)/fw_payload-uboot-qemu-virt-smode.elf: | $(INSTALL-DIR)
	wget -qO  $@  $(UBOOT-IMAGE)

.PHONY: download
download:
	$(MAKE) $(IMAGES)

.PHONY: run
run:  | $(IMAGES)
	( \
	 cd ../bin; \
	 ./qemu-system-riscv64 -M virt  -smp 2 -m 1G \
	 -kernel $(INSTALL-DIR)/fw_payload-uboot-qemu-virt-smode.elf \
	 -object rng-random,filename=/dev/urandom,id=rng0 \
	 -device virtio-rng-device,rng=rng0 \
	 -device virtio-blk-device,drive=hd0 \
	 -drive file=$(INSTALL-DIR)/fedora.rootfs,format=raw,id=hd0 \
	 -device virtio-net-device,netdev=usernet \
	 -netdev user,id=usernet,id=net0,hostfwd=tcp::2222-:22 \
	 -nographic \
	)

.PHONY: run-gui
run-gui:  | $(IMAGES)
	( \
	 cd ../bin; \
	 ./qemu-system-riscv64 -M virt  -smp 2 -m 1G \
	 -kernel $(INSTALL-DIR)/fw_payload-uboot-qemu-virt-smode.elf \
	 -object rng-random,filename=/dev/urandom,id=rng0 \
	 -device virtio-rng-device,rng=rng0 \
	 -device virtio-blk-device,drive=hd0 \
	 -drive file=$(INSTALL-DIR)/fedora.rootfs,format=raw,id=hd0 \
	 -device virtio-net-device,netdev=usernet \
	 -device virtio-gpu-pci,xres=680,yres=480 \
	 -device virtio-keyboard-pci \
	 -device virtio-mouse-pci \
	 -device virtio-tablet-pci \
	 -netdev user,id=usernet,id=net0,hostfwd=tcp::2222-:22 \
	 -display gtk \
	)

