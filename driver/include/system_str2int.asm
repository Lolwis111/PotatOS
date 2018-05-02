; ======================================================
; convert string to int
; DS:DX => String
; ECX <= Number
; EAX <= Errorcode
; Carryflag <= Error indication
; ======================================================
stringToInt:
    xor ecx, ecx ; result
    mov si, dx
    
    call TrimLeft ; skip white spaces prefixing the string
    
    cmp byte [ds:si], 0x00 ; if the first byte is \0 its not a valid integer
    je .invalidCharError
    
    xor bl, bl ; sign = positive
    
    cmp byte [ds:si], '-' ; check for minus sign
    jne .loop1 ; if there is none we go directly to the loop
    
    inc si ; skip sign in string
    inc bl ; sign = negative
    
.loop1:
    cmp byte [ds:si], 0x00 ; string has to end on a whitespace or \0
    je .done

    cmp byte [ds:si], 0x0D
    je .done
    
    cmp byte [ds:si], 0x0A
    je .done
    
    cmp byte [ds:si], '0' ; check each char
    jb .invalidCharError
    cmp byte [ds:si], '9'
    ja .invalidCharError
    
    ; multiply ecx by 10 without
    ; mul instruction: (ecx * 2) + (ecx * 8)
    shl ecx, 1 ; ecx * 2
    mov eax, ecx 
    shl ecx, 2 ; (ecx * 2) * 4
    add ecx, eax 
    
    movzx eax, byte [ds:si]
    sub eax, 48 ; concert character to number
    
    add ecx, eax ; add number to result
    jc .overflowError ; check for overflows
    
    inc si ; address next character
    jmp .loop1
    
.invalidCharError:
    mov eax, -1
    xor ecx, ecx
    stc
    iret
.overflowError:
    mov eax, 1
    xor ecx, ecx
    stc
    iret
.done:
    test bl, bl
    je .ret
    neg ecx
.ret:
    xor eax, eax
    clc
    iret
; ======================================================