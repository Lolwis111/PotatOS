[BITS 32]
%ifndef _INPUT32_H_
%define _INPUT32_H_

%include "include/display32.asm"
%define DATA_PORT 0x60
%define STATUS_PORT 0x64
%define COMMAND_PORT 0x64

; ===============================================
; DL <= Befehl
sendCommand:
.wait:
    in al, STATUS_PORT
    test al, 02h
    jz .wait
    mov al, dl
    out DATA_PORT, al
    ret
; ===============================================


; ===============================================
kb_readLine:
    pusha

    mov edi, edx
    xor ecx, ecx
.charLoop:
    call kb_readChar

    cmp al, 0x1C
    je .return

    cmp al, 0x00
    je .charLoop

    inc word [.charCount]

    pusha
    mov dh, al
    mov dl, 0x07
    call printChar32
    popa

    mov byte [edi], al
    inc edi
    inc ecx

    jmp .charLoop

.return:
    mov byte [edi], 00h
    popa
    movzx ecx, word [.charCount]
    ret
.charCount dw 00h
; ===============================================


; ===============================================
kb_readChar:
.L1:
    xor eax, eax
    in al, STATUS_PORT
    test al, 01h
    jz .L1

    in al, DATA_PORT

    test al, 0x80
    jnz .L1

    call .getChar
    ret

.getChar:
    cmp al, 0x02
    jb .next
    cmp al, 0x0B
    ja .next

    sub ax, 0x02
    mov esi, .numbersL
    add esi, eax

    mov al, byte [esi]
    ret
.next:
    cmp al, 0x10
    jb .next2
    cmp al, 0x19
    ja .next2

    sub ax, 0x10
    mov esi, .charsL1
    add esi, eax

    mov al, byte [esi]
    ret
.next2:
    cmp al, 0x1E
    jb .next3
    cmp al, 0x26
    ja .next3

    sub ax, 0x1E
    mov esi, .charsL2
    add esi, eax

    mov al, byte [esi]
    ret
.next3:
    cmp al, 0x2C
    jb .next4
    cmp al, 0x32
    ja .next4

    sub ax, 0x2C
    mov esi, .charsL3
    add esi, eax
    
    mov al, byte [esi]

    ret
.next4:
    cmp al, 0x39
    je .space

    cmp al, 0x1C
    je .okKeys
    xor al, al
.okKeys:
    ret

.space:
    mov al, 0x20
    ret

.numbersL db "1234567890"
.charsL1 db "qwertzuiop"
.charsL2 db "asdfghjkl"
.charsL3 db "yxcvbnm"
.shiftStatus db 00h
; ===============================================

%endif
