; ======================================================
; DX -> String
; BL -> Color
; ======================================================
printString: ; public wrapper
    call private_printString
    iret

private_printString:
    mov si, dx  ; copy string to source register
    mov dl, bl  ; copy color
.charLoop: ; read the string char by char and only stop when \0 appears
    lodsb       

    test al, al 
    jz .end
    
    cmp al, '\'         ; check if an escape character was entered (\n, \r, etc.)
    je .checkEscapeChar
    
.print:
    mov dh, al
    call private_printChar ; each char is printed seperatly
    
    jmp .charLoop
.checkEscapeChar:
    lodsb
    
    test al, al
    jz .end
    
    cmp al, '\'
    je .slashBackslash
    
    cmp al, 'n'
    je .slashN
    
    cmp al, 'r'
    je .slashR

    cmp al, 'b'
    je .backSlash
    
    cmp al, 't'
    je .tabSlash
    
    cmp al, '0'
    je .slash0
    
    jmp .charLoop
    
.slashBackslash:
    mov al, '\'
    jmp .print
.slashN:
    mov al, 0x0A
    jmp .print
.slashR:
    mov al, 0x0D
    jmp .print
.slash0:
    xor al, al
    jmp .print
.backSlash:
    mov al, 0x08
    jmp .print
.tabSlash:
    mov al, 0x09
    jmp .print
    
.end:
    ; adjust cursor position at the end
    mov dh, byte [row]
    mov dl, byte [col]
    call private_setCursorPosition
    ret
; ======================================================    

    
; ======================================================    
printCharC: ; public wrapper
    call private_printChar
    iret
    
private_printChar:
    push gs
    push dx

    ; calculate address in memory that belongs to cursor positon
    mov ax, VIDEO_MEMORY_SEGMENT
    mov gs, ax                
    movzx bx, byte [col]   ; forumla: (x * 2) + (y * SCREEN_WIDTH)
    movzx ax, byte [row]
    shl bx, 1
    ; mul 160
    mov cx, SCREEN_WIDTH*2
    mul cx
    add bx, ax

    pop dx
    
    cmp dh, 0x0D ; \n and \r are handled differently
    je .cr
    cmp dh, 0x0A
    je .lf
    ; cmp dh, 0x00
    ; je .done
    
    mov byte [gs:bx], dh    ; write the char and the color to vga memory
    mov byte [gs:bx+1], dl
    add bx, 2
    
    inc byte [col]
    ; when we reach the right end of 
    ; the screen we goto to the next line
    cmp byte [col], (SCREEN_WIDTH)
    je .newLine 
.done:
    pop gs
    ret

.newLine:
    mov byte [col], 0x00 ; move cursor to the left border
    inc byte [row]       ; increment linenumber
    
    ; when we are at the very bottom we move the whole buffer one row up
    cmp byte [row], (SCREEN_HEIGHT-1)
    jae .moveBuffer
    pop gs
    ret

.cr:
    mov byte [col], 0x00 ; \r just jumps to the left border
    pop gs
    ret

.lf:
    inc byte [row]      ; move cursor one row down
    cmp byte [row], (SCREEN_HEIGHT-1)
    jae .moveBuffer     ; we reach the bottom -> we scroll
    pop gs
    ret

.moveBuffer:
    push si
    push es
    push ds

    ; copy the whole vga memory (beginning at line 2)
    ; one line up
    mov byte [row], (SCREEN_HEIGHT-2)
    
    mov ax, VIDEO_MEMORY_SEGMENT
    mov es, ax
    mov ds, ax
    mov si, (SCREEN_WIDTH*2)
    xor di, di
    mov cx, (SCREEN_BUFFER_SIZE - SCREEN_WIDTH)
    rep movsw
    
    pop ds
    pop es
    pop si
    pop gs
    ret
; ======================================================
