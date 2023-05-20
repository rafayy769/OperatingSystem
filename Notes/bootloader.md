# Bootloader

Bootloader is a small program that runs before the main program. It is used to load the main program into memory and then run it. When the computer is turned on, the BIOS (Basic Input/Output System) is loaded into memory. The BIOS is a small program that is responsible for loading the operating system. The BIOS is stored in a ROM (Read-Only Memory) chip on the motherboard, performs hardware initialization and provides a set of generic subroutines to control input/output devices. The BIOS is responsible for loading the operating system into memory.

## x86 Boot Process
- Once the motherboard is powered up it initializes its own firmware - the chipset and other tidbits - and tries to get the CPU running.
- If all is well the CPU starts running. In a multi-processor or multi-core system one CPU is dynamically chosen to be the bootstrap processor (BSP) that runs all of the BIOS and kernel initialization code. The remaining processors, called application processors (AP) at this point, remain halted until later on when they are explicitly activated by the kernel.
- Intel x86, because of backwards compatibility, runs in 16 bit "real mode" at this point.
- With the help of offsets, the BIOS is able to address more than 1 MB of memory (which is the limitation of 16 bit addressing). An offset is applied to `eip` so that the first instruction is at `0xfffffff0`. This is the last 16 bytes of the 1 MB address space. This special address is called the *reset vector* and is a standard for intel CPUs.
- The motherboard ensures that the instruction at the reset vector is a jump to the memory location mapped to the BIOS entry point. The jump also clears the base offset, so now we would only be able to address 1 MB of memory. The BIOS resides at the very top of the 1 MB address space.
- The CPU then starts executing BIOS code, which initializes some of the hardware in the machine. It also performs a power-on self test (POST) to make sure that the machine is in a good state. If the POST fails, the BIOS will beep a few times and halt the machine.
- BIOS reads the first 512 byte-sector of the boot device (usually a hard disk) into memory at `0x7c00`. This is called the *Master Boot Record* (MBR) and contains the first stage of the bootloader. It is supposed to contain a tiny bootstrapping program, that loads the rest of the Operating System. It is also supposed to contain the partition table, which is a list of partitions on the disk, however, we can ignore that for now. All boot sector programs are supposed to end with a special two-byte sequence `0x55 0xaa` called the boot sector signature. This is to prevent the BIOS from booting from a disk that doesn't contain a boot sector.
- BIOS simply loads the contents of the MBR into memory location `0x7c00` and jumps to that location to start executing whatever code is in the MBR.
- At this point, the CPU starts executing our code. So, we can simply bootstrap such that we start reading subsequent sectors, or specific sectors in the disk which contain our kernel code. We can then load the kernel into memory and jump to it.

## Summary
The booting process then looks like as follows:

Power on -> goto reset vector -> jump to BIOS entry point -> BIOS loads MBR into memory -> jump to MBR -> MBR loads kernel into memory -> jump to kernel.

The memory layout at the boot time is as follows: (32 bit arch)
```
0 - 640KB      - Accessible RAM
640KB - 768KB  - Legacy video card memory
768KB - 896KB  - Expansion Area
896KB - 960KB  - Extended System BIOS
960KB - 1MB    - System BIOS (0xf0000 - 0xfffff)
1MB   - 4GB    - Unaddressable memory since we are in 16 bit real mode
Last 16bytes   - jmp to 0xf0000 (0xfffffff0 - 0xfffffff)
```

## Our Bootloader

A brief description of our bootloader is as follows:

```nasm
; Specify 16 bit addressing mode.

; Print any string to the screen using BIOS interrupts. In this case int 0x10 is used to print the string.

; Load the kernel into memory. We are using a kernel that is an elf executable. We load the entire sector #2 into memory at 0x500, and then jump to the entry point of the kernel.

; halt the CPU, in case anything goes wrong.
```

## References
- [OSDev](https://wiki.osdev.org/Main_Page)
- [How computers boot up](https://manybutfinite.com/post/how-computers-boot-up/)
- [OS from 0 to 1](https://github.com/tuhdo/os01)