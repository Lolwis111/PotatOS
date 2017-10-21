; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % simple methods for manipulating string       %
; % Can be used by anyone who includes this file %
; % Needs stos, lods and movs instructions       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _STRINGS_INC_
%define _STRINGS_INC_

; ==========================================
; convert 'TEST.BIN' to 'TEST    BIN'
; si => human filename
; di <= FAT12 filename
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
	mov byte [di], ' '
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
; si => human directory name
; di <= FAT12 directory name
; ==========================================
AdjustDirName:
	xor cx, cx
.copy:
	lodsb
	cmp al, 00h
	je .extension
	
	stosb
	inc cx
	jmp .copy
	
.extension:
	cmp cx, 11
	jl .addSpaces
	
.addSpaces:
	mov byte [di], ' '
	inc di
	inc cx
	cmp cx, 11
	jl .addSpaces
	xor ax, ax
	ret
.error:
	mov ax, -1
	ret
; ==========================================


; ==========================================
; convert string to uppercase letters
; SI => String
; ==========================================
UpperCase:
.loop1:
	cmp byte [si], 00h
	je .return
	
	cmp byte [si], 'a'
	jb .noatoz
	cmp byte [si], 'z'
	ja .noatoz
	
	sub byte [si], 20h
	inc si
	
	jmp .loop1
.return:
	ret
.noatoz:
	inc si
	jmp .loop1
; ==========================================


; ==========================================
; SI -> String
; AL -> Splitter
; CX <- length
; ==========================================
StringLength:
	push bx
	push dx
	push bp
	xor cx, cx
.charLoop:
	cmp byte [si], al
	je .ok
	cmp byte [si], 0x00
	je .noOk
	inc si
	inc cx
	jmp .charLoop
.ok:
	pop bp
	pop dx
	pop bx
	ret
.noOk:
	pop bp
	pop dx
	pop bx
	xor cx, cx
	ret
; ==========================================


; ==========================================
; looks for the very first space (to parse arguments)
; SI => String
; CX <= Index
; ==========================================
fileNameLength:
	push bx
	push dx
	push bp
	xor cx, cx
.loop1:
	lodsb
	or al, al
	jz .error
	cmp al, ' '
	je .done
	inc cx
	jmp .loop1
.done:
	pop bp
	pop dx
	pop bx
	ret
.error:
	pop bp
	pop dx
	pop bx
	mov cx, -1
	ret
	
.noArgs		db "NO ARGUMENT", 0Dh, 0Ah, 00h
; ==========================================


; ==========================================
; convert 'TEST    BIN' to
; 'TEST.BIN'
; SI <= FAT filename
; DI => human filename
; ==========================================
ReadjustFileName:
    pusha
    
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
    
    popa
    ret
.newFileName times 13 db 0x00
; ==========================================


; ==========================================
; skip leading whitespaces
; (spaces, \t, \n and \r)
;
; DS:SI => string
; DS:SI <= trimmed string
; ==========================================
TrimLeft:
	push ax
	pushf
	
	cld
.charLoop:
	lodsb	; load a character
	
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


%endif
