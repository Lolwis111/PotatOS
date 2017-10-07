;================================================
; BackupDispBuffer
; kopiert den aktuell angezeigen Bildbereich an
; die durch DISP_BACKUP definierte Adresse
;================================================
backupDispBuffer:
	pusha
	
	xor di, di
	mov cx, SCREEN_BUFFER_SIZE
	mov si, DISP_BACKUP
.words:
	mov ax, word [gs:di]
	add di, 2
	mov word [si], ax
	add si, 2
	
	sub cx, 1
	jnz .words
	
	popa
	ret
;================================================


;================================================
; BackupDispBuffer
; kopiert den an der Adresse DISP_BACKUP
; liegenden Bildbereich zurück auf den Bildschirm
;================================================
restoreDispBuffer:
	pusha
	
	xor di, di
	mov cx, SCREEN_BUFFER_SIZE
	mov si, DISP_BACKUP
.words:
	mov ax, word [si]
	add si, 2
	mov word [gs:di], ax
	add di, 2
	
	sub cx, 1
	jnz .words
	
	popa
	ret
;================================================


;================================================
; hide cursor
; hides the cursor
;================================================
hideCursor:
    pushf
    push ax
    push dx
    
    mov dx, 0x03D4
    mov al, 0x0A
    out dx, al
    
    inc dx
    mov al, 0x3F ; disable cursor
    out dx, al
    
    pop dx
    pop ax
    popf
    ret
;================================================


;================================================
; show cursor
; shows the cursor
;================================================
showCursor:
    pushf
    push ax
    push dx
    
    mov dx, 0x03D4
    mov al, 0x0A
    out dx, al
    
    inc dx
    mov al, 0x6F ; enable cursor
    out dx, al
    
    pop dx
    pop ax
    popf
    ret
;================================================


;==========================================
;ClearScreen
;==========================================
cls:
	pusha
	
	xor bx, bx
	mov cx, (SCREEN_WIDTH * SCREEN_HEIGHT) * 2
.loop1:
	mov word [gs:bx], dx
	add bx, 2
	loop .loop1
	
	popa
	ret
;==========================================
