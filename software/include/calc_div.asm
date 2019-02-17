; ===============================================
div_numbers:
    call readNumbers
    cmp ax, -1
    je main
    
    cmp dword [numberB], 0x00
    je .div0
    
    xor edx, edx
    mov eax, dword [numberA]
    mov ecx, dword [numberB]
    idiv ecx ; divide
    
    ; AX => Ergebnis
    ; DX => Rest
    
    push edx
    
    mov dword [result], eax
    ltostr lblResult, eax ; convert result to string
    
    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result
    
    print newLine, NUM_COLOR
    
    pop ecx
    ltostr lblResult, ecx ; this is basically modulo, convert that to string too
    
    print .lblRest, NUM_COLOR

    print lblResult, STD_COLOR ; print modulo
    
    jmp main
.div0:
    print DIV_NULL_ERROR, createColor(RED, BLACK)
    jmp main
.lblRest        db "Rest    : ", 0x00
; ===============================================


