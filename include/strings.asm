; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % simple methods for manipulating string       %
; % Can be used by anyone who includes this file %
; % Needs stos, lods and movs instructions       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _STRINGS_INC_
%define _STRINGS_INC_

; ==========================================
; convert 'TEST.BIN' to 'TEST    BIN'
; DS:SI => human filename
; ES:DI <= FAT12 filename
; ==========================================
AdjustFileName:
    xor cx, cx
.copy:
    lodsb
    cmp al, '.'
    je .extension
    cmp al, 00h
    je .error
    
    stosb
    inc cx
    jmp .copy
    
.extension:
    cmp cx, 8
    je .copyExtension
    
.addSpaces:
    mov byte [es:di], ' '
    inc di
    inc cx
    cmp cx, 8
    jl .addSpaces
.copyExtension:
    movsb
    movsw
    xor ax, ax
    ret
.error:
    mov ax, -1
    ret
; ==========================================


; ==========================================
; convert "TEST" to "TEST       "
; DS:SI => human directory name
; ES:DI <= FAT12 directory name
; ==========================================
AdjustDirName:
    push cx
    push si
    push di
    push ax

    xor cx, cx
.copy:
    lodsb
    test al, al
    jz .extension
    
    stosb
    inc cx
    jmp .copy
    
.extension:
    cmp cx, 11
    jl .addSpaces
    
.addSpaces:
    ; 0x20 is space
    mov byte [es:di], 0x20
    inc di
    inc cx
    cmp cx, 11
    jl .addSpaces
    
    pop ax
    pop di
    pop si
    pop cx
    ret
; ==========================================


; ==========================================
; convert string to uppercase letters
; DS:SI => String
; ==========================================
UpperCase:
    push si
.loop1:
    cmp byte [ds:si], 0x00
    je .return
    
    cmp byte [ds:si], 'a'
    jb .noatoz
    cmp byte [ds:si], 'z'
    ja .noatoz
    
    sub byte [ds:si], 0x20
    inc si
    
    jmp .loop1
.return:
    pop si
    ret
.noatoz:
    inc si
    jmp .loop1
; ==========================================


; ==========================================
; DS:SI <= string
; CX => length
; ==========================================
StringLength2:
    pushf
    push si
    push ax
    
    xor cx, cx
    cld
.charLoop:
    lodsw
    test al, al
    jz .end1
    test ah, ah
    jz .end2
    add cx, 2
    jmp .charLoop
.end2:
    inc cx    
.end1:
    pop ax
    pop si
    popf
    ret
; ==========================================


; ==========================================
; DS:SI -> String
; AL -> Splitter
; CX <- length
; ==========================================
StringLength:
    push ax
    push si

    xor cx, cx
.charLoop:
    cmp byte [ds:si], al
    je .ok
    cmp byte [ds:si], 0x00
    je .noOk
    inc si
    inc cx
    jmp .charLoop
.ok:
    pop si
    pop ax
    ret
.noOk:
    pop si
    pop ax
    xor cx, cx
    ret
; ==========================================


; ==========================================
; looks for the very first space (to parse arguments)
; DS:SI => String
; CX <= Index
; ==========================================
fileNameLength:
    push ax
    push si

    xor cx, cx
.loop1:
    lodsb
    or al, al
    jz .error
    cmp al, ' '
    je .done
    inc cx
    jmp .loop1
.error:
    mov cx, -1
.done:
    pop si
    pop ax
    ret
.noArgs db "NO ARGUMENT", 0Dh, 0Ah, 00h
; ==========================================


; ==========================================
; convert 'TEST    BIN' to
; 'TEST.BIN'
; DS:SI <= FAT filename
; ES:DI => human filename
; ==========================================
ReadjustFileName:
    push cx
    push ax
    push si
    
    mov di, .newFileName
    mov cx, 8
.scan: ; copy up to first space or 8 characters (whatever comes first)
    cmp byte [ds:si], 0x20
    je .return
    movsb
    loop .scan
.return:
    mov al, '.' ; insert the dot between name and extension
    stosb
    add si, cx  ; skip spaces
    movsw       ; copy the last three characters
    movsb       ; (extension)
    xor al, al  ; put \0 at the end
    stosb
    
    pop si
    pop ax
    pop cx
    mov di, .newFileName
    ret
.newFileName times 13 db 0x00
; ==========================================


; ==========================================
; skip leading whitespaces
; (spaces, \t, \n and \r)
;
; DS:SI <= string
; DS:SI => trimmed string
; ==========================================
TrimLeft:
    push ax
    pushf
    
    cld
.charLoop:
    lodsb    ; load a character
    
    ; check if it is a whitespace (and if yes repeat this)
    cmp al, 0x20 ; space
    je .charLoop
    cmp al, 0x08 ; tab
    je .charLoop
    cmp al, 0x0D ; \r
    je .charLoop    
    cmp al, 0x0A ; \n
    je .charLoop
    
.return:    ; if the character is no whitespace we return
    dec si  ; therefore we adjust si because lodsb increments si
            ; before we know if we actually need to skip or not
    popf
    pop ax
    ret
; ==========================================


; ==========================================
; remove trailing whitespaces
; (spaces, \t, \n and \r)
; DS:SI <= String
; DS:SI => trimmed string
; ==========================================
TrimRight:
    pushf
    push si
    push ax
    
    cld ; clear direction flag to move forwards
.gotoEnd:
    lodsb
    test al, al
    jz .endFound
    jmp .gotoEnd

.endFound:
    dec si
    dec si
.trim:
    mov al, byte [ds:si]
    
    ; the first non-whitespace ends this loop
    cmp al, 0x20 ; check space
    je .remove
    
    cmp al, 0x08 ; check tab
    je .remove
    
    cmp al, 0x0D ; check \r
    je .remove
    
    cmp al, 0x0A ; check \n
    je .remove
    
    jmp .return
.remove:
    mov byte [ds:si], 0x00 ; override trailing whitespaces with \0
    dec si
    jmp .trim
    
.return:
    pop ax
    pop si
    popf
    ret
; ==========================================


; ==========================================
; append string 1 to string 2
;
; DS:SI <= string 1
; ES:DI <= string 2
; AL <= end on this char
; CX => number bytes appended
; ==========================================
AppendString:
    pushf
    push ax
    push si
    push di
    cld
.gotoEndOfSILoop:
    cmp byte [es:di], al
    je .endFound
    inc di
    jmp .gotoEndOfSILoop
.endFound:
    xor cx, cx
.copyLoop:
    lodsb
    test al, al
    jz .copyDone
    stosb
    inc cx
    jmp .copyLoop
.copyDone:
    stosb 
    pop di
    pop si
    pop ax
    popf
    ret
; ==========================================
%endif
