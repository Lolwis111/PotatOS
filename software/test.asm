%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

start:
    mov ah, 0xAC
    int 0x21

    cmp al, 0x00
    je start

    mov ah, 0x10
    mov dl, 0x07
    mov dh, al
    int 0x21

    jmp start
