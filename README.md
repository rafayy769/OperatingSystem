# Operating System

This is the repository for my hobby operating system. It is written in C and Assembly. It is currently in development and is not ready for use. The project is mainly for learning purposes only, and I am making notes as I go along.

The operating system is targeted for the intel x86 architecture, and is currently being developed on a 64-bit machine. I am using the [NASM](https://www.nasm.us/) assembler and the [GCC](https://gcc.gnu.org/) compiler. My target is i386, and I am using [QEMU](https://www.qemu.org/) to test, and run the operating system.

## Building
My build system is the good ol' GNU Make. The prerequisites are:
- NASM
- QEMU
- GCC
- BINUTILS
- GNU Make

To build the operating system, simply run in the root directory:
```
make
```
This will build the OS, and the binaries are located in the build directory. To run the operating system, run:
```
make qemu
```
This will run the operating system in QEMU. To clean the build directory, run:
```
make clean
```

In order to help with debugging, GDB is configured to be used with QEMU. To launch QEMU with GDB, run:
```
make qemu-gdb
```
This will launch QEMU, and wait for GDB to connect. To connect GDB, run:
```
gdb
symbol-file build/os/kernel
```