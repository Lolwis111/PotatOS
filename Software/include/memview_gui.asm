;================================================
drawInputBox:
	push si
	mov di, cursorPos(24, 7)
	mov cl, 5
.loopY:
	mov ch, 24
	.loopX:
		mov byte [gs:di], 20h
		inc di
		mov byte [gs:di], createColor(BLACK, MAGENTA)
		inc di
		dec ch
		test ch, ch
		jnz .loopX
	add di, 112
	dec cl
	test cl, cl
	jnz .loopY
	
	mov di, cursorPos(24, 7)
	mov cx, (SCREEN_HEIGHT - 1)
.top:
	mov byte [gs:di], 205
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	inc di
	loop .top
	
	mov di, cursorPos(24, 12)
	mov cx, (SCREEN_HEIGHT - 1)
.bottom:
	mov byte [gs:di], 205
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	inc di
	loop .bottom
	
	mov di, cursorPos(24, 7)
	mov cx, 5
.left:
	mov byte [gs:di], 186
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	add di, ((SCREEN_WIDTH * 2) - 1)
	loop .left
	
	mov di, cursorPos(48, 7)
	mov cx, 5
.right:
	mov byte [gs:di], 186
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	add di, ((SCREEN_WIDTH * 2) - 1)
	loop .right
	
	mov di, cursorPos(24, 7)
	mov byte [gs:di], 201
	mov di, cursorPos(48, 7)
	mov byte [gs:di], 187
	mov di, cursorPos(24, 12)
	mov byte [gs:di], 200
	mov di, cursorPos(48, 12)
	mov byte [gs:di], 188
	mov byte [gs:di+1], createColor(BLACK, BLUE)
	add di, 2
	
	pop si
	mov di, cursorPos(25, 8)
	mov ah, createColor(BLACK, MAGENTA)
	xor bp, bp
.charLoop:
	mov al, byte [si]
	inc si
	test al, al
	jz .readLine
	cmp al, 0Dh
	je .nl
	cmp al, 0Ah
	je .charLoop
	mov byte [gs:di], al
	add di, 2
	jmp .charLoop
.nl:
	mov di, cursorPos(25, 8)
	xor dx, dx
	mov ax, bp
	mov bx, ((SCREEN_WIDTH * 2))
	mul bx
	add di, ax
	inc bp
	jmp .charLoop

.readLine:
	mov cx, 0607h
	mov ax, 0103h
	int 10h

	mov dh, 10
	mov dl, 25
	mov ah, 0Eh
	int 21h

	mov dl, createColor(BLACK, MAGENTA)
	mov dh, '>'
	mov ah, 10h
	int 21h
	
	mov dh, 10
	mov dl, 26
	mov ah, 0Eh
	int 21h

	
	mov ah, 04h
	mov cx, 4
	mov dx, .inputBuffer
	mov byte [0x1FFF], createColor(BLACK, MAGENTA)
	int 21h
	
	mov ch, 32
	mov ah, 1
	mov al, 3			
	int 10h
	
.exit:
	
	mov dx, .inputBuffer
	ret
.inputBuffer db 00h, 00h, 00h, 00h, 00h, 00h, 00h, 00h
;================================================


;================================================
; Zeichnet eine Box mit Rahmen
;================================================
drawBox:
	push si
	mov di, cursorPos(4, 4)
	mov cl, 15
.loopY:
	mov ch, 60
	.loopX:
		mov byte [gs:di], 20h
		inc di
		mov byte [gs:di], createColor(BLACK, MAGENTA)
		inc di
		dec ch
		test ch, ch
		jnz .loopX
	add di, 40
	dec cl
	test cl, cl
	jnz .loopY
	
	mov di, cursorPos(4, 4)
	mov cx, 60
.top:
	mov byte [gs:di], 205
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	inc di
	loop .top
	
	mov di, cursorPos(4, 19)
	mov cx, 60
.bottom:
	mov byte [gs:di], 205
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	inc di
	loop .bottom
	
	mov di, cursorPos(4, 4)
	mov cx, 15
.left:
	mov byte [gs:di], 186
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	add di, ((SCREEN_WIDTH * 2) - 1)
	loop .left
	
	mov di, cursorPos(64, 4)
	mov cx, 15
.right:
	mov byte [gs:di], 186
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	add di, ((SCREEN_WIDTH * 2) - 1)
	loop .right
	
	mov di, cursorPos(4, 4)
	mov byte [gs:di], 201
	mov di, cursorPos(64, 4)
	mov byte [gs:di], 187
	mov di, cursorPos(4, 19)
	mov byte [gs:di], 200
	mov di, cursorPos(64, 19)
	mov byte [gs:di], 188
	inc di
	mov byte [gs:di], createColor(BLACK, BLUE)
	inc di
	
	pop si
	mov di, cursorPos(5, 5)
	mov ah, createColor(BLACK, MAGENTA)
	xor bp, bp
.charLoop:
	mov al, byte [si]
	inc si
	test al, al
	jz .inputLoop
	cmp al, 0Dh
	je .nl
	cmp al, 0Ah
	je .charLoop
	mov byte [gs:di], al
	add di, 2
	jmp .charLoop
.nl:
	mov di, cursorPos(5, 5)
	xor dx, dx
	mov ax, bp
	mov bx, (SCREEN_WIDTH * 2)
	mul bx
	add di, ax
	inc bp
	jmp .charLoop
	
	
.inputLoop:
	xor ax, ax
	int 16h
	
	cmp ah, 01h
	je .exit
	jmp .inputLoop
	
.exit:
	ret
;================================================


;==========================================
; DrawBorder:
;==========================================
drawBorder:
	mov bx, cursorPos(0, 0)
	mov cx, SCREEN_WIDTH
.top:
	mov byte [gs:bx], 196
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	inc bx
	loop .top
	
	mov bx, cursorPos(0, 24)
	mov cx, SCREEN_WIDTH
.bottom:
	mov byte [gs:bx], 196
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	inc bx
	loop .bottom
	
	mov bx, cursorPos(0, 1)
	mov cx, (SCREEN_HEIGHT - 2)
.left:
	mov byte [gs:bx], 179
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	add bx, ((SCREEN_WIDTH * 2) - 1)
	loop .left
	
	mov bx, cursorPos(79, 1)
	mov cx, (SCREEN_WIDTH - 2)
.right:
	mov byte [gs:bx], 179
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	add bx, 159
	loop .right

	mov bx, cursorPos(0, 24)
	mov byte [gs:bx], 192
	
	mov bx, cursorPos(79, 24)
	mov byte [gs:bx], 217
	
	mov bx, cursorPos(0, 0)
	mov byte [gs:bx], 218
	
	mov bx, cursorPos(79, 0)
	mov byte [gs:bx], 191

	mov di, cursorPos(3, 0)
	mov byte [gs:di], 180
	
	mov di, cursorPos(12, 0)
	mov byte [gs:di], 195
	
	mov di, cursorPos(4, 0)
	mov ah, createColor(BLACK, MAGENTA)
	mov si, exitKey
	call printString
	
	mov di, cursorPos(17, 0)
	mov si, helpKey
	call printString
	
	mov di, cursorPos(27, 0)
	mov si, gotoKey
	call printString
    
    mov di, cursorPos(36, 0)
	mov si, gotoKey2
	call printString
	
	mov di, cursorPos(3, 0)
	mov byte [gs:di], 180
	
	mov di, cursorPos(15, 0)
	mov byte [gs:di], 195
	
	mov di, cursorPos(16, 0)
	mov byte [gs:di], 180
	
	mov di, cursorPos(25, 0)
	mov byte [gs:di], 195
	
	mov di, cursorPos(26, 0)
	mov byte [gs:di], 180
	
	mov di, cursorPos(34, 0)
	mov byte [gs:di], 195
	
    mov di, cursorPos(35, 0)
	mov byte [gs:di], 180
	
	mov di, cursorPos(46, 0)
	mov byte [gs:di], 195
    
	mov di, cursorPos(3, 24)
	mov byte [gs:di], 180
	
	mov di, cursorPos(20, 24)
	mov byte [gs:di], 195
	
	ret
;==========================================


;==========================================
;SetupScreen
;==========================================
setupScreen:
	pusha
	
	mov bx, cursorPos(1, 2)
	xor cx, cx
.loop1:
	mov al, ch
	mov si, .hexStr
	call decToHex
	mov al, cl
	mov si, .hexStr+2
	call decToHex
	
	mov al, byte [.hexStr+1]
	mov byte [gs:bx], al
	inc bx
	mov byte [gs:bx], createColor(BLACK, CYAN)
	inc bx
	mov al, byte [.hexStr+2]
	mov byte [gs:bx], al
	inc bx
	mov byte [gs:bx], createColor(BLACK, CYAN)
	inc bx
	mov al, byte [.hexStr+3]
	mov byte [gs:bx], al
	inc bx
	mov byte [gs:bx], createColor(BLACK, CYAN)

.done:	
	add bx, ((SCREEN_WIDTH * 2) - 5)
	add cx, 16
	cmp cx, 336
	jl .loop1
	
	mov di, cursorPos(1, 1)
	mov si, titleStr
	mov ah, createColor(BLACK, CYAN)
	call printString
	
	mov di, cursorPos(1, 23)
	mov si, titleStr
	mov ah, createColor(BLACK, CYAN)
	call printString

	call drawBorder
	
	mov di, cursorPos(53, 0)
	mov byte [gs:di], 210
	mov di, cursorPos(53, 24)
	mov byte [gs:di], 208
	
	mov bx, cursorPos(53, 1)
	mov cx, 23
.loop2:
	mov byte [gs:bx], 186
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	add bx, ((SCREEN_WIDTH * 2) - 1)
	loop .loop2
	
.return:
	popa
	
	ret
.hexStr	db "0000", 00h
;==========================================


;==========================================
;RenderMemory
;==========================================
renderMemoryHex:
	pusha
	
	mov bx, word [offsetAdr]
	
	mov di, cursorPos(5, 2)
	
	xor cx, cx
.loopY:
	xor ch, ch
	.loopX:	
		mov al, byte [fs:bx]
		mov si, .hex
		call decToHex
		inc bx
		
		mov al, [.hex]
		mov byte [gs:di], al
		add di, 2
		mov al, [.hex+1]
		mov byte [gs:di], al
		add di, 2
		mov byte [gs:di], 20h
		add di, 2
		
		inc ch
		cmp ch, 16
		jl .loopX
	
	add di, 64
	
	inc cl
	cmp cl, 21
	jl .loopY
	
	popa
	ret
	
.hex db "00", 00h, 00h
;==========================================


;==========================================
renderMemoryASCII:
	pusha
    
	mov di, cursorPos(55, 2)
	mov bx, word [offsetAdr]
	
	xor cx, cx
.loopYC:
	xor ch, ch
	
	.loopXC:
		mov al, byte [fs:bx]
		inc bx

		mov byte [gs:di], al
		add di, 2
		inc ch
		cmp ch, 16
		jl .loopXC
		
	add di, 128
	
	inc cl
	cmp cl, 21
	jl .loopYC
	
	popa
	
	ret
;==========================================


;==========================================
drawPosition:
	pusha
    
	movzx ax, byte [cursor+1]
	xor dx, dx
	mov bx, 16
	mul bx
	movzx dx, byte [cursor]
	add ax, dx
	mov cx, ax
	add cx, word [offsetAdr]
	
	mov word [selectAdr], cx
	
	mov al, ch
	mov si, .number+12
	call decToHex
	mov al, cl
	mov si, .number+14
	call decToHex
    
    mov cx, word [segmentAdr]
    
    mov al, ch
	mov si, .number+7
	call decToHex
	mov al, cl
	mov si, .number+9
	call decToHex
    
	mov si, .number
	mov di, cursorPos(4, 24)
	mov ah, createColor(BLACK, MAGENTA)
	call printString
    
	popa
	
	ret
.number db "POS: 0x0000:0000", 00h, 00h
;==========================================
	
    
;==========================================
; dh row
; dl col
; al color
;==========================================
drawCursor:
	pusha
	
	push dx
	push ax
	
	movzx ax, dh
	movzx cx, dl	
	
	mov bx, cx
	shl cx, 2
	sub cx, bx
	
	add ax, 2
	add cx, 4
	
	xor dx, dx
	mov bx, (SCREEN_WIDTH * 2)
	mul bx
	
	shl cx, 1
	add ax, cx
	mov bx, ax
	
	pop ax
	
	add bx, 3
	mov byte [gs:bx], al
	add bx, 2
	mov byte [gs:bx], al
	
	pop dx
	
	push ax
	
	movzx ax, dh
	movzx cx, dl
	add ax, 2
	xor dx, dx
	mov bx, (SCREEN_WIDTH * 2)
	mul bx
	shl cx, 1
	add ax, cx
	mov bx, ax
	add bx, 111
	
	pop ax
	mov byte [gs:bx], al
	
	popa
	
	ret
;==========================================
