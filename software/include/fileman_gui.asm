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