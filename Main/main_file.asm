; ====================================================
; Löscht eine Datei
; ====================================================
delete_file:
	mov si, cmdargument
	mov di, rFileName
	call AdjustFileName
	cmp ax, -1
	je .notFound
	
	mov si, rFileName
	mov di, invalidFiles
	mov cx, 11
	rep cmpsb
	je .invalid
	
	mov di, invalidFiles
	add di, 11
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid

	mov di, invalidFiles
	add di, 22
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid
	
	mov di, invalidFiles
	add di, 33
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid
	
	mov ah, 13h
	mov dx, rFileName
	int 21h
	cmp ax, -1
	je .notFound
	
	mov ah, 0Ah
	mov dx, rFileName
	int 21h
	
.return:
	mov ah, 01h
	mov bl, byte [0x1FFF]
	mov dx, newLine
	int 21h
	jmp main
.invalid:
	mov bl, byte [0x1FFF]
	mov dx, WRITE_PROTECTION_ERROR
	mov ah, 01h
	int 21h
	jmp .return
.notFound:
	mov bl, byte [0x1FFF]
	mov dx, FILE_NOT_FOUND_ERROR
	mov ah, 01h
	int 21h
	jmp .return
; ====================================================
	

; ====================================================
; Benennt eine Datei um	
; ====================================================
rename_file:
	mov si, cmdargument
	call fileNameLength
	push cx
	mov si, cmdargument
	mov di, fileName
	rep movsb
	
	mov si, fileName
	mov di, rFileName
	call AdjustFileName
	cmp ax, -1
	je .notFound
	
	mov si, rFileName
	mov di, invalidFiles
	mov cx, 11
	rep cmpsb
	je .invalid
	
	mov di, invalidFiles
	add di, 11
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid

	mov di, invalidFiles
	add di, 22
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid
	
	mov di, invalidFiles
	add di, 33
	mov si, rFileName
	mov cx, 11
	rep cmpsb
	je .invalid
	
	pop cx
	mov si, cmdargument
	add si, cx
	mov di, fileName
	inc si
.copyLoop:
	cmp byte [si], 00h
	je .done
	movsb
	jmp .copyLoop
	
.done:
	mov si, fileName
	mov di, rArgument
	call AdjustFileName
	cmp ax, -1
	je .notFound
	
	mov ah, 13h
	mov dx, rArgument
	int 21h
	cmp ax, -1
	jne .badFileName
	
	mov ah, 11h
	int 21h
	mov di, bp
.fileLoop:
	push cx
	mov si, rFileName
	mov cx, 11
	push di
	rep cmpsb
	pop di
	je .Found
	pop cx
	add di, 20h
	loop .fileLoop
.notFound:
	mov bl, byte [0x1FFF]
	mov dx, FILE_NOT_FOUND_ERROR
	mov ah, 01h
	int 21h
	jmp .return
.badFileName:
	mov bl, byte [0x1FFF]
	mov dx, FILE_ALREADY_EXISTS_ERROR
	mov ah, 01h
	int 21h
	jmp .return
.invalid:
	mov bl, byte [0x1FFF]
	mov dx, WRITE_PROTECTION_ERROR
	mov ah, 01h
	int 21h
	jmp .return
.Found:
	pop cx
	mov si, rArgument
	mov cx, 11
	rep movsb
	mov ah, 12h
	int 21h
.return:
	mov dx, newLine
	mov bl, byte [0x1FFF]
	mov ah, 01h
	int 21h
	jmp main
invalidFiles db "MAIN    SYSIRQ     SYSSYSTEM  SYSLOADER  SYS"
; ====================================================
