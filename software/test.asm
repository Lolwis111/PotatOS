%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"
%include "strings.asm"

fname db "Hallo   txt"

start:
    
    mov si, fname
    call ReadjustFileName

    print di

    print NEWLINE

    EXIT EXIT_SUCCESS
