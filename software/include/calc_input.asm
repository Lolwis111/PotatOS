; ==============================================
readA:
    print lblA, NUM_COLOR

    readline inputString, 9

    mov esi, inputString
    call UpperCase
    strcmp inputString, cmdANS
    je .ans

    mov esi, inputString
    mov edi, cmdMEM
    cmpsd
    je .loadMem
    
    strtol inputString    
    cmp eax, -1
    je .returnError

    clc
    ret
.ans:
    mov ecx, dword [result]
    clc
    ret
.loadMem:
    xor ebx, ebx
    mov bl, byte [inputString+3]
    
    cmp ebx, 'A'
    jb .returnError
    cmp ebx, 'F'
    ja .returnError
    
    sub ebx, 'A'
    
    mov ecx, dword [resultMemory + ebx*4]
    clc
    ret
.returnError:
    xor ecx, ecx
    stc
    ret
; ==============================================


; ===============================================
readNumbers:
    call readA
    jc .returnError
    
    mov dword [numberA], ecx
    
    print lblB, NUM_COLOR
    
    readline inputString, 9

    mov esi, inputString
    call UpperCase
    strcmp inputString, cmdANS
    je .ans

    mov esi, inputString
    mov edi, cmdMEM
    cmpsd
    je .loadMem
    
    strtol inputString

    cmp eax, -1 
    je .returnError
    
.ok:
    mov dword [numberB], ecx
    clc
    ret
.ans:
    mov ecx, dword [result]
    jmp .ok
.loadMem:
    xor ebx, ebx
    mov bl, byte [inputString+3]
    
    cmp ebx, 'A'
    jb .returnError
    cmp ebx, 'F'
    ja .returnError
    
    sub ebx, 'A'
    
    mov ecx, dword [resultMemory + ebx*4]
    jmp .ok
.returnError:
    xor ecx, ecx
    stc
    ret
; ===============================================