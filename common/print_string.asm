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
; ends and returns
print_string_end:
    popa

    ret

print_newline:
    pusha

    mov al, 0x0a        ; newline char
    call print_char
    mov al, 0x0d        ; carriage return
    call print_char

    popa
    ret