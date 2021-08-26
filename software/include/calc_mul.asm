; ===============================================
mul_numbers:
    call readNumbers
    
    fld dword [numberA]
    fmul dword [numberB]
    fstp dword [result]

    FTOSTR lblResult, dword [result]
    
    PRINT msgResult, NUM_COLOR    
    PRINT lblResult, STD_COLOR

    jmp main
; ===============================================   


