%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"
%include "strings.asm"

str1 db "1234567890", 0x00
str2 db "abcdefghijklmnopqrstuvwxyz", 0x00
str3 db 0x0A, 0x0D, 0x0A, 0x0D, 0x0A, 0x0D, 0x00
str4 db "    Hello World    ", 0x00
str5 db 0x00
str6 db 0x00, 0x00, 0x00, 0x00
str7 db 0x00, "this is a string", 0x00

str8 times 2048 db 0x20
                db 0x00

msgOk db "No errors.", 0x0D, 0x0A, 0x00

start:
    print NEWLINE

    mov si, str1
    call StringLength2
    cmp cx, 10
    jne error

    mov si, str2
    call StringLength2
    cmp cx, 26
    jne error
    
    mov si, str3
    call StringLength2
    cmp cx, 6
    jne error
    
    mov si, str4
    call StringLength2
    cmp cx, 19
    jne error

    mov si, str5
    call StringLength2
    cmp cx, 0
    jne error

    mov si, str6
    call StringLength2
    cmp cx, 0
    jne error

    mov si, str7
    call StringLength2
    cmp cx, 0
    jne error
    
    mov si, str8
    call StringLength2
    cmp cx, 2048
    jne error

    print NEWLINE

    print msgOk

    EXIT EXIT_SUCCESS

error:
    EXIT EXIT_FAILURE
