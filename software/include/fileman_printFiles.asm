%include "fat12/file.asm"
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

    ; copy the entry into a local buffer
    ; for convience 
    mov di, .currentEntry
    mov cx, 16
    rep movsw
    
    ; fill the fileEntry line with spaces
    mov cx, 37
    mov ax, 0x2020
    mov di, .fileEntryLine
    rep stosw

    ; copy the attributes from the entry
    mov al, byte [.currentEntry+11]
    mov byte [.attributes], al

    ; test if the entry is another directory
    test byte [.attributes], 00010000b
    ; if no, go to the file section
    jz .itsAFile
.itsADirectory:
    ; directory names just get copied
    mov si, .currentEntry
    mov di, .fileEntryLine
    mov cx, 11
    rep movsb
    jmp .copyFileNameDone
.itsAFile: 
    ; adjust filename so it is not that ugly
    mov si, .currentEntry
    call ReadjustFileName
    ; copy the filename into the fileentry
    mov si, di 
    mov di, .fileEntryLine
.copyFileNameLoop:
    lodsb
    test al, al
    jz .copyFileNameDone
    stosb
    jmp .copyFileNameLoop
.copyFileNameDone:
    ; jum here when the copy is done
    pop di    
    
    ; convert the filesize to a string
    LTOSTR fileSizeString, dword [.currentEntry+28]
    
    push si
    push di
    
    ; convert the date into a human readable format
    mov ax, word [.currentEntry+24]
    call fat12_convertDate
    mov di, .fileEntryLine+33
    mov cx, 5
    rep movsw
    
    ; convert the time into a human readable format
    mov ax, word [.currentEntry+22]
    call fat12_convertTime
    mov di, .fileEntryLine+44
    mov cx, 8
    rep movsb

    mov byte [.fileEntryLine+53], 0x20
    mov bl, byte [.attributes]
    call fat12_parseAttributes
    mov cx, 7
    mov di, .fileEntryLine+54
    rep movsb
    
    test byte [.attributes], 00010000b ; check if it is a directory
    jnz .itsADirectory2
    
    mov di, .fileEntryLine+20
    mov si, fileSizeString
.copyFileSizeString:
    lodsb
    test al, al
    jz .copyFileSizeStringOK
    stosb
    jmp .copyFileSizeString
.itsADirectory2:
    ; directories dont really have a size,
    ; so we print <DIR> instead
    mov dword [.fileEntryLine+20], '<DIR'
    mov byte [.fileEntryLine+24], '>'
.copyFileSizeStringOK:
    pop di
        
    mov ah, TEXT_COLOR
    mov si, .fileEntryLine
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
.fileEntryLine times 74 db 0x20
                        db 0x00
.currentEntry times 32 db 0x00
.attributes db 0x00
; ================================================  
