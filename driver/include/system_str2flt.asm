; ===============================================
; DS:DX <= String pointer
; EAX => 32 Bit float
; ===============================================
stringToFloat:
    pushad
    push es
    
    cld
    xor ax, ax
    mov si, dx
    mov es, ax

    call TrimLeft

    mov byte [.negative], 0x00

    cmp byte [ds:si], '-'
    jne .start

    mov byte [.negative], 0x01
    inc si
.start:
    mov di, .intstr
.copy:
    mov al, byte [ds:si]   ; copy int part so up to the dot
    inc si
    
    cmp al, 0x00
    je .done2
    
    cmp al, 0x0A    ; detect newline
    je .done2
    
    cmp al, 0x0D
    je .done2
    
    cmp al, '.'
    je .decimals

    cmp al, '0'
    jb .error
    cmp al, '9'
    ja .error

    mov byte [es:di], al
    inc di
    jmp .copy
.decimals:
    mov byte [es:di], 0x00
    mov di, .floatstr
.copyDecimals:              ; copy the part after the dot (decimals)
    mov al, byte [ds:si]
    inc si
    
    cmp al, 0x00
    je .done2
    
    cmp al, 0x0A    ; detect newline
    je .done2
    
    cmp al, 0x0D
    je .done2
    
    cmp al, '0'
    jb .error
    cmp al, '9'
    ja .error

    mov byte [es:di], al
    inc di
    jmp .copyDecimals
.done2:
    mov eax, 1
    mov byte [es:di], 0x00
    mov si, .floatstr
    ; count how long decimal string is and calculate divisor on the go
    ; length 5 -> 10^5 divisor
.float_length:
    mov ebp, eax
    
    mov al, byte [es:si]
    inc si
    
    test al, al
    jz .done3
    
    mov ebx, 10
    xor edx, edx
    mov eax, ebp
    mul ebx
    jmp .float_length
.done3:
    mov eax, ebp

    mov dword [.divisor], eax

    mov edx, .floatstr
    call private_stringToInt
    mov dword [.floatpart], ecx ; convert decimals

    mov edx, .intstr
    call private_stringToInt
    mov dword [.intpart], ecx ; convert int part

    ; float = int_part + (float_part / divisor)
    ; e.g. 3.1415 = 3 + (1415 / 10000)
    fild dword [.floatpart]
    fidiv dword [.divisor]
    fiadd dword [.intpart]

    cmp byte [.negative], 0x00
    je .save
    fchs ; negate float if negative
.save:
    fstp dword [.the_float]
    clc
    jmp .okay
.error:
    stc
.okay:
    call .clean
    pop es
    popad
    mov eax, dword [.the_float]
    iret

.clean:
    xor edx, edx
    mov dword [es:.intstr], edx
    mov dword [es:.intstr+4], edx
    mov dword [es:.intstr+8], edx
    mov dword [es:.intstr+12], edx
    mov dword [es:.floatstr], edx
    mov dword [es:.floatstr+4], edx
    mov dword [es:.floatstr+8], edx
    mov dword [es:.floatstr+12], edx
    mov dword [es:.intpart], edx
    mov dword [es:.floatpart], edx
    mov dword [es:.divisor], edx
    mov byte [es:.negative], dl
    ret

.intstr times 16 db 0x00
.floatstr times 16 db 0x00
.intpart dd 0x00000000
.floatpart dd 0x00000000
.divisor dd 0x00000000
.the_float dd 0x00000000
.negative db 0x00
; ===============================================