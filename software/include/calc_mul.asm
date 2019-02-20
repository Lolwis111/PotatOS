; ===============================================
mul_numbers:
    call readNumbers
    
    mov eax, dword [numberA]
    imul dword [numberB]

    mov dword [result], eax

    LTOSTR lblResult, eax
    
    PRINT msgResult, NUM_COLOR    
    PRINT lblResult, STD_COLOR

    jmp main
; ===============================================   


