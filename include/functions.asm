%ifndef _FUNCTIONS_ASM_
%define _FUNCTIONS_ASM_

%macro ALLOC 0
    mov ah, 0xF1
    int 0x21
%endmacro

%macro FREE 1
    mov ah, 0xF2
    mov bp, %1
    int 0x21
%endmacro

%macro PRINTCHAR 2
    mov dh, byte %1
    mov dl, byte %2
    mov ah, 0x10
    int 0x21
%endmacro

%macro PRINTCHAR 1
    PRINTCHAR %1, [SYSTEM_COLOR]
%endmacro

%macro PRINT 2
    mov dx, %1
    mov bl, byte %2
    mov ah, 0x01
    int 0x21
%endmacro

%macro PRINT 1
    PRINT %1, [SYSTEM_COLOR]
%endmacro

%macro READCHAR 0
    mov ah, 0xAC
    int 0x21
%endmacro

%macro READLINE 2
    mov dx, %1
    mov cx, %2
    mov ah, 0x04
    int 0x21
%endmacro

%macro EXIT 1
    mov bx, %1
    xor ax, ax
    int 0x21
%endmacro

%macro STRCMP 2
    mov di, %1
    mov si, %2
    mov ah, 0x02
    int 0x21
    test al, al
%endmacro

%macro LOADFILE 3
    mov dx, %1
    mov bx, %2
    mov bp, %3
    mov ah, 0x05
    int 0x21
%endmacro

%macro LOADFILE 2 ; load file to BP:BX
    LOADFILE %1, %2, 0x0000
%endmacro

%macro LOADFILEENTRY 3
    mov ah, 0x1B
    mov dx, %1
    mov bx, %2
    mov ebp, %3
    int 0x21
%endmacro

%macro LOADFILEENTRY 2
    LOADFILEENTRY %1, %2, 0
%endmacro

%macro LOADDIRECTORY 1
    mov dx, %1
    mov ah, 0x1A
    int 0x21
%endmacro

%macro LTOSTR 2 ; converts arg2 to string in arg1
    mov ecx, %2
    mov dx, %1
    mov ah, 0xAA
    int 0x21
%endmacro

%macro ITOSTR 2 ; converts arg2 to string in arg1
    movzx ecx, %2
    mov dx, %1
    mov ah, 0xAA
    int 0x21
%endmacro

%macro FTOSTR 2
    FTOSTR %1, %2, 3
%endmacro

%macro FTOSTR 3 ; converts arg2 to string in arg1
    mov ecx, %3
    mov ebx, %2
    mov edx, %1
    mov ah, 0x1C
    int 0x21
%endmacro

%macro STRTOF 1
    mov edx, %1
    mov ah, 0x1D
    int 0x21
%endmacro

%macro STRTOL 1 ; converts arg1 string to long
    mov ah, 0x09
    mov dx, %1
    int 0x21
%endmacro

%macro STOSTR 2
    mov edx, %1
    mov cx, %2
    mov ah, 0x03
    int 0x21
%endmacro

%macro TIME 0
    mov ah, 0x06
    int 0x21
%endmacro

%macro DATE 0
    mov ah, 0x07
    int 0x21
%endmacro

%macro VERSION 0
    mov ah, 0x08
    int 0x21
%endmacro

%macro HEXTOSTR 1
    mov dx, %1
    mov ah, 0x0D
    int 0x21
%endmacro

%macro ITOHEX 1
    mov ah, 0x15
    mov cl, %1
    int 0x21
%endmacro

%macro LTOHEX 2
    mov ah, 0xAB
    mov ecx, %2
    mov edx, %1
    int 0x21
%endmacro

%macro BCDTOINT 1
    mov ah, 0x16
    mov al, %1
    int 0x21
%endmacro

%macro MOVECUR 2
    mov dl, %1 ; column (x)
    mov dh, %2 ; row (y)
    mov ah, 0x0E
    int 0x21
%endmacro

%macro EXECUTE 2
    mov dx, %1
    mov di, %2
    mov ah, 0x17
    int 0x21
%endmacro

%macro READCUR 0
    mov ah, 0x0F
    int 0x21
%endmacro

%macro FINDFILE 1
    mov ah, 0x13
    mov dx, %1
    int 0x21
%endmacro

%macro SLEEP 1
    mov ebx, %1
    mov ah, 0x19
    int 0x21
%endmacro

%macro RANDOM 0
    mov ah, 0x0B
    int 0x21
%endmacro

%macro DEBUG1 1
    mov ah, 0xFF
    mov edx, %1
    int 0x21
%endmacro

%macro SERIAL_WRITE 1
    mov ah, 0xE1
    mov al, %1
    int 0x21
%endmacro

%endif
