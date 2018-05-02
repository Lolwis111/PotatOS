; ======================================================
; DH -> Row (Y)
; DL -> Column (X)
; ======================================================
private_setCursorPosition:

    cmp dh, 0
    jb .clampY0
    cmp dh, 24
    ja .clampY24
    
    cmp dl, 0
    jb .clampX0
    cmp dl, 79
    ja .clampX79
    
.clampOK:

    movzx ax, dh
    movzx bx, dl

    mov byte [row], dh ; save the cursor for ourselfs
    mov byte [col], dl
    shl ax, 4          ; set the hardware cursor using vga registers
    add bx, ax
    shl ax, 2
    add bx, ax

    mov al, 0x0F
    mov dx, 0x3D4
    out dx, al
    
    mov ax, bx
    mov dx, 0x3D5
    out dx, al
    
    mov al, 0x0E
    mov dx, 0x3D4
    out dx, al
    
    mov ax, bx
    shr ax, 8
    mov dx, 0x3D5
    out dx, al
    
    ret
.clampY0:
    mov dh, 0x00
    jmp .clampOK
.clampY24:
    mov dh, 24
    jmp .clampOK
.clampX0:
    mov dl, 0x00
    jmp .clampOK
.clampX79:
    mov dl, 79
    jmp .clampOK
    
setCursorPosition: ; public wrapper
    call private_setCursorPosition
    iret
; ======================================================


; ======================================================
getCursorPosition:
    mov dh, byte [row] ; return the cursor positon
    mov dl, byte [col] ; 
    iret
; ======================================================