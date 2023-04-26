; Prints a character on the screen using the bios utility
print_char:
    mov     ah, 0x0e
    int     0x10
    ret

; prints a string by looping through each character and calling print_char
print_string:
    pusha
    mov     cx, 0
    mov     al, [bx]
    cmp     al, 0
    je      print_string_end
; loop through each character
print_string_loop:
    call    print_char
    inc     bx
    inc     cx
    mov     al, [bx]
    cmp     al, 0
    jne     print_string_loop
; print a new line and return
print_string_end:
    ; mov     al, 0x0a
    ; call    print_char
    popa   

    ; insert a new line
    ; mov     ah, 0x0e
    ; mov     al, 0x0a
    ; int     0x10

    ret