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

strReady db 0x0D, 0x0A,"32> ", 0x00
cmdHALT db "HALT", 0x00
cmdCLS  db "CLS", 0x00
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
    mov edi, cmdHALT
    call str_compare
    je .exit
    
    mov esi, kbBuffer
    mov edi, cmdCLS
    call str_compare
    je .cls
    
    call getCursor32
    inc dh
    call setCursor32
    
    mov bl, 0x07
    mov edx, kbBuffer
    call printString32
    
    jmp mLoop

.cls:    
    mov bl, 0x07
    call cls32
    
    jmp mLoop
    
.exit:
    mov bh, 10
    mov bl, 30
    call setCursor32
    
    mov bl, 0x07
    mov edx, str1
    call printString32

    hlt
kbBuffer db 00h
