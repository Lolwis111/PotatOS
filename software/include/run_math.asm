_add:	
	xor ax, ax
	mov es, ax
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	mov dx, word [di]
	;xor di, di
	
	sub esi, 4
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax

	add word [di], dx

	add esi, 2
	
	jmp mainLoop
	
_sub:
	xor ax, ax
	mov es, ax
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	mov dx, word [di]
	;xor di, di
	
	sub esi, 4
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax

	sub word [di], dx

	add esi, 2
	
	jmp mainLoop
_mul:
	xor ax, ax
	mov es, ax
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	mov dx, word [di]
	;xor di, di
	
	sub esi, 4
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax

	mov ax, word [di]
	mul dx
	mov word [di], ax

	add esi, 2
	
	jmp mainLoop
	
_div:
	xor ax, ax
	mov es, ax
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	mov bp, word [di]
	;xor di, di
	
	sub esi, 4
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	
	xor dx, dx
	mov ax, word [di]
	div bp
	mov word [di], ax

	add esi, 2
	
	jmp mainLoop
	
_mod:
	xor ax, ax
	mov es, ax
	pop esi
	
	add esi, 7
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	mov bp, word [di]
	;xor di, di
	
	sub esi, 4
	cmp byte [esi], '$'
	jne notAValue
	inc esi
	cmp byte [esi], 'A'
	jb vError
	cmp byte [esi], 'Z'
	ja vError
	;xor ax, ax
	movzx ax, byte [esi]
	sub ax, 65d
	mov di, numbers
	shl ax, 1
	add di, ax
	
	xor dx, dx
	mov ax, word [di]
	div bp
	mov word [di], dx

	add esi, 2
	
	jmp mainLoop
	
notAValue:
	mov ah, 01h
	mov bl, 07h
	mov dx, .notAValueMSG
	int 21h
	
	xor ax, ax
	int 16h
	
	jmp endOfScript
.notAValueMSG db 0Dh, 0Ah, "Die Operanden müssen Variablen sein!", 00h