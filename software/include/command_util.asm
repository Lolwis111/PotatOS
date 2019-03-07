; ====================================================
; shows the help string
; ====================================================
view_help:
    PRINT HELP
    
    jmp main
; ====================================================


; ====================================================  
show_version:
    PRINT NEWLINE
    
    PRINT NEWLINE
    
    PRINT .lblName
    
    PRINT .lblVersion
    
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
    
    PRINT NEWLINE

    mov ah, 0x0C
    int 0x21
    push bx
    PRINT ax

    PRINT NEWLINE

    pop bx

    PRINT bx
    
    PRINT NEWLINE

    call show_cpuid_features

    PRINT NEWLINE
    
    jmp main

.lblVersion db "Version: ", 0x00
.lblName    db "PotatOS (C)", DEV_YEAR_S, "-", DEV_YEAR_C, "\n\r", 0x00
.number     db "00000", 0x00, 0x00, 0x00
;====================================================


; ====================================================
PRINT_return_code:
    PRINT NEWLINE   ; prints the return code of the last executed command
    
    ITOSTR .errCodeStr, word [ERROR_CODE]
    
    PRINT .errCodeStr
    
    PRINT NEWLINE

    jmp main
.errCodeStr db "00000", 0x00
; ====================================================
