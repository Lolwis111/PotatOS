%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

buffer: times 20 db 0x00
buffer2: times 20 db 0x00

start:
    xor ax, ax
    mov es, ax
    mov ds, ax

    call detectMemory
    jc .error

    mov ax, word [entryCount]
    push ax
    ITOSTR buffer, ax

    PRINT NEWLINE

    PRINT .lblCount
    PRINT buffer

    PRINT NEWLINE

    mov dword [memsize], 0x00000000
    xor bp, bp
    pop cx
.entryLoop:
    mov eax, dword [entries+bp+4]
    add dword [memsize], eax
    add bp, 24
    loop .entryLoop

    cld
    LTOSTR buffer2, dword [memsize]

    mov eax, dword [memsize]
    mov dword [0x8FFC], eax

    PRINT NEWLINE

    PRINT .lblMem

    PRINT buffer2

    PRINT NEWLINE

    EXIT 0
.error:
    PRINT NEWLINE
    PRINT .msgErr
    PRINT NEWLINE

    EXIT 1

.lblMem db "Bytes of Memory: ", 0x00
.lblCount db "Entries: ", 0x00
.msgErr db "Error!", 0x00

detectMemory:
    pushad
    mov di, entries
    xor ebx, ebx
    xor bp, bp
    mov edx, 0x534D4150
    mov eax, 0xE820
    mov dword [es:di + 20], 0x0001
    mov ecx, 24
    int 0x15
    jc .error
    mov edx, 0x534D4150
    cmp eax, edx
    jne .error
    test ebx, ebx
    je .error
    jmp .jmpin
.e820lp:
    mov eax, 0xE820
    mov dword [es:di + 20], 0x0001
    mov ecx, 24
    int 0x15
    jc .e820f
    mov edx, 0x534D4150
.jmpin:
    jcxz .skipEntry
    cmp cl, 20
    jbe .noText
    test byte [es:di + 20], 1
    je .skipEntry
.noText:
    mov ecx, [es:di + 8]
    or ecx, [es:di + 12]
    jz .skipEntry
    inc bp
    add di, 24
.skipEntry:
    test ebx, ebx
    jne .e820lp
.e820f:
    mov word [entryCount], bp
    popad
    clc
    ret
.error:
    popad
    stc
    ret
memsize dd 0x00000000
entryCount dw 0x0000
entries db 0x00
