; ;AX = number to print in hex
; print_hex:
;     mov cx, 12              ;Shift counter, we start isolating the higher nibble (which starts at 12)
;     mov bx, hexDigits       ;Lookup tables for the digitals
;     mov dx, ax              ;We need a copy of the number and AX is used by the int10 service

; .extract:
;     mov si, dx              ;Make a copy of the original number so we don't lose it. Also we need it in SI for addressing purpose
;     shr si, cl              ;Isolate a nibble by bringing it at the lower position
;     and si, 0fh             ;Isolate the nibble by masking off any higher nibble
    
;     mov al, [bx + si]       ;Transform the nibble into a digit (that's why we needed it in SI)
;     mov ah, 0eh             ;You can also lift this out of the loop. It put it here for readability.
;     int 10h                 ;Print it
    
;     sub cx, 4               ;Next nibble is 4 bits apart
; jnc .extract              ;Keep looping until we go from 0000h to 0fffch. This will set the CF

;   ret

; hexDigits db "0123456789abcdef"
%include "print_string.asm"

print_hex:
    mov cx, 0
    
    loop:
        ; extract the nibble and store it in 
        mov dx, bx  ; create a copy
        and dx, 0xF ; extract the nibble
        mov al, HEX_CHAR[dx] ; convert the nibble to a character
        mov HEX_OUT[cx], al ; store the character in the output string
        shr bx, 4 ; shift the number to the right
        inc cx ; increment the counter
        cmp cx, 4 ; check if we have printed 4 characters
    jnz loop

    mov bx, HEX_OUT
    call print_string

    ret

HEX_OUT db "0000", 0
HEX_CHAR db "0123456789abcdef", 0