printText:
	pop esi
	add esi, 6
	cmp byte [esi], '$'
	je .getValue
	cmp byte [esi], '#'
	je .getString
	
	push esi
	
.charLoop:
	mov al, byte [esi]
	inc esi
	
	cmp al, '~'
	je .end
	cmp al, '$'
	je .getInlineNumber
	cmp al, '#'
	je .getInlineString
	
	mov ah, 0Eh
	int 10h
	jmp .charLoop
	
.getInlineNumber:
	movzx ax, byte [esi]
	cmp al, 'A'
	jb .goBack
	cmp al, 'Z'
	ja .goBack
	
	push esi
	
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di,	ax
	
	mov dx, .number
	mov cx, word [di]
	mov ah, 03h
	int 21h
	mov dx, .number
	mov bl, 07h
	mov ah, 01h
	int 21h
	
	pop esi
	inc esi
	
	jmp .charLoop
	
.getInlineString:
	movzx ax, byte [esi]
	cmp al, 'A'
	jb .goBack
	cmp al, 'D'
	ja .goBack
	
	push esi
	sub ax, 65d
	mov di, strings
	shl ax, 7
	add di, ax
	mov dx, di
	mov ah, 01h
	mov bl, 07h
	int 21h
	
	pop esi
	inc esi
	
	jmp .charLoop
	
.goBack:
	dec esi
	jmp .charLoop
	
.getString:
	inc esi
	push esi
	movzx ax, byte [esi]
	
	cmp al, 'A'
	jb vError
	cmp al, 'Z'
	ja vError
	
	sub ax, 65d
	mov esi, strings
	shl ax, 7
	add si, ax
	
	jmp .charLoop
	
.getValue:
	inc esi
	push esi
	xor ax, ax
	mov al, byte [esi]

	cmp al, 'A'
	jb vError
	
	cmp al, 'Z'
	ja vError

	xor ax, ax
	mov al, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax

	mov dx, .number
	mov cx, word [di]
	mov ah, 03h
	int 21h
	
	mov dx, .number
	mov bl, 07h
	mov ah, 01h
	int 21h
	
.end:
	pop esi
	
	jmp mainLoop
	
.number db "00000", 00h
;======================================================

;======================================================
printLineText:
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	je .getValue
	cmp byte [esi], '#'
	je .getString
	
	push esi
	
.charLoop:
	mov al, byte [esi]
	inc esi
	cmp al, '~'
	je .end
	cmp al, '$'
	je .getInlineNumber
	cmp al, '#'
	je .getInlineString
	mov ah, 0Eh
	int 10h
	jmp .charLoop
	
.getInlineNumber:
	movzx ax, byte [esi]
	cmp al, 'A'
	jb .goBack
	cmp al, 'Z'
	ja .goBack
	
	push esi
	
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di,	ax
	
	mov dx, .number
	mov cx, word [di]
	mov ah, 03h
	int 21h
	mov dx, .number
	mov ah, 01h
	mov bl, 07h
	int 21h
	
	pop esi
	inc esi
	
	jmp .charLoop
	
.getInlineString:
	movzx ax, byte [esi]
	cmp al, 'A'
	jb .goBack
	cmp al, 'D'
	ja .goBack
	
	push esi
	sub ax, 65d
	mov di, strings
	shl ax, 7
	add di, ax
	mov dx, di
	mov ah, 01h
	mov bl, 07h
	int 21h
	
	pop esi
	inc esi
	
	jmp .charLoop
	
.goBack:
	dec esi
	jmp .charLoop
	
.getString:
	inc esi
	push esi
	movzx ax, byte [esi]
	
	cmp al, 'A'
	jb vError
	cmp al, 'Z'
	ja vError
	
	sub ax, 65d
	mov esi, strings
	shl ax, 7
	add si, ax
	
	jmp .charLoop
	
.getValue:
	inc esi
	push esi
	movzx ax, byte [esi]

	cmp al, 'A'
	jb vError
	
	cmp al, 'Z'
	ja vError

	;movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax

	mov dx, .number
	mov cx, word [di]
	mov ah, 03h
	int 21h
	
	mov dx, .number
	mov bl, 07h
	mov ah, 01h
	int 21h
	
.end:
	mov dx, .newLine
	mov ah, 01h
	mov bl, 07h
	int 21h
	
	pop esi
	
	jmp mainLoop
	
.number db "00000", 00h
.newLine db 0Dh, 0Ah, 00h
;======================================================