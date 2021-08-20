; ===============================================
; ES:EDX <= String pointer
; EAX => 32 Bit float
; ===============================================
stringToFloat:
    pushad

    mov esi, edx

    call TrimLeft

    mov byte [.negative], 0x00

    cmp byte [ds:esi], '-'
    jne .start

    mov byte [.negative], 0x01
    inc esi
.start:
    mov edi, .intstr
.copy:
    mov al, byte [ds:esi]   ; copy int part so up to the dot
    inc esi
    
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

    mov byte [edi], al
    inc edi
    jmp .copy
.decimals:
    mov edi, .floatstr
.copyDecimals:              ; copy the part after the dot (decimals)
    mov al, byte [ds:esi]
    inc esi
    
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

    mov byte [edi], al
    inc edi
    jmp .copyDecimals
.done2:
    mov esi, .floatstr
    mov eax, 1 
    ; count how long decimal string is and calculate divisor on the go
    ; length 5 -> 10^5 divisor
.float_length:
    push eax
    mov al, byte [esi]
    inc esi
    test al, al
    jz .done3
    pop eax
    xor edx, edx
    mov ebx, 10
    mul ebx
    jmp .float_length
.done3:
    pop eax

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
    mov eax, dword [.the_float]

    clc
    jmp .okay
.error:
    stc
.okay:
    popad
    iret
.intstr times 10 db 0x00
.floatstr times 10 db 0x00
.intpart dd 0x00000000
.floatpart dd 0x00000000
.divisor dd 0x00000000
.the_float dd 0x00000000
.negative db 0x00
; ===============================================