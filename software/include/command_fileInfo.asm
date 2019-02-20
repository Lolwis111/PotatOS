; ====================================================
PRINT_file_info:
    pusha
    push es
    push ds

    ; set up the segments 
    xor ax, ax
    mov es, ax
    mov ds, ax

    ; convert the filename
    mov si, argument
    mov di, .filenameFAT
    call AdjustFileName

    ; look for a file with the given name
    mov ah, 0x13
    mov dx, .filenameFAT
    int 0x21
    cmp ax, -1
    je .notFound

    mov si, DIRECTORY_OFFSET
    shl ax, 5
    add si, ax
    mov di, .entry
    mov cx, 16
    rep movsw

    PRINT NEWLINE
    
    ; convert the filesize to a string
    LTOSTR .fileSizeString, dword [.entry+28]
    
    ; convert the date into a human readable format
    mov ax, word [.entry+24]
    call fat12_convertDate
   
    mov di, .lblTimeDate2
    mov cx, 5
    rep movsw

    mov bl, byte [.entry+10]
    call fat12_parseAttributes
    mov di, .lblAttr2
    mov cx, 4
    rep movsb

    PRINT NEWLINE
    PRINT .lblAttr
    
    ; convert the time into a human readable format
    mov ax, word [.entry+22]
    call fat12_convertTime
    
    mov di, .lblTimeDate2+11
    mov cx, 4
    rep movsw

    PRINT NEWLINE
    PRINT .lblSize
    PRINT .fileSizeString
    PRINT NEWLINE
    PRINT .lblTimeDate
    PRINT NEWLINE

    jmp .end

.notFound:
    PRINT FILE_NOT_FOUND_ERROR
.end:
    PRINT NEWLINE
    pop ds
    pop es
    popa

    jmp main
.entry times 32 db 0x00
.filenameFAT times 14 db 0x00
.fileSizeString times 11 db 0x00
.lblAttr db "Attributes: "
    .lblAttr2 times 10 db 0x00
.lblSize db "Size: ", 0x00
.lblTimeDate db "Last accessed: "
    .lblTimeDate2 times 20 db 0x20
                           db 0x00
; ====================================================
