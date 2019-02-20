; ================================================
clearScreen:
    pusha
    xor bx, bx
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    MOVECUR 0, 0
    popa    
    ret
; ================================================


; ================================================
clearColor:
    pusha
    mov bx, 1
    mov cx, SCREEN_BUFFER_SIZE-1
.loop1:
    mov byte [gs:bx], TEXT_COLOR
    add bx, 2
    loop .loop1
    popa    
    ret
; ================================================


; ================================================
printString:
    pusha
    xor cx, cx
.loop:
    ;mov al, byte [si]
    ;inc si
    lodsb
    test al, al
    jz .return
    mov byte [gs:di], al
    inc di
    mov byte [gs:di], ah
    inc di
    inc cx
    jmp .loop
.return:
    popa
    ret
; ================================================


; ================================================
; save a copy of the diretory as to not mess
; up the console
; ================================================
backupDir:
    push ds
    push es
    mov ax, DIRECTORY_SEGMENT
    mov ds, ax
    mov ax, backup
    shl ax, 4
    mov es, ax

    xor di, di
    xor si, si
    mov cx, 0x0500
    rep movsd

    pop es
    pop ds
    ret
; ================================================


; ================================================
; copy the directory back to the original location
; ================================================
restoreDir:
    push ds
    push es
    mov ax, DIRECTORY_SEGMENT
    mov es, ax
    mov ax, backup
    shl ax, 4
    mov ds, ax

    xor di, di
    xor si, si
    mov cx, 0x0500
    rep movsd

    pop es
    pop ds
    ret
; ================================================


; ================================================
; save the segments
; ================================================
backupSegments:
    mov ax, es
    mov word [segments], ax
    mov ax, ds
    mov word [segments+2], ax
    mov ax, gs
    mov word [segments+4], ax
    mov ax, fs
    mov word [segments+6], fs
    ret
restoreSegments:
    mov ax, word [segments]
    mov es, ax
    mov ax, word [segments+2]
    mov ds, ax
    mov ax, word [segments+4]
    mov gs, ax
    mov ax, word [segments+6]
    mov fs, ax
    ret
segments dw 0x0000, 0x0000, 0x0000, 0x0000
; ================================================

