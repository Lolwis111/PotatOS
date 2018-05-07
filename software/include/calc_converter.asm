; ===============================================
dec_to_bin:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 32
    mov edi, .bitString+35
.bitLoop:
    push cx
    xor edx, edx
    mov ebx, 2
    div ebx
    push eax

    add dx, 48
    mov byte [edi], dl
    dec edi

    pop eax
    pop cx
    loop .bitLoop

    print .bitString, STD_COLOR

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
    mov edi, .hexString+11
.charLoop:
    push cx
    
    xor edx, edx
    mov ebx, 16
    div ebx
    push eax

    mov esi, .hexChars
    add esi, edx
    mov al, byte [esi]
    mov byte [edi], al
    dec edi

    pop eax
    
    pop cx
    loop .charLoop

    print .hexString, STD_COLOR

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
    mov edi, .octString+15
.charLoop:
    push cx
    xor edx, edx
    mov ebx, 8
    div ebx
    push eax

    add dx, 48
    mov byte [edi], dl
    dec edi

    pop eax
    pop cx
    loop .charLoop

    print .octString, STD_COLOR

    jmp main
.octString db "\r\n000000000000", 0x00
; ===============================================