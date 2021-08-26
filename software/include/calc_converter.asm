; ===============================================
dec_to_bin:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 32
    mov di, .bitString+35
.bitLoop:
    push cx
    xor edx, edx
    mov ebx, 2
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec edi

    pop eax
    pop cx
    loop .bitLoop

    PRINT .bitString, STD_COLOR

    jmp main
.bitString db "\r\n00000000000000000000000000000000", 0x00
; ===============================================


; ===============================================
dec_to_hex:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 8
    mov di, .hexString+11
.charLoop:
    push cx
    
    xor edx, edx
    mov ebx, 16
    div ebx
    push eax

    mov si, .hexChars
    add si, dx
    mov al, byte [si]
    mov byte [di], al
    dec di

    pop eax
    
    pop cx
    loop .charLoop

    PRINT .hexString, STD_COLOR

    jmp main
.hexString db "\r\n00000000", 0x00
.hexChars db "0123456789ABCDEF"
; ===============================================


; ===============================================
dec_to_oct:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 12
    mov di, .octString+15
.charLoop:
    push cx
    xor edx, edx
    mov ebx, 8
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec di

    pop eax
    pop cx
    loop .charLoop

    PRINT .octString, STD_COLOR

    jmp main
.octString db "\r\n000000000000", 0x00
; ===============================================
