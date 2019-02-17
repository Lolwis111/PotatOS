; ================================================
printFiles:
    ; save registers
    pusha
    push es
    push ds
    
    ; set the segments
    ; SI points to directory
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov si, DIRECTORY_OFFSET
    
    ; move SI, so the ones that got scrolled
    ; out of the display will be skipped
    xor dx, dx
    movzx ax, byte [entriesToSkip]
    mov bx, 32
    mul bx
    add si, ax
    
    ; move cursor
    mov di, cursorPos(5, 1)
    
    xor cx, cx
.fileLoop:
    ; 0x00 indicates end of directory
    cmp byte [es:si], 0x00
    je .endOfDir
    
    ; 0xE5 indicates that the file got deleted
    cmp byte [es:si], 0xE5
    je .skipEntry
    
    push si
    push cx
    push di
    
    ; fill the fileEntry line with spaces
    mov cx, 30
    mov ax, 0x2020
    mov di, fileEntryLine
    rep stosw

    ; copy the attributes from the entry
    mov al, byte [es:si+11]
    mov byte [.attributes], al
    
    ; adjust filename so it is not that ugly
    ; call ReadjustFileName
    ; add si, 11
    
    ; test if the entry is another directory
    test byte [.attributes], 00010000b ; check if it is a directory
    jz .itsAFile

.itsADirectory:
    push di

    mov cx, 11
    mov al, '.'
    repnz scasb     ; try to find the dot
    jcxz .popDIDir ; if no dot is found its ok
    
    cmp byte [di], 0x20 ; if there are chars after dot its ok too
    jne .popDIDir
    
    mov byte [di-1], 0x20 ; but else we delete the dot
    
.popDIDir:
    pop di
.itsAFile:
    push si
    
    ;mov si, di
    mov di, fileEntryLine
    mov cx, 11
    rep movsb
.copyFileNameDone:
    pop si
    
    pop di    
    
    mov al, byte [es:si] ; copy the attributes
    mov byte [.attributes], al
    
    ltostr fileSizeString, dword [es:si+17]
    
    push si
    push di
    
    mov ax, word [es:si+13]
    push word [es:si+11]
    
    call convertDate
    mov di, fileEntryLine+33
    mov cx, 10
    rep movsb
    
    pop ax
    call convertTime
    mov di, fileEntryLine+44
    mov cx, 8
    rep movsb
    
    ; buggy, better not use this for now
    ;test byte [.attributes], 00010000b ; check if it is a directory
    ;jnz .itsADirectory2
    
    mov di, fileEntryLine+20
    mov si, fileSizeString
.copyFileSizeString:
    lodsb
    test al, al
    jz .copyFileSizeStringOK
    stosb
    jmp .copyFileSizeString
;.itsADirectory2:
;    mov dword [fileEntryLine+20], '<DIR'
;    mov byte [fileEntryLine+24], '>'
.copyFileSizeStringOK:
    pop di
        
    mov ah, TEXT_COLOR
    mov si, fileEntryLine
    call printString
    
    pop si
    
    pop cx
    inc cx
    
    add di, (SCREEN_WIDTH*2)
    
    pop si
    
    cmp cx, 23
    je .endOfDir
    
.skipEntry:
    add si, 32
    
    jmp .fileLoop
.endOfDir:
    pop ds
    pop es
    popa
    ret
.attributes db 0x00
; ================================================  
