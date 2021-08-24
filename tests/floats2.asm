%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"

f1 db "0.01", 0x00
ff1 dd 0.01

f2 db "0.1", 0x00
ff2 dd 0.1

f3 db "1.0", 0x00
ff3 dd 1.0

f4 db "10.01", 0x00
ff4 dd 10.01

f5 db "1000", 0x00
ff5 dd 1000.0

f6 db "50.0", 0x00
ff6 dd 50.0

f7 db "123456.789", 0x00
ff7 dd 123456.789

f8 db "99.00001", 0x00
ff8 dd 99.00001

f9 db "0.0", 0x00
ff9 dd 0.0

f10 db "10.10", 0x00
ff10 dd 10.10

f11 db "-1", 0x00
ff11 dd -1.0

f12 db "-1.0", 0x00
ff12 dd -1.0

f13 db "-1.1", 0x00
ff13 dd -1.1

f14 db "-99.002", 0x00
ff14 dd -99.002

f15 db "-1234.5678", 0x00
ff15 dd -1234.5678

newLine db "\r\n", 0x00
string times 40 db 0x00

start:
    PRINT newLine

    STRTOF f1
    mov ebx, dword [ff1]
    call compareFloat

    STRTOF f2
    mov ebx, dword [ff2]
    call compareFloat

    STRTOF f3
    mov ebx, dword [ff3]
    call compareFloat

    STRTOF f4
    mov ebx, dword [ff4]
    call compareFloat

    STRTOF f5
    mov ebx, dword [ff5]
    call compareFloat

    STRTOF f6
    mov ebx, dword [ff6]
    call compareFloat

    STRTOF f7
    mov ebx, dword [ff7]
    call compareFloat

    STRTOF f8
    mov ebx, dword [ff8]
    call compareFloat

    STRTOF f9
    mov ebx, dword [ff9]
    call compareFloat

    STRTOF f10
    mov ebx, dword [ff10]
    call compareFloat

    STRTOF f11
    mov ebx, dword [ff11]
    call compareFloat

    STRTOF f12
    mov ebx, dword [ff12]
    call compareFloat

    STRTOF f13
    mov ebx, dword [ff13]
    call compareFloat

    STRTOF f14
    mov ebx, dword [ff14]
    call compareFloat

    STRTOF f15
    mov ebx, dword [ff15]
    call compareFloat


    EXIT EXIT_SUCCESS

; compare EAX and EBX
; by doing:
;    abs(eax - ebx) < threshold
; threshold being 0.0001 here.
compareFloat:
    mov dword [.temp1], eax
    mov dword [.temp2], ebx
    fld dword [.temp1]      ; load a
    fsub dword [.temp2]     ; load b and subtract from a
    fabs                    ; abs(a - b)
    fld dword [.threshold]  ; load threshold
    fcompp                  ; compare abs(a-b) and threshold and also clear stack
    fstsw ax                ; load status word
    test ax, 0x0100         ; check bits for st0 > src
    jz .pass                ; z-flag means its true

    PRINT .err
    ret
.pass:
    PRINT .okay
    ret
.threshold dd 0.0001
.temp1 dd 0x00000000
.temp2 dd 0x0000000
.okay db "okay\r\n", 0x00
.err db "err\r\n", 0x00

err:
    EXIT EXIT_FAILURE