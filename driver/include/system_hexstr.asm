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
    push ax
    xor cx, cx
    mov cl, al
    cmp cl, '0'         ; anything below 0 is invalid (check ascii map)
    jb .invalidDigit
    
    cmp cl, '9'         ; anything from 0-9 is a valid digit
    ja .checkAtoF       ; chars greater than 9 are letters (which can be valid)
    
    sub cl, '0'         ; get the decimal value from the ascii char
    pop ax
    clc                 ; no error
    ret                 ; return
.checkAtoF:             ; check uppercase letters
    cmp cl, 'A'         ; everyting below A is invalid
    jb .invalidDigit    
    cmp cl, 'F'         ; everything above F may be lowercase letter
    ja .checkatof
    
    sub cl, ('A'-10)    ; get decimal value from ascii char
    pop ax
    clc                 ; no error
    ret                 ; return
.checkatof:             ; check lowercase letters
    cmp cl, 'a'         ; now only a-f remain as valid digits
    jb .invalidDigit    ; everything else is invalid
    cmp cl, 'f'
    ja .invalidDigit
    
    sub cl, ('a'-10)    ; get decimal value
    pop ax
    clc                 ; no error
    ret                 ; return
.invalidDigit:
    xor cx, cx          ; zero the output value
    pop ax
    stc                 ; an error occured
    ret                 ; return
; ======================================================
    

; ======================================================
; converts the first two characters of the string into
; decimal, assuming they represent a hexadecimal value
; DS:DX <= Pointer to string
; CL => represented byte
; Carry flag indicates error
; ======================================================
hexToDec:
    push si
    push ax
    push bx
    
    mov si, dx
    xor ax, ax
    xor bx, bx
    xor cx, cx
    
    mov al, byte [ds:si]  ; get first char
    
    call private_hexToDec ; outputs cl
    jc .error
    mov bl, cl
    
    
    mov al, byte [ds:si+1]  ; get seond char
    call private_hexToDec ; outputs cl
    jc .error
    shl bl, 4
    or cl, bl
    
    pop bx
    pop ax
    pop si
    ; outputs cl
    clc
    iret
.error:
    pop bx
    pop ax
    pop si
    xor cx, cx
    stc
    iret
; ======================================================
