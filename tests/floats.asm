%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"

f1 dd 0.01
f2 dd 0.1
f3 dd 1.0
f4 dd 10.01
f5 dd 1000.0001
f6 dd 50.0
f7 dd 123456.789
f8 dd 99.00001
f9 dd 0.0
f10 dd 10.10
f11 dd -0.1
f12 dd -1.0
f13 dd -1.1
f14 dd -99.002
f15 dd -1234.5678

;msgOk db "No errors."
newLine db "\r\n", 0x00

string times 40 db 0x00

start:
    PRINT newLine

    xor ax, ax
    mov ds, ax

    mov cx, 15
    mov si, f1
    .forLoop:
        push cx
        push si
        FTOSTR string, dword [si]
        PRINT string
        PRINT newLine 
        pop si
        pop cx
        add si, 4
        loop .forLoop

    EXIT EXIT_SUCCESS
    
err:
    EXIT EXIT_FAILURE