
all:  install-qemu

src/qemu:
	(cd src; git clone https://github.com/qemu/qemu.git)

src/qemu/build: | src/qemu
	echo here
	$(MAKE) build-qemu

.PHONY: build-qemu
build-qemu:
	mkdir -p src/qemu/build
	(cd src/qemu/build; ../configure --target-list=riscv64-softmmu && make)
	
bin/qemu-system-riscv64: | src/qemu/build
	cp src/qemu/build/riscv64-softmmu/qemu-system-riscv64 $@

.PHONY: install-qemu
install-qemu: bin/qemu-system-riscv64
	

.PHONY: clean
clean:
	echo "clean"



