; ====================================================
show_time: ; shows the time (e.g. 12:04 Uhr)
    PRINT NEWLINE
    
    mov ah, 0x06
    int 0x21

    mov ah, 0x01
    mov bl, byte [SYSTEM_COLOR]
    int 0x21
    
    PRINT NEWLINE

    jmp main
; ====================================================
    

; ====================================================
show_date: ; shows the date (e.g. 12.03.2014)
    PRINT NEWLINE
    
    mov ah, 0x07
    int 0x21
    
    mov bl, byte [SYSTEM_COLOR]
    mov ah, 0x01
    int 0x21

    PRINT NEWLINE

    jmp main
; ====================================================