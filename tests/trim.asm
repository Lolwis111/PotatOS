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

str5 db "STRING 5            ", 0x00
str6 db "STRING 6  ", 0x00
str7 db "STRING 7", 0x0A, 0x0D, 0x0A, 0x0D, 0x0A, 0x0D, 0x00
str8 db "STRING 8", 0x00

spacer db "|", 0x00

start:
    
    PRINT NEWLINE
    
    mov si, str1
    call TrimLeft
    
    PRINT si
    
    PRINT NEWLINE
    
    mov si, str2
    call TrimLeft
    
    PRINT si
    
    PRINT NEWLINE
    
    mov si, str3
    call TrimLeft
    
    PRINT si
    
    PRINT NEWLINE
    
    mov si, str4
    call TrimLeft
    
    PRINT si
    
    PRINT NEWLINE
    
    mov si, str5
    call TrimRight
    
    PRINT si
    
    PRINT spacer
    
    PRINT NEWLINE
    
    mov si, str6
    call TrimRight
    
    PRINT si
    
    PRINT spacer
    
    PRINT NEWLINE
    
    mov si, str7
    call TrimRight
    
    PRINT si
    
    PRINT spacer
    
    PRINT NEWLINE
    
    mov si, str8
    call TrimRight
    
    PRINT si
    
    PRINT spacer
    
    PRINT NEWLINE
    
    EXIT EXIT_SUCCESS
