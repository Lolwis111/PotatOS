; ====================================================
; lists all the files in the root directory
; (including sizes)
; ====================================================
viewDirectory:
    pusha
    push es
    push ds
    
    mov dword [.fileSize], 0x00  ; init size to zero
    PRINT NEWLINE
    
    PRINT LS_LABEL_1 ; print Label1 (see language.asm)
    PRINT .spacer
    
    mov si, DIRECTORY_OFFSET
    xor ax, ax
    mov es, ax
    mov ds, ax
    cld
.fileLoop:
    push cx

    mov di, fileName            ; the first 11 bytes of each entry are the file name
    mov cx, 11                  ; so we copy that
    rep movsb
    
    mov al, byte [es:si]           ; after that are the attributes
    mov byte [.attributes], al
    
    cmp byte [argument], 0x00 ; check if only certain extensions should be PRINTed
    je .noFilter
    
    push si
    
    mov si, fileName            ; if yes, check the extension on each filename
    mov di, rFileName
    call AdjustFileName         ; convert file name
    
    mov cx, 3
    mov si, rFileName+8         ; check last 3 bytes (8.3 file names in fat12)
    mov di, argument
    repe cmpsb
    jne .skip                   ; if the extension does not match we skip this file
    
    pop si
.noFilter:
    add si, 17
    mov ecx, dword [es:si]         ; get the filesize from the entry
    add dword [.fileSize], ecx    ; add it to the size of the directory
    push si
    
    cmp byte [fileName], 0xE5 ; check if this is an invalid entry
    je .del
    cmp byte [fileName], 0x00 ; check if this is the last entry
    je .eod

    test byte [.attributes], 00010000b
    jnz .dir ; check if it is a directory
    
    LTOSTR .number, ecx         ; convert file size to string

    mov si, fileName            ; make filename more readable
    call ReadjustFileName

    PRINT ReadjustFileName.newFileName ; print that "readjusted" filename
    
    ; move cursor to X=19 in current row
    READCUR
    MOVECUR 19, dh

    PRINT .number ; print size in the next column print file size
    jmp .ok
    
.dir:
    PRINT fileName
    PRINT .ldir ; directorys get marked by "<dir>"
    
.ok:
    PRINT NEWLINE ; new line after each entry
    pop si
    jmp .next             ; goto to the next entry
.skip:                    ; this is were we jump if we want to skip an entry
    pop si              
    add si, 17 ; calculate address of next entry (32 bytes per entry)
    jmp .next
.del:
    pop si
.next:
    pop cx
    add si, 4

    dec cx
    jnz .fileLoop
    jmp .end
.eod:
    pop si
    pop cx
.end:
    PRINT LS_LABEL_2 ; print the label about the filesize

    LTOSTR .number, dword [.fileSize] ; convert directory size to string
    
    PRINT .number ; print directory size
    
    PRINT NEWLINE
    
    pop ds
    pop es
    popa
    jmp main
.number times 11 db 0x00
.spacer times 30 db 205
                 db "\r\n", 0x00
.fileSize dd 0x00000000
.attributes db 0x00
.ldir db "   <DIR>", 0x00
; ====================================================


