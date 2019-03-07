%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

message db "Hallo Welt!", 0xFF

start:
    mov dx, message
    mov ah, 0xE2
    int 0x21

    EXIT EXIT_SUCCESS
