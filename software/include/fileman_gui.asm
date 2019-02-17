; ================================================
drawBorder:
    mov bx, cursorPos(0, 0)
    mov cx, SCREEN_WIDTH
.top:
    mov byte [gs:bx], 196
    inc bx
    mov byte [gs:bx], BORDER_COLOR
    inc bx
    loop .top
    
    mov bx, cursorPos(0, 24)
    mov cx, SCREEN_WIDTH
.bottom:
    mov byte [gs:bx], 196
    inc bx
    mov byte [gs:bx], BORDER_COLOR
    inc bx
    loop .bottom
    
    mov bx, cursorPos(0, 1)
    mov cx, (SCREEN_HEIGHT - 2)
.left:
    mov byte [gs:bx], 179
    inc bx
    mov byte [gs:bx], BORDER_COLOR
    add bx, ((SCREEN_WIDTH * 2) - 1)
    loop .left
    
    mov bx, cursorPos(79, 1)
    mov cx, (SCREEN_WIDTH - 2)
.right:
    mov byte [gs:bx], 179
    inc bx
    mov byte [gs:bx], BORDER_COLOR
    add bx, 159
    loop .right

    mov bx, cursorPos(0, 24)
    mov byte [gs:bx], 192
    
    mov bx, cursorPos(79, 24)
    mov byte [gs:bx], 217
    
    mov bx, cursorPos(0, 0)
    mov byte [gs:bx], 218
    
    mov bx, cursorPos(79, 0)
    mov byte [gs:bx], 191

    mov di, cursorPos(3, 0)
    mov byte [gs:di], 180
    
    mov di, cursorPos(11, 0)
    mov byte [gs:di], 195
    
    mov di, cursorPos(4, 0)
    mov ah, TEXT_COLOR
    mov si, titleString
    call printString

    ret
; ================================================

; ================================================
clearContentBox:
    mov di, cursorPos(1, 1)
    mov cx, SCREEN_HEIGHT-2
.loopY:
    push cx
    mov cx, SCREEN_WIDTH-2
    .loopX:
        mov byte [gs:di], 0x20
        mov byte [gs:di+1], TEXT_COLOR
        add di, 2
        loop .loopX
    add di, 4
    pop cx
    loop .loopY
    ret
; ================================================

; ================================================
; cl Color
; bx Index
; ================================================
drawCursor:
    push di
    
    mov di, cursorPos(1, 1)
    
    xor dx, dx
    mov ax, (SCREEN_WIDTH*2)
    movzx bx, byte [selectedIndex]
    mul bx
    add di, ax
    
    inc di
    
    mov cx, 60
.loop:
    mov byte [gs:di], SELECTION_COLOR
    add di, 2
    dec cx
    jnz .loop
    
    pop di
    ret
; ================================================
 
