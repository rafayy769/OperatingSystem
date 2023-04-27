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

    ; read the kernel from next sector
    mov ax, 50h
    
    ; set the buffer
    mov es, ax
    xor bx, bx

    mov al, 2 ; read 2 sector
    mov ch, 0 ; track 0
    mov cl, 2 ; sector to read (The second sector)
    mov dh, 0 ; head number
    mov dl, 0 ; drive number

    mov ah, 0x02        ; read sectors from disk
    int 0x13            ; call the BIOS routine
    jmp [500h + 18h]    ; jump and execute the sector!

    hlt ; halt the CPU

; data segment
HELLO_MSG:
    db      "Welcome to OS!", 0

 ; We have to be 512 bytes. Clear the rest of the bytes with
times 510 - ($-$$) db 0
dw 0xAA55 ; Boot Signiture