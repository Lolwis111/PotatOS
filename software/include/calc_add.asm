; ===============================================
add_numbers:
    call readNumbers
    cmp ax, -1
    je main
    
    fld dword [numberA]
    fadd dword [numberB]
    fstp dword [result]

    ; convert result to string
    FTOSTR lblResult, dword [result]
    
    PRINT msgResult, NUM_COLOR
    
    PRINT lblResult, STD_COLOR ; print result
    
    jmp main
; ===============================================
 
