; ====================================================
; Listet alle Dateien auf der Diskette auf
; ====================================================
view_dir:
	mov word [.fileSize], 00h
	mov ah, 01h
	mov bl, byte [0x1FFF]
	mov dx, newLine
	int 21h
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, LS_LABEL_1
	int 21h
	
	
	mov ah, 11h
	int 21h						; Stammverzeichnis laden
	
	xor ax, ax
	mov si, bp					; Startadresse Stammverzeichnis
	mov es, ax
	cld
.fileLoop:
	push cx
	
	mov di, fileName
	mov cx, 11
	rep movsb
	
	mov al, byte [si]
	mov byte [.attributes], al
	
	cmp byte [cmdargument], 00h
	je .noFilter
	
	push si
	
	mov si, fileName
	mov di, rFileName
	call AdjustFileName
	mov cx, 3
	mov si, rFileName
	mov di, cmdargument
	add si, 8
	rep cmpsb
	jne .skip
	
	pop si
.noFilter:
	add si, 17
	mov ecx, dword [si]
	add word [.fileSize], cx
	push si
	mov si, fileName
	lodsb
	cmp al, 0xE5
	je .del
	cmp al, 0x00
	je .eod
	mov ah, 03h
	mov dx, .number
	int 21h

	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, fileName
	int 21h
	
	test byte [.attributes], 00010000b
	jnz .dir
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, spacer
	int 21h
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, .number
	int 21h
	jmp .ok
	
.dir:
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, ldir
	int 21h
	
.ok:
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	pop si
	jmp .next
.skip:
	pop si
	add si, 17
	jmp .next
.del:
	pop si
.next:
	pop cx
	add si, 4					; 32 Byte pro Eintrag
	
	dec cx
	cmp cx, 00h
	jne .fileLoop
	jmp .end
.eod:
	pop si
	pop cx
.end:
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, LS_LABEL_2
	int 21h

	mov cx, word [.fileSize]
	mov ah, 03h
	mov dx, .number
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, .number
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	jmp main
.number db "00000", 00h
.fileSize dw 0000h
.attributes db 00h
; ====================================================


; ====================================================
; Gibt alle Dateinamen einfach aus
; ====================================================
view_dir_2:
	mov word [.fileSize], 00h
	mov ah, 01h
	mov bl, byte [0x1FFF]
	mov dx, newLine
	int 21h
	
	mov ah, 11h
	int 21h						; Stammverzeichnis laden
	
	xor ax, ax
	mov si, bp					; Startadresse Stammverzeichnis
	mov es, ax
	cld
.fileLoop:
	push cx
	
	mov di, fileName
	mov cx, 11
	rep movsb
	
	mov al, byte [si]
	mov byte [.attributes], al
	add si, 17
	mov ecx, dword [si]
	add word [.fileSize], cx
	push si
	mov si, fileName
	lodsb
	cmp al, 0xE5
	je .del
	cmp al, 0x00
	je .eod

	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, fileName
	int 21h
	
    mov bl, byte [0x1FFF]
    mov ah, 01h
    mov dx, spacer2
    int 21h

	test byte [.attributes], 00010000b
	jnz .dir

	jmp .ok
	
.dir:
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, ldir
	int 21h
	
.ok:
	pop si
	jmp .next
.skip:
	pop si
	add si, 17
	jmp .next
.del:
	pop si
.next:
	pop cx
	add si, 4					; 32 Byte pro Eintrag
	
	dec cx
	cmp cx, 00h
	jne .fileLoop
	jmp .end
.eod:
	pop si
	pop cx
.end:

    mov bl, byte [0x1FFF]
    mov ah, 01h
    mov dx, newLine
    int 21h

	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, LS_LABEL_2
	int 21h

	mov cx, word [.fileSize]
	mov ah, 03h
	mov dx, .number
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, .number
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	jmp main
.number db "00000", 00h
.fileSize dw 0000h
.attributes db 00h
; ====================================================
