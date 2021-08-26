; ===============================================
sub_numbers:
    call readNumbers
    cmp ax, -1
    je main
    
    fld dword [numberA]
    fsub dword [numberB]
    fstp dword [result]
    
    FTOSTR lblResult, dword [result] ; convert result to string

    PRINT msgResult, NUM_COLOR
    
    PRINT lblResult, STD_COLOR ; print result

    jmp main
; ===============================================
 
