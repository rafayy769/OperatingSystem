;******************************************
; bootloader.asm
; A Simple Bootloader
;******************************************

bits 16
start: jmp boot

; include print_string code for printing strings
%include "../common/print_string.asm"

boot:
    cli ; no interrupts
    cld ; all that we need to init

    ; set the stack to 0x9000, far away from our bootloader
    mov     bp, 0x9000 
    mov     sp, bp

    ; Print Hello
    mov     bx, HELLO_MSG           ; load message address into bx
    call    print_string            ; print message
    call    print_newline

    ; load the kernel from the harddisk
    call    load_kernel
    ; switch to the protected (32 bit) mode.
    call    switch_to_pm
    ; stay in a loop if we return from switch_to_pm
    jmp     $

%include "./gdt.asm"

[bits 16]
load_kernel:
; ================= Read Kernel from the hard disk =================
    mov     bx, LOAD_KERNEL           ; load message address into bx
    call    print_string              ; print message
    call    print_newline

    ;; set the buffer for the kernel to be read from disk
    mov     ax, 0x50
    mov     es, ax
    ; extra segment should have the 0x50, or all memory accesses of es:reg would be like 0x500+reg

    ;; Set up the registers for the BIOS call to read the disk. ref : https://en.wikipedia.org/wiki/INT_13H
    xor     bx, bx  ; bx stores the address of the buffer. zerod, since es:bx would result in 0x500
    mov     al, 2   ; read 2 sectors
    mov     ch, 0   ; cylinder 0
    mov     cl, 2   ; sector to read (The second sector)
    mov     dh, 0   ; head number
    mov     dl, 0   ; drive number

    mov     ah, 0x02        ; read sectors from disk
    int     0x13            ; call the BIOS routine

[bits 16]
switch_to_pm:
    cli                             ; 1. disable interrupts
    lgdt    [gdt_descriptor]        ; 2. load the GDT descriptor
    mov     eax, cr0
    or      eax, 0x1                ; 3. set 32-bit mode bit in cr0
    mov     cr0, eax
    jmp     CODE_SEG:init_pm        ; 4. the long jump

[bits 32]
init_pm: ; we are now using 32-bit instructions
    mov ax, DATA_SEG                ; 5. update the segment registers
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000                ; 6. update the stack right at the top of the free space
    mov esp, ebp

    call BEGIN_PM                   ; 7. Call a well-known label with useful code

[bits 32]
BEGIN_PM:
; ================= Jump to the loaded kernel =================
    ; jump to the loaded kernel. The kernel is loaded at 0x500 because es is set to 0x50 and bx is set to 0. so (0x50 << 4) + 0 = 0x500. The loaded kernel is an elf file, with the entry point stored at offset 18h. So we jump to 0x500 + 18h = 0x518 to get the entry point and jump to it.
    jmp [0x500 + 0x18]    ; jump and execute the sector!

    hlt ; halt the CPU

; ================= data segment =================
; Messages to display
HELLO_MSG     db "Welcome to OS!", 0
LOAD_KERNEL   db "Loading kernel from harddisk!", 0
SWITCH_PM     db "Switching to protected mode!", 0
JUMP_KERNEL   db "Jumping to the kernel main!", 0

 ; We have to be 512 bytes. Clear the rest of the bytes with
times 510 - ($-$$) db 0

dw 0xAA55 ; Boot Signiture