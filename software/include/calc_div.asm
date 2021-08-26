; ===============================================
div_numbers:
    call readNumbers
    cmp ax, -1
    je main
    
    cmp dword [numberB], 0x00
    je .div0
    
    fld dword [numberA]
    fdiv dword [numberB]
    fstp dword [result]
    
    FTOSTR lblResult, dword [result] ; convert result to string
    
    PRINT msgResult, NUM_COLOR
    
    PRINT lblResult, STD_COLOR ; print result
    
    jmp main
.div0:
    PRINT DIV_NULL_ERROR, createColor(RED, BLACK)
    jmp main
.lblRest        db "Rest    : ", 0x00
; ===============================================


