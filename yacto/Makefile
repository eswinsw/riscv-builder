
# Use google's repo tool to set up and checkout tree
.PHONY: init
init:
	repo init -u git://github.com/riscv/meta-riscv  -b master -m tools/manifests/riscv-yocto.xml
	repo sync
	repo start work --all

# download and build packages. This step takes a long time
.PHONY: build-qemu
build-qemu:
	(. ./meta-riscv/setup.sh; \
	 MACHINE=qemuriscv64 bitbake core-image-full-cmdline \
	)

# Run yacto in cli mode
.PHONY: run
run:
	(. ./meta-riscv/setup.sh; \
	 MACHINE=qemuriscv64 runqemu nographic \
	 )

