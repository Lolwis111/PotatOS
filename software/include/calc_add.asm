; ===============================================
add_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov eax, dword [numberA]
    add eax, dword [numberB]
    push eax
    jnc .noOverflow
    
    print msgOverflow, createColor(BLACK, RED)

.noOverflow:
    pop ecx ; convert result to string
    mov dword [result], ecx
    ltostr lblResult, ecx
    
    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result
    
    jmp main
; ===============================================
 
