BUILD_DIR=../build
OS=$(BUILD_DIR)/os/kernel
OS_DIR=$(BUILD_DIR)/os

CFLAGS+=-ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3 -fno-pic

OS_SRCS := $(wildcard *.c)
OS_OBJS := $(patsubst %.c, $(OS_DIR)/%.o, $(OS_SRCS))

all: $(OS)

$(OS_DIR)/%.o: %.c
	gcc $(CFLAGS) -c $< -o $@

$(OS): $(OS_OBJS)
	ld -m elf_i386 -nmagic -T os.lds $(OS_OBJS) -o $@

clean:
	rm $(OS_OBJS)