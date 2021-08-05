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
hexToDec:
    call private_hexToDec
    iret

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
