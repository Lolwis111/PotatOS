; ======================================================
; CL -> byte
; DX <- Hexstring
; ======================================================
decToHex:
    pusha
    pushf
    
    mov ax, cx
    mov si, dx
    xor ah, ah

    mov bl, 16
    div bl
    mov bx, .hexChar
    add bl, al
    mov al, byte [bx]
    mov byte [ds:si], al
    inc si
    mov bx, .hexChar
    add bl, ah
    mov al, byte [bx]
    mov byte [ds:si], al
    inc si
    mov byte [ds:si], 0x00
    
    popf
    popa
    
    iret
.hexChar db "0123456789ABCDEF"
; ======================================================


; ======================================================
; converts the integer in ecx to a hexstring
; ECX <= Integer
; EDX <= String
; ======================================================
intToHexString32:
    pushad
    pushf

    mov eax, ecx
    mov cx, 8
    mov edi, edx
.byteLoop:
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
    loop .byteLoop
    
    popf
    popad
    iret
.hexChars db "0123456789ABCDEF"
; ===============================================


; ======================================================
; Converts a hexadecimal digit in al to
; a base10 value in cl
; al <= hex digit
; cl => base10 number
; ======================================================
private_hexToDec:
    mov si, dx
    xor cx, cx
    mov cl, al
    cmp cl, '0'         ; anything below 0 is invalid (check ascii map)
    jb .invalidDigit
    
    cmp cl, '9'         ; anything from 0-9 is a valid digit
    ja .checkAtoF       ; chars greater than 9 are letters (which can be valid)
    
    sub cl, '0'         ; get the decimal value from the ascii char
    xor ax, ax          ; no error
    ret                 ; return
.checkAtoF:             ; check uppercase letters
    cmp cl, 'A'         ; everyting below A is invalid
    jb .invalidDigit    
    cmp cl, 'F'         ; everything above F may be lowercase letter
    ja .checkatof
    
    sub cl, 'A'         ; get decimal value from ascii char
    xor ax, ax          ; no error
    ret                 ; return
.checkatof:             ; check lowercase letters
    cmp cl, 'a'         ; now only a-f remain as valid digits
    jb .invalidDigit    ; everything else is invalid
    cmp cl, 'f'
    ja .invalidDigit
    
    sub cl, 'a'         ; get decimal value
    clc                 ; no error
    ret                 ; return
.invalidDigit:
    xor cx, cx          ; zero the output value
    stc                 ; an error occured
    ret                 ; return
; ======================================================
    

; ======================================================
; converts the first two characters of the string into
; decimal, assuming they represent a hexadecimal value
; ======================================================
hexToDec:
    mov si, dx
    xor ax, ax
    xor bx, bx
    mov al, byte [ds:si]
    inc si
   
    cmp al, 48  ; digits 0-9
    je .num16
    cmp al, 49
    je .num16
    cmp al, 50
    je .num16
    cmp al, 51
    je .num16
    cmp al, 52
    je .num16
    cmp al, 53
    je .num16
    cmp al, 54
    je .num16
    cmp al, 55
    je .num16
    cmp al, 56
    je .num16
    cmp al, 57
    je .num16
.chars:            ; digits A-F
    cmp al, 65
    je .char16
    cmp al, 66
    je .char16
    cmp al, 67
    je .char16
    cmp al, 68
    je .char16
    cmp al, 69
    je .char16
    cmp al, 70
    je .char16

    cmp cx, 1
    je .noc
    mov cx, 1
    sub al, 32
    jmp .chars
.noc:
    mov ax, FALSE
    iret
    
.num16:
    sub ax, 48
    shl ax, 4
    jmp .hex2
.char16:
    sub ax, 55
    shl ax, 4
.hex2:
    mov bx, ax
    mov al, byte [ds:si]
    inc si
    cmp al, 48
    je .num161
    cmp al, 49
    je .num161
    cmp al, 50
    je .num161
    cmp al, 51
    je .num161
    cmp al, 52
    je .num161
    cmp al, 53
    je .num161
    cmp al, 54
    je .num161
    cmp al, 55
    je .num161
    cmp al, 56
    je .num161
    cmp al, 57
    je .num161
.chars2:
    cmp al, 65
    je .char161
    cmp al, 66
    je .char161
    cmp al, 67
    je .char161
    cmp al, 68
    je .char161
    cmp al, 69
    je .char161
    cmp al, 70
    je .char161
    
    cmp cx, 2
    je .noc2
    mov cx, 2
    sub al, 32
    jmp .chars2
.noc2:
    mov ax, -1
    xor cx, cx
    iret
.num161:
    sub ax, 48
    add bx, ax
    jmp .end
.char161:
    sub ax, 55
    add bx, ax
.end:
    mov ax, TRUE
    mov cx, bx
    iret
; ======================================================
