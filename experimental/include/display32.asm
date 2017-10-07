%ifndef _DISPLAY32_H_
%define _DISPLAY32_H_

[BITS 32]
col db 00h
row db 00h

; ===============================================
cls32:
    pusha
    mov al, bl
    mov ebx, 0xB8000
    mov cx, 2000
.L1:
    mov byte [ebx], 0x20
    inc ebx
    mov byte [ebx], al
    inc ebx
    loop .L1

    xor bx, bx
    call setCursor32
    popa
    ret
; ===============================================


; ===============================================
printString32:
    pusha
    mov esi, edx
    mov dl, bl
.charLoop:
    mov al, byte [esi]
    inc esi

    test al, al
    jz .end

    mov dh, al
    call printChar32

    jmp .charLoop
.end:
    popa
    ret
; ===============================================


; ===============================================
printChar32:
    pusha

    mov edi, 0xB8000
    push edx
    xor ebx, ebx
    movzx bx, byte [col]   ; Grobe Formel: x * 2 + (y * SCREEN_WIDTH)
    xor eax, eax
	movzx ax, byte [row]
    xor edx, edx
	shl bx, 1
	mov ecx, 80*2
	mul cx
	add bx, ax
    add edi, ebx
    pop edx

    cmp dh, 0Dh
    je .cr
    cmp dh, 0Ah
    je .lf
    
    mov byte [edi], dh
    inc edi
    mov byte [edi], dl
    inc edi

    inc byte [col]
    cmp byte [col], 160
    je .newLine

    jmp .return
.newLine:
    mov byte [col], 00h
    inc byte [row]

    cmp byte [row], 23
    jae .moveBuffer

    jmp .return
.cr:
    mov byte [col], 00h
    jmp .return
.lf:
    inc byte [row]

    cmp byte [row], 23
    jae .moveBuffer
    jmp .return
.moveBuffer:

    mov byte [row], 22

    mov edi, 0xB8000
    mov esi, 0xB80A0
    mov cx, 1920
    rep movsw

.return:
    mov bh, byte [row]
    mov bl, byte [col]
    call setCursor32

    popa
    ret
; ===============================================


; ===============================================
; bh y
; bl x
; ===============================================
setCursor32:
    pusha

    mov byte [row], bh
    mov byte [col], bl

    xor eax, eax
    mov ecx, 80
    mov al, bh
    mul ecx
    add al, bl
    mov ebx, eax

    mov al, 0x0F
    mov dx, 0x03D4
    out dx, al

    mov al, bl
    mov dx, 0x03D5
    out dx, al

    xor eax, eax
    mov al, 0x0E
    mov dx, 0x03D4
    out dx, al

    mov al, bh
    mov dx, 0x03D5
    out dx, al

    popa
    ret
; ===============================================


; ===============================================
getCursor32:
    mov dh, byte [row]
    mov dl, byte [col]

    ret
; ===============================================

%endif
