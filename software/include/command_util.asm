; ====================================================
; shows the help string
; ====================================================
view_help:
    print HELP
    
    jmp main
; ====================================================


; ====================================================  
show_version:
    print NEWLINE
    
    print NEWLINE
    
    print .lblName
    
    print .lblVersion
    
    mov ah, 0x08
    int 0x21
    ; AH -> Majorversion
    ; AL -> Minorversion
    push ax
    
    mov dh, ah
    add dh, 48
    mov dl, byte [SYSTEM_COLOR]
    mov ah, 0x10
    int 0x21
    
    mov dh, '.'
    mov dl, byte [SYSTEM_COLOR]
    mov ah, 0x10
    int 21h
    
    pop ax
    
    mov dh, al
    add dh, 48
    mov dl, byte [SYSTEM_COLOR]
    mov ah, 0x10
    int 0x21
    
    print NEWLINE

    mov ah, 0x0C
    int 0x21
    push bx
    print ax

    print NEWLINE

    pop bx

    print bx
    
    print NEWLINE
    
    jmp main

.lblVersion db "Version: ", 0x00
.lblName    db "PotatOS (C)", DEV_YEAR_S, "-", DEV_YEAR_C, "\n\r", 0x00
.number     db "00000", 0x00, 0x00, 0x00
;====================================================


; ====================================================
print_return_code:
    print NEWLINE   ; prints the return code of the last executed command
    
    itostr .errCodeStr, word [ERROR_CODE]
    
    print .errCodeStr
    
    print NEWLINE

    jmp main
.errCodeStr db "00000", 0x00
; ====================================================