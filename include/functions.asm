%ifndef _FUNCTIONS_ASM_
%define _FUNCTIONS_ASM_

%macro print 2
    mov dx, %1
    mov bl, byte %2
    mov ah, 0x01
    int 0x21
%endmacro

%macro print 1
    print %1, [SYSTEM_COLOR]
%endmacro

%macro readline 2
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

%macro strcmp 2
    mov di, %1
    mov si, %2
    mov ah, 0x02
    int 0x21
    test al, al
%endmacro

%macro loadfile 3
    mov dx, %1
    mov bx, %2
    mov ebp, %3
    mov ah, 0x05
    int 0x21
%endmacro

%macro loadfile 2 ; load file to BP:BX
    mov dx, %1
    xor bp, bp
    mov bx, %2
    mov ah, 0x05
    int 0x21
%endmacro 

%macro ltostr 2 ; converts arg2 to string in arg1
    mov ecx, %2
    mov dx, %1
    mov ah, 0xAA
    int 0x21
%endmacro

%macro itostr 2 ; converts arg2 to string in arg1
    movzx ecx, %2
    mov dx, %1
    mov ah, 0xAA
    int 0x21
%endmacro

%macro strtol 1 ; converts arg1 string to long
    mov ah, 0x09
    mov dx, %1
    int 0x21
%endmacro

%macro movecur 2
    mov dl, %1 ; column (x)
    mov dh, %2 ; row (y)
    mov ah, 0x0E
    int 0x21
%endmacro

%macro sleep 1
    mov ebx, %1
    mov ah, 0x19
    int 0x21
%endmacro

%endif
