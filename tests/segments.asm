%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "strings.asm"
%include "language.asm"

strSegment times 11 db 0x00

start:    
    PRINT NEWLINE
   
    xor eax, eax
    mov ax, es
    LTOHEX strSegment, eax
    PRINT strSegment

    PRINT NEWLINE
    
    xor eax, eax
    mov ax, ds
    LTOHEX strSegment, eax
    PRINT strSegment
    
    PRINT NEWLINE

    xor eax, eax
    mov ax, cs
    LTOHEX strSegment, eax
    PRINT strSegment
    
    PRINT NEWLINE

    xor eax, eax
    mov ax, fs
    LTOHEX strSegment, eax
    PRINT strSegment
    
    PRINT NEWLINE

    xor eax, eax
    mov ax, gs
    LTOHEX strSegment, eax
    PRINT strSegment
    
    PRINT NEWLINE

    xor eax, eax
    mov ax, ss
    LTOHEX strSegment, eax
    PRINT strSegment

    PRINT NEWLINE
    
    EXIT EXIT_SUCCESS
