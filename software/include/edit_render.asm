; ===============================================
; PRINT a single char without advancing the
; cursor position
; >DL X
; >DH Y
; ===============================================
PrintChar:
    pusha
    push ax
    mov ax, dx
    movzx bx, dl
    movzx ax, dh
    shl bx, 1
    mov cx, 160
    mul cx
    add bx, ax
    pop ax
    mov word [gs:bx], ax
    popa
    ret
; ===============================================


; ===============================================
; Print the position in the statusbar
; ===============================================
renderPosition:
    MOVECUR 73, 23
    
    mov dword [.positionString], 0x00000000
    mov word [.positionString+4], 0x0000

    STOSTR .positionString, word [linesToSkip]
    
    PRINT .positionString, COLOR
    
    MOVECUR 0, 2
    
    ret
.positionString times 6 db 0x00
; ===============================================


; ===============================================
; PRINT content of file
; ===============================================
renderText:    
    call clearTextArea

    xor ax, FILE_SEGMENT
    mov fs, ax
    xor si, si
    cmp word [linesToSkip], 0x00
    je .ok    
    
    xor dx, dx    
    xor cx, cx
.skipLoop:
    mov al, byte [fs:si]
    inc si
    inc cx
    
    cmp al, 0x0A
    je .skipNewLine
    
    cmp cx, 79
    je .skipNewLine
    
    jmp .skipLoop
    
.skipNewLine:
    inc dx
    xor cx, cx
    
    cmp dx, word [linesToSkip]
    je .ok
    
    jmp .skipLoop
    
.ok:
    ; ---------------
    ; |  BH  |  BL  |
    ; ---------------
    ; |  Y   |  X   |
    ; ---------------
    mov bx, 0x0200
.charLoop:
    mov al, byte [fs:si]
    
    inc si
    
    cmp al, 0x00
    je .done
    cmp al, 0x0A
    je .newLine
    
    cmp al, 0x0D
    je .charLoop

    mov dx, bx
    mov ah, COLOR
    call PrintChar
    inc bl
    
    cmp bl, 79
    je .newLine
    
    jmp .charLoop

.newLine:
    xor bl, bl
    inc bh
    cmp bh, 23
    je .done

    jmp .charLoop
    
.done:
    ret
; ===============================================


