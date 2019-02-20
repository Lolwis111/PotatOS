; ===============================================
add_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov eax, dword [numberA]
    add eax, dword [numberB]
    push eax
    jnc .noOverflow
    
    PRINT msgOverflow, createColor(BLACK, RED)

.noOverflow:
    pop ecx ; convert result to string
    mov dword [result], ecx
    LTOSTR lblResult, ecx
    
    PRINT msgResult, NUM_COLOR
    
    PRINT lblResult, STD_COLOR ; print result
    
    jmp main
; ===============================================
 
