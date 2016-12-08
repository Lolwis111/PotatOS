[BITS 16]
[ORG 0x9000]

jmp start

%include "include/gdt.asm"

start:
    mov ax, 0003h
    int 10h

    cli
    lgdt [gdt]
    sti
    
    cli
    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp 0x08:MAIN32

    hlt

[BITS 32]

%include "include/display32.asm"
%include "include/input32.asm"
%include "include/strings32.asm"
%define CURRENT_YEAR 2014
%define CMOS_ADDRESS 0x70
%define CMOS_PORT    0x71

strReady db 0x0D, 0x0A,"32> ", 0x00
cmdTime db "TIME", 0x00
cmdExit db "EXIT", 0x00
str1 db "*** KERNEL32 HALT ***", 0x00

MAIN32:
    mov ax, 0x10
    mov es, ax
    mov ds, ax
    mov ss, ax
    mov esp, 0x10000

    mov bl, 0x07
    call cls32

    xor bx, bx
    call setCursor32

mLoop:
    mov bl, 0x07
    mov edx, strReady
    call printString32

    mov edx, kbBuffer
    call kb_readLine

    mov esi, kbBuffer
    call ToUpper

    mov esi, kbBuffer
    mov edi, cmdExit
    call str_compare
    cmp eax, 0
    je .exit

    mov esi, kbBuffer
    mov edi, cmdTime
    call str_compare
    cmp eax, 0
    je .time

    jmp mLoop
.time:
    
    jmp mLoop
.getUpdateFlag:
    mov ax, 0x0A
    out CMOS_ADDRESS, ax
    in al, CMOS_PORT
    and al, 0x80
    ret
.getRTCRegister:
    out CMOS_ADDRESS, ax
    in al, CMOS_PORT
    ret
.second db 0x00
.minute db 0x00
.hour   db 0x00
.day    db 0x00
.month  db 0x00
.year   dd 0x00
century_register dd 0x00

.exit:
    mov bh, 10
    mov bl, 30
    call setCursor32
    mov bl, 0x07
    mov edx, str1
    call printString32

    hlt
kbBuffer db 00h
