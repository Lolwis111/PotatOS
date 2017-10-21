; VERY BASIC TEST FOR 'TrimLeft'

%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "strings.asm"
%include "language.asm"

str1 db "            STRING 1", 0x00
str2 db "  STRING 2", 0x00
str3 db 0x0A, 0x0D, 0x0A, 0x0D, 0x0A, 0x0D, "STRING 3", 0x00
str4 db "STRING 4", 0x00

start:
    
    print NEWLINE
    
    mov si, str1
    call TrimLeft
    
    print si
    
    print NEWLINE
    
    mov si, str2
    call TrimLeft
    
    print si
    
    print NEWLINE
    
    mov si, str3
    call TrimLeft
    
    print si
    
    print NEWLINE
    
    mov si, str4
    call TrimLeft
    
    print si
    
    print NEWLINE
    
    EXIT EXIT_SUCCESS
