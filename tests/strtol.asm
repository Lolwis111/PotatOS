%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"

str0 db "0", 0x00
str1 db "1", 0x00
str2 db "12", 0x00
str3 db "123", 0x00
str4 db "1234", 0x00
str5 db "12345", 0x00
str6 db "123456", 0x00
str7 db "1234567", 0x00
str8 db "12345678", 0x00
str9 db "123456789", 0x00
str10 db "1234567890", 0x00
str11 db "4294967297", 0x00

str12 db "  123", 0x00
str13 db "    1234", 0x00
str14 db 0x0A, 0x0D, 0x0A, 0x0D, "12345", 0x00
str15 db "          123456", 0x00
str16 db 0x0A, 0x0A, 0x0A, 0x0D, 0x0D, "    ", 0x0A, 0x0D, 0x0A, "1234567", 0x00

str17 db "a"
str18 db "abc"
str19 db "   abc"
str20 db "   1a2b3c"
str21 db 0x00

msgOk db "No errors."
newLine db "\r\n", 0x00

start:
    PRINT newLine

    STRTOL str0
    cmp ecx, 0
    jne err

    STRTOL str1
    cmp ecx, 1
    jne err
    
    STRTOL str2
    cmp ecx, 12
    jne err
    
    STRTOL str3
    cmp ecx, 123
    jne err
    
    STRTOL str4
    cmp ecx, 1234
    jne err
    
    STRTOL str5
    cmp ecx, 12345
    jne err
    
    STRTOL str6
    cmp ecx, 123456
    jne err
    
    STRTOL str7
    cmp ecx, 1234567
    jne err
    
    STRTOL str8
    cmp ecx, 12345678
    jne err
    
    STRTOL str9
    cmp ecx, 123456789
    jne err
    
    STRTOL str10
    cmp ecx, 1234567890
    jne err
    
    STRTOL str11
    cmp eax, 1
    jne err
    
    STRTOL str12
    cmp ecx, 123
    jne err
    
    STRTOL str13
    cmp ecx, 1234
    jne err
    
    STRTOL str14
    cmp ecx, 12345
    jne err
    
    STRTOL str15
    cmp ecx, 123456
    jne err
    
    STRTOL str16
    cmp ecx, 1234567
    jne err
    
    STRTOL str17
    cmp eax, -1
    jne err
    
    STRTOL str18
    cmp eax, -1
    jne err
    
    STRTOL str19
    cmp eax, -1
    jne err
    
    STRTOL str20
    cmp eax, -1
    jne err
    
    STRTOL str21
    cmp eax, -1
    jne err
    
    PRINT msgOk
    
    EXIT EXIT_SUCCESS
    
err:
    EXIT EXIT_FAILURE
