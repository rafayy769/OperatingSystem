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

    ; Print Hello
    mov     bx, HELLO_MSG           ; load message address into bx
    call    print_string            ; print message

    ; The next section reads the kernel from next sector

    ;; set the buffer for the kernel to be read from disk
    mov ax, 50h
    mov es, ax
    xor bx, bx

    ;; Set up the registers for the BIOS call to read the disk. ref : https://en.wikipedia.org/wiki/INT_13H
    mov al, 2 ; read 2 sectors
    mov ch, 0 ; cylinder 0
    mov cl, 2 ; sector to read (The second sector)
    mov dh, 0 ; head number
    mov dl, 0 ; drive number

    mov ah, 0x02        ; read sectors from disk
    int 0x13            ; call the BIOS routine

    ; jump to the loaded kernel. The kernel is loaded at 0x500 because es is set to 0x50 and bx is set to 0. so (0x50 << 4) + 0 = 0x500. The loaded kernel is an elf file, with the entry point stored at offset 18h. So we jump to 0x500 + 18h = 0x518 to get the entry point and jump to it.
    jmp [500h + 18h]    ; jump and execute the sector!

    hlt ; halt the CPU

; data segment
HELLO_MSG:
    db      "Welcome to OS!", 0

 ; We have to be 512 bytes. Clear the rest of the bytes with
times 510 - ($-$$) db 0

dw 0xAA55 ; Boot Signiture