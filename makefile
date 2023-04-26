# # all:
# # 	nasm -f bin bootloader.asm -o bootloader
# # 	dd if=/dev/zero of=disk.img bs=512 count=2880
# # 	dd conv=notrunc if=bootloader of=disk.img bs=512 count=1 seek=0
# # 	qemu-system-i386 -machine q35 -fda disk.img

# BOOTLOADER=bootloader.o
# OS=kernel.o
# DISK_IMG=disk.img.o

# BOOTLOADER_SRCS := $(wildcard *.asm)
# BOOTLOADER_OBJS := $(patsubst %.asm, %.o, $(BOOTLOADER_SRCS))

# %.o: %.asm
# 	nasm -f bin $< -o $@

# bootdisk: $(BOOTLOADER_OBJS)
# 	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880
# 	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1 seek=0
# 	dd conv=notrunc if=$(OS) of=$(DISK_IMG) bs=512 count=1 seek=1

# run:
# 	qemu-system-i386 -machine q35 -fda $(DISK_IMG)

# hexdump:
# 	od -t x1 -A n $(DISK_IMG)
# 	od -t x1 -A n $(BOOTLOADER)

# clean:
# 	rm -f *.o
# 	rm -f *.bin
# 	rm -f *.img


BUILD_DIR=build
BOOTLOADER=$(BUILD_DIR)/bootloader/bootloader.o
OS=$(BUILD_DIR)/os/kernel.o
DISK_IMG=disk.img

all: bootdisk

.PHONY: bootdisk bootloader os

bootloader:
	make -C bootloader

os:
	make -C os

bootdisk: bootloader os
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=2880
	dd conv=notrunc if=$(BOOTLOADER) of=$(DISK_IMG) bs=512 count=1 seek=0
	dd conv=notrunc if=$(OS) of=$(DISK_IMG) bs=512 count=1 seek=1

qemu:
	qemu-system-i386 -machine q35 -fda $(DISK_IMG)

clean:
	make -C bootloader clean
	make -C os clean