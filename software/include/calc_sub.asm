; ===============================================
sub_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov ecx, dword [numberA]
    sub ecx, dword [numberB]
    push ecx
    jno .noOverflow

    PRINT msgOverflow, createColor(BLACK, RED)

.noOverflow:  
    pop ecx
    mov dword [result], ecx
    LTOSTR lblResult, ecx ; convert result to string

    PRINT msgResult, NUM_COLOR
    
    PRINT lblResult, STD_COLOR ; print result

    jmp main
; ===============================================
 
