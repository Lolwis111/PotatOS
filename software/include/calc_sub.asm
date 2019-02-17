; ===============================================
sub_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov ecx, dword [numberA]
    sub ecx, dword [numberB]
    push ecx
    jno .noOverflow

    print msgOverflow, createColor(BLACK, RED)

.noOverflow:  
    pop ecx
    mov dword [result], ecx
    ltostr lblResult, ecx ; convert result to string

    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result

    jmp main
; ===============================================
 
