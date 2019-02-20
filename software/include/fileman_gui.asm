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
    
    mov cx, 70
.loop:
    mov byte [gs:di], SELECTION_COLOR
    add di, 2
    dec cx
    jnz .loop
    
    pop di
    ret
; ================================================

%define TOP_LEFT_X 8
%define TOP_LEFT_Y 8
%define BOX_WIDTH 52
%define BOX_HEIGHT 7
%define BOTTOM_RIGHT_X (TOP_LEFT_X + BOX_WIDTH)
%define BOTTOM_RIGHT_Y (TOP_LEFT_Y + BOX_HEIGHT)
drawBox:
    pusha
    pushf
    push gs

    mov ax, VIDEO_MEMORY_SEGMENT
    mov gs, ax

    push si
    ; upper left corner
    mov di, cursorPos(TOP_LEFT_X, TOP_LEFT_Y)
    ; height
    mov cl, BOX_HEIGHT
.loopY:
    ; width
    mov ch, BOX_WIDTH
    .loopX:
        mov byte [gs:di], 0x20
        inc di
        mov byte [gs:di], TEXT_COLOR
        inc di
        dec ch
        test ch, ch
        jnz .loopX
    add di, (SCREEN_WIDTH - BOX_WIDTH)*2  ; (80 - width) * 2
    dec cl
    test cl, cl
    jnz .loopY
    

    mov di, cursorPos(TOP_LEFT_X, TOP_LEFT_Y)
    mov cx, BOX_WIDTH
.top:
    mov byte [gs:di], 205
    inc di
    mov byte [gs:di], BORDER_COLOR
    inc di
    loop .top
        
    mov di, cursorPos(TOP_LEFT_X, BOTTOM_RIGHT_Y)
    mov cx, BOX_WIDTH
.bottom:
    mov byte [gs:di], 205
    inc di
    mov byte [gs:di], BORDER_COLOR
    inc di
    loop .bottom
        
    mov di, cursorPos(TOP_LEFT_X, TOP_LEFT_Y)
    mov cx, BOX_HEIGHT
.left:
    mov byte [gs:di], 186
    inc di
    mov byte [gs:di], BORDER_COLOR
    add di, ((SCREEN_WIDTH * 2) - 1)
    loop .left
        
    mov di, cursorPos(BOTTOM_RIGHT_X, TOP_LEFT_Y)
    mov cx, BOX_HEIGHT
.right:
    mov byte [gs:di], 186
    inc di
    mov byte [gs:di], BORDER_COLOR
    add di, ((SCREEN_WIDTH * 2) - 1)
    loop .right
        
    mov di, cursorPos(TOP_LEFT_X, TOP_LEFT_Y)
    mov byte [gs:di], 201
    mov di, cursorPos(BOTTOM_RIGHT_X, TOP_LEFT_Y)
    mov byte [gs:di], 187
    mov di, cursorPos(TOP_LEFT_X, BOTTOM_RIGHT_Y)
    mov byte [gs:di], 200
    mov di, cursorPos(BOTTOM_RIGHT_X, BOTTOM_RIGHT_Y)
    mov byte [gs:di], 188
    inc di
    mov byte [gs:di], BORDER_COLOR
    inc di
        
    pop si
    ; print the message in this loop
    mov di, cursorPos((TOP_LEFT_X+1), (TOP_LEFT_Y+1))
    mov ah, TEXT_COLOR
    xor bp, bp
.charLoop:
    mov al, byte [ds:si]
    inc si
    test al, al
    jz .inputLoop
    cmp al, 0x0D
    je .nl
    cmp al, 0x0A
    je .charLoop
    cmp al, '\'
    je .skip
    mov byte [gs:di], al
    add di, 2
    jmp .charLoop
.skip:
    inc si
    jmp .charLoop
.nl:
    mov di, cursorPos((TOP_LEFT_X+1), (TOP_LEFT_Y+1))
    xor dx, dx
    mov ax, bp
    mov bx, (SCREEN_WIDTH * 2)
    mul bx
    add di, ax
    inc bp
    jmp .charLoop
        
.inputLoop:
    ; wait one seconf
    SLEEP 100
.exit:
    pop gs
    popf
    popa
    ret

%undef TOP_LEFT_X
%undef TOP_LEFT_Y
%undef BOX_WIDTH
%undef BOX_HEIGHT
%undef BOTTOM_RIGHT_X
%undef BOTTOM_RIGHT_Y

