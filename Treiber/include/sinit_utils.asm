;==========================================
hexToDec:
	xor ax, ax
	xor bx, bx
	mov al, byte [si]
	inc si
	
	cmp al, 48d	; Ziffern 0-9
	je .num16
	cmp al, 49d
	je .num16
	cmp al, 50d
	je .num16
	cmp al, 51d
	je .num16
	cmp al, 52d
	je .num16
	cmp al, 53d
	je .num16
	cmp al, 54d
	je .num16
	cmp al, 55d
	je .num16
	cmp al, 56d
	je .num16
	cmp al, 57d
	je .num16
.chars:			; Ziffern A-F
	cmp al, 65d
	je .char16
	cmp al, 66d
	je .char16
	cmp al, 67d
	je .char16
	cmp al, 68d
	je .char16
	cmp al, 69d
	je .char16
	cmp al, 70d
	je .char16
	cmp cx, 1
	je .noc
	mov cx, 1
	sub al, 32d
	jmp .chars
.noc:
	mov ax, 1
	ret
.num16:
	sub ax, 48d
	shl ax, 4
	jmp .hex2
.char16:
	sub ax, 55d
	shl ax, 4
.hex2:
	mov bx, ax
	mov al, byte [si]
	inc si
	cmp al, 48d
	je .num161
	cmp al, 49d
	je .num161
	cmp al, 50d
	je .num161
	cmp al, 51d
	je .num161
	cmp al, 52d
	je .num161
	cmp al, 53d
	je .num161
	cmp al, 54d
	je .num161
	cmp al, 55d
	je .num161
	cmp al, 56d
	je .num161
	cmp al, 57d
	je .num161
.chars2:
	cmp al, 65d
	je .char161
	cmp al, 66d
	je .char161
	cmp al, 67d
	je .char161
	cmp al, 68d
	je .char161
	cmp al, 69d
	je .char161
	cmp al, 70d
	je .char161
	
	cmp cx, 2
	je .noc2
	mov cx, 2
	sub al, 32d
	jmp .chars2
.noc2:
	mov ax, 1
	xor cx, cx
	ret
.num161:
	sub ax, 48d
	add bx, ax
	jmp .end
.char161:
	sub ax, 55d
	add bx, ax
.end:
	xor ax, ax
	mov cx, bx
	ret
;==========================================


;==========================================
Print:
	lodsb
	or al, al
	jz .return
	mov ah, 0Eh
	int 10h
	jmp Print
.return:
	ret
;==========================================


;==========================================
setColor:
	mov ax,0xB800
	mov gs, ax
	mov cx, 2000d
	mov bx, 1
.charLoop:
	mov byte [gs:bx], dl
	add bx, 2
	loop .charLoop
	ret
;==========================================