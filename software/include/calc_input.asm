; ==============================================
readA:
    PRINT lblA, NUM_COLOR
    READLINE inputString, 16
    
    STRTOF inputString    
    jc .returnError
    mov ecx, eax
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
    
    PRINT lblB, NUM_COLOR
    
    READLINE inputString, 16

    STRTOF inputString
    jc .returnError
    mov ecx, eax
    
.ok:
    mov dword [numberB], ecx
    clc
    ret
.returnError:
    xor ecx, ecx
    stc
    ret
; ===============================================
