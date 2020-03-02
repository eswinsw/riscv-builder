
.PHONY: all
all: download

INSTALL-DIR :=$(abspath ../bin/debian)
IMAGES := $(INSTALL-DIR)/fw_jump.elf
ROOTFS-IMAGE-URL := https://github.com/carlosedp/riscv-bringup/releases/download/v1.0/debian-riscv64-20181123.tar.bz2

$(INSTALL-DIR):
	mkdir =p $(INSTALL-DIR)


$(IMAGES):  | $(INSTALL-DIR)
	@mkdir -p dl
	(cd dl; \
	 wget -q -O debian-rootfs.tar.bz2 $(ROOTFS-IMAGE-URL); \
	 tar xf debian-rootfs.tar.bz2;  \
	 mv debian-riscv/* $(INSTALL-DIR); \
	)
	rm -rf dl

.PHONY: download
download:
	$(MAKE) $(IMAGES)

.PHONY: run
run:  | $(IMAGES)
	( \
	 cd ../bin; \
	 ./qemu-system-riscv64 -M virt -smp 6 -m 4G \
	 -kernel $(INSTALL-DIR)/fw_jump.elf \
	 -device loader,file=$(INSTALL-DIR)/Image-5.3.0-rc4,addr=0x80200000 \
	 -object rng-random,filename=/dev/urandom,id=rng0 \
	 -device virtio-rng-device,rng=rng0 \
	 -append "console=ttyS0 rw root=/dev/vda" \
	 -device virtio-blk-device,drive=hd0 \
	 -drive file=$(INSTALL-DIR)/Debian-Buster.img,format=qcow2,id=hd0 \
	 -device virtio-net-device,netdev=usernet \
	 -netdev user,id=usernet,hostfwd=tcp::22222-:22,hostfwd=tcp::2049-:2049,hostfwd=udp::2049-:2049,hostfwd=tcp::38188-:38188,hostfwd=udp::38188-:38188,hostfwd=tcp::8080-:8080,hostfwd=tcp::6443-:6443,hostfwd=tcp::8443-:8443,hostfwd=tcp::9090-:9090,hostfwd=tcp::9093-:9093 \
	 -nographic \
	)
