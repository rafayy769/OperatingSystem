BUILD_DIR=build
BOOTLOADER=$(BUILD_DIR)/bootloader/bootloader.o
OS=$(BUILD_DIR)/os/kernel
DISK_IMG=$(BUILD_DIR)/disk.img

all: bootdisk

.PHONY: bootdisk bootloader os

build:
	mkdir $(BUILD_DIR) -p

bootloader:
	make -C bootloader

os:
	make -C os

bootdisk: build bootloader os
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1 seek=0
	dd conv=notrunc if=$(OS) of=$(DISK_IMG) bs=512 count=$$(($(shell stat --printf="%s" $(OS))/512)) seek=1

qemu:
	qemu-system-i386 -machine q35 -fda $(DISK_IMG)

qemu-dbg:
	qemu-system-i386 -machine q35 -fda $(DISK_IMG) -gdb tcp::26000 -S

clean:
	make -C bootloader clean
	make -C os clean
	rm -f $(DISK_IMG)
	rm -rf $(BUILD_DIR)