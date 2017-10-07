; ====================================================
; lists all the files in the root directory
; (including sizes)
; ====================================================
view_dir:
    mov dword [data.fileSize], 0x00  ; init size to zero
    print newLine
    
    print LS_LABEL_1            ; print Label1 (see language.asm)
    print data.spacer3
    
    mov ah, 0x11
    int 0x21                    ; load root directory
    
    xor ax, ax
    mov si, bp                  ; set start address
    mov es, ax
    cld
.fileLoop:
    push cx

    mov di, fileName            ; the first 11 bytes of each entry are the file name
    mov cx, 11                  ; so we copy that
    rep movsb
    
    mov al, byte [si]           ; after that are the attributes
    mov byte [data.attributes], al
    
    cmp byte [cmdargument], 0x00 ; check if only certain extensions should be printed
    je .noFilter
    
    push si
    
    mov si, fileName            ; if yes, check the extension on each filename
    mov di, rFileName
    call AdjustFileName         ; convert file name
    
    mov cx, 3
    mov si, rFileName           ; check last 3 bytes (8.3 file names in fat12)
    mov di, cmdargument
    add si, 8
    rep cmpsb
    jne .skip                   ; if the extension does not match we skip this file
    
    pop si
.noFilter:
    add si, 17
    mov ecx, dword [si]         ; get the filesize from the entry
    add dword [data.fileSize], ecx    ; add it to the size of the directory
    push si
    mov si, fileName
    lodsb
    
    cmp al, 0xE5                ; check if this is an invalid entry
    je .del
    cmp al, 0x00                ; check if this is the last entry
    je .eod
    
    ltostr data.number, ecx         ; convert file size to string

    mov si, fileName            ; make filename more readable
    call ReadjustFileName

    print di ; print filename
    
    test byte [data.attributes], 00010000b
    jnz .dir ; check if it is a directory
    
    mov ah, 0x0F  ; move cursor to X=19 in current row
    int 0x21
    mov dl, 19
    mov ah, 0x0E
    int 0x21

    print data.number ; print size in the next column print file size
    jmp .ok
    
.dir:
    print ldir ; directorys get marked by "<dir>"
    
.ok:
    print newLine ; new line after each entry
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
    print LS_LABEL_2 ; print the label about the filesize

    ltostr data.number, dword [data.fileSize] ; convert directory size to string
    
    print data.number ; print directory size
    
    print newLine
    
    jmp main
; ====================================================
    
data:
.number db "0000000000", 0x00, 0x00
.spacer3 times 30 db 205
                  db "\r\n", 0x00
.fileSize dd 0x00000000
.attributes db 0x00
; ====================================================
