%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

start:
    mov ebx, 1000
    mov ah, 0x19
    int 0x21

    print NEWLINE

    EXIT EXIT_SUCCESS
