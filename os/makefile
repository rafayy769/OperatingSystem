BUILD_DIR=../build
OS=$(BUILD_DIR)/os/kernel
OS_DIR=$(BUILD_DIR)/os

CC=i386-elf-gcc
LD=i386-elf-ld

CFLAGS+=-ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3 -fno-pic

OS_SRCS := $(wildcard *.c)
OS_OBJS := $(patsubst %.c, $(OS_DIR)/%.o, $(OS_SRCS))

all: $(OS)

$(OS_DIR)/%.o: %.c
	mkdir $(OS_DIR) -p
	$(CC) $(CFLAGS) -c $< -o $@

$(OS): $(OS_OBJS)
	$(LD) -m elf_i386 -nmagic -T kernel.lds $(OS_OBJS) -o $@

clean:
	rm -f $(OS_OBJS)
	rm -f $(OS)