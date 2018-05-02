; ======================================================
; intToStr (16 bit)
; DX <= String
; CX <= Integer
;
; Converts the Integer in CX to a String in DX
; The string gets filled with leading zeros to fit 5 
; digits and gets \0-terminated.
; ======================================================
intToString16:
    pusha
    mov ax, cx
    mov di, dx
    xor cx, cx
    xor bp, bp
    
    cmp ax, 0x00
    jns .digit1
    
    neg ax
    mov byte [di], '-'
    inc di
    
.digit1:        
    xor dx, dx
    mov bx, 10000
    div bx              ; 0 0000
    
    cmp al, 0x00
    jz .zero1
    
    add al, 48
    stosb
    jmp .digit2
    
.zero1:
    mov bp, 0x01
    
.digit2:
    mov ax, dx
    mov bx, 1000
    xor dx, dx
    div bx              ; 0 000
    
    cmp al, 0x00
    jz .ok2
.nok2:
    add al, 48
    stosb
    xor bp, bp
    jmp .digit3
.ok2:
    cmp bp, 0x01
    jnz .nok2
.zero2:
    mov bp, 0x01
    
    
.digit3:
    mov ax, dx
    mov bx, 100
    xor dx, dx
    div bx              ; 0 00

    cmp al, 0x00
    jz .ok3
.nok3:
    add al, 48
    stosb
    xor bp, bp
    jmp .digit4
.ok3:   
    cmp bp, 0x01
    jnz .nok3
.zero3:
    mov bp, 0x01

    
.digit4:
    mov ax, dx
    mov bx, 10
    xor dx, dx
    div bx              ; 0 0
    
    cmp al, 00h
    jz .ok4
.nok4:
    add al, 48
    stosb
    jmp .digit5
    
.ok4:
    ; cmp byte [.status], 01h
    cmp bp, 0x01
    jnz .nok4

.digit5:
    xchg ax, dx
    add al, 48
    stosb

.end:
    xor al, al
    stosb
    popa
    iret
; ======================================================


; ======================================================
; ECX <= Integer
; DX <= String
;
; Converts the Integer in ECX to a string in DX.
; The string only shows the digits that are needed,
; no leading zeroes.
; (make sure your string has enough space to fit 10
; digits + \0-termination)
; ======================================================
intToString32:
    call private_intToString32
    iret
private_intToString32:
    pusha
    
    mov edi, edx
    mov eax, ecx

    test eax, eax
    jz .zero

    cmp eax, 0x00
    jns .start

    not eax
    inc eax
    mov byte [edi], '-'
    inc edi

.start:
    mov byte [.leadingZero], 0x01
    mov dword [.divisor], 1000000000
.loop1:
    xor edx, edx
    mov ebx, dword [.divisor]
    div ebx

    cmp al, 0x00
    jne .else
    cmp byte [.leadingZero], 0x01
    jne .else

    mov eax, edx
    jmp .div10
.else:
    mov byte [edi], al
    add byte [edi], 48
    inc edi
    mov byte [.leadingZero], 0x00
    mov eax, edx
.div10:
    push eax

    xor edx, edx
    mov eax, dword [.divisor]
    mov ebx, 10
    div ebx
    mov dword [.divisor], eax
    cmp eax, 0
    je .return
    pop eax
    jmp .loop1
.return:
    mov byte [edi], 0x00
    pop eax
    
    popa
    ret
.zero:
    mov byte [edi], '0'
    inc esi
    mov byte [edi], 0x00
    
    popa
    ret
.leadingZero db 0x01
.divisor dd 1000000000
; ======================================================
