; ===============================================
mul_numbers:
    call readNumbers
    
    mov eax, dword [numberA]
    imul dword [numberB]

    mov dword [result], eax

    ltostr lblResult, eax
    
    print msgResult, NUM_COLOR    
    print lblResult, STD_COLOR

    jmp main
; ===============================================   


