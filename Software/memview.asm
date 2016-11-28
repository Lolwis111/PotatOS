[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%define DISP_BACKUP 0x9500

words:
offsetAdr	dw 8000h
selectAdr	dw 0000h
lastCursor	dw 0000h
cursor		dw 0000h
titleStr	db "     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F ", 186, " 0123456789ABCDEF", 00h
helpKey		db "F1 Hilfe", 00h
gotoKey		db "F2 Goto", 00h
exitKey		db "ESC Beenden", 00h
color 		db 00h

inputStr	db 0Dh
			db "Offset (0x0000-0xFFFF):", 00h
			
;inputStr2	db 0Dh
;			db "Segment(0x0000-0xFFFF):", 00h

helpStr		db 0Dh
			db "MEMVIEW.BIN - Hilfe", 0Dh
			db "------------------------------", 0Dh
			db "Mit den Pfeiltasten kann durch den angezeigten Speicher-", 0Dh
			db "bereich navigiert werden. Durch das Druecken von Bild-Auf,", 0Dh
			db "und Bild-Ab kann im Speicherbeich um jeweils 16 Byte weiter", 0Dh
			db "oder zurueck navigiert werden. ", 00h

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
; Wandelt al in einen Hexstring in si um
;================================================
decToHex:
	pusha
	
	xor ah, ah

	mov bl, 16
	div bl
	
	mov bx, .hexChar
	add bl, al
	mov al, byte [bx]
	mov byte [si], al
	inc si
	mov bx, .hexChar
	add bl, ah
	mov al, byte [bx]
	mov byte [si], al
	
	popa
	ret
.hexChar db "0123456789ABCDEF"
;==========================================


;==========================================
printString:
	mov al, byte [si]
	inc si
	test al, al
	jz .return
	mov byte [gs:di], al
	inc di
	mov byte [gs:di], ah
	inc di
	jmp printString
.return:
	ret
;==========================================


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
;editByte:
;==========================================
editByte:
	mov di, word [selectAdr]
	mov al, byte [fs:di]
	mov byte [.dataByte], al

	movzx ax, byte [cursor+1]
	movzx cx, byte [cursor]
	
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
	add bx, 2
	
	mov byte [gs:bx], 20h
	add bx, 2
	mov byte [gs:bx], 20h
	
	push bx
	
	mov dx, word [cursor]
	add dh, 2
	mov cl, dl
	shl dl, 2
	sub dl, cl
	add dl, 5
	mov ah, 0Eh
	int 21h
	
	mov ch, 32
	mov ah, 1
	mov al, 3			
	int 10h
	
	mov ah, 04h
	mov dx, .hex
	mov byte [0x1FFF], createColor(WHITE, BLACK)
	mov cx, 2
	int 21h
	cmp cx, 0
	je .backup
	cmp cx, 2
	je .ok
	mov byte [.hex+1], '0'
.ok:
	pop bx
	
	mov al, byte [.hex]
	mov byte [gs:bx], al
	mov al, byte [.hex+1]
	add bx, 2
	mov byte [gs:bx], al
	
	mov ah, 0Dh
	mov dx, .hex
	int 21h
	mov di, word [selectAdr]
	mov byte [fs:di], cl

.return:
	xor dx, dx
	mov ah, 0Eh
	int 21h
	
	mov cx, 0607h
	mov ax, 0103h
	int 10h
	
	ret
.backup:
	pop bx
	mov di, word [selectAdr]
	mov al, byte [.dataByte]
	mov byte [fs:di], al
	jmp .return
.hex		db "00", 00h
.dataByte	db 00h
;==========================================

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
	
	mov di, cursorPos(3, 24)
	mov byte [gs:di], 180
	
	mov di, cursorPos(15, 24)
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
.number db "POS: 0x0000", 00h, 00h
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


;==========================================
start:
	xor dx, dx
	mov ah, 0Eh
	int 21h

	mov al, byte [0x1FFF]
	mov byte [color], al
	
	mov ch, 32
	mov ah, 1
	mov al, 3			
	int 10h
	
	mov ax, VIDEO_MEMORY_SEGMENT
	mov gs, ax
	
	xor ax, ax
	mov fs, ax
	
	mov dx, (createColor(BLACK, BRIGHT_YELLOW)<<8)+(20h)
	call cls
	
	call setupScreen
	
	call drawPosition
	
	mov dx, word [cursor]
	mov al, createColor(WHITE, BLACK)
	call drawCursor
	
	jmp main
;==========================================


;==========================================	
main:
	call renderMemoryHex
	call renderMemoryASCII
	xor ax, ax
	int 16h
	
	cmp ah, 49h
	je .scrollUp
	
	cmp ah, 51h
	je .scrollDown
	
	cmp ah, 48h
	je .moveUp
	cmp ah, 4Bh
	je .moveLeft
	cmp ah, 4Dh
	je .moveRight
	cmp ah, 50h
	je .moveDown
	
	cmp ah, 3Bh
	je .showHelp
	
	cmp ah, 3Ch
	je .setOffset
	
	cmp ah, 01h
	je .exit
	
	cmp ah, 1Ch
	je .edit
	
	jmp main
	
.scrollUp:
	sub word [offsetAdr], 10h
	call drawPosition
	jmp main
	
.scrollDown:
	add word [offsetAdr], 10h
	call drawPosition
	jmp main
	
.moveUp:
	dec byte [cursor+1]
	
	cmp byte [cursor+1], 0
	jnl .refreshCursor
	
	mov byte [cursor+1], 0
	jmp .refreshCursor
.moveDown:
	inc byte [cursor+1]
	
	cmp byte [cursor+1], 20
	jng .refreshCursor
	
	mov byte [cursor+1], 20
	jmp .refreshCursor
.moveLeft:
	dec byte [cursor]
	
	cmp byte [cursor], 0
	jnl .refreshCursor
	
	mov byte [cursor], 0
	jmp .refreshCursor
.moveRight:
	inc byte [cursor]
	
	cmp byte [cursor], 15
	jng .refreshCursor
	
	mov byte [cursor], 15
	jmp .refreshCursor
	
.showHelp:
	call backupDispBuffer
	
	mov si, helpStr
	call drawBox

	call restoreDispBuffer
	
	jmp main
	
.edit:
	call editByte

	jmp main
	
.setOffset:
	call backupDispBuffer

	mov si, inputStr
	call drawInputBox
	mov word [.adr], dx
	mov word [.nOffset], 0000h
	
	mov ah, 0Dh
	mov dx, word [.adr]
	int 21h
	mov byte [.nOffset+1], cl
	mov ah, 0Dh
	mov dx, word [.adr+2]
	int 21h
	add byte [.nOffset], cl
	
	mov cx, word [.nOffset]
	
	dec cx
	mov word [offsetAdr], cx
	
	call restoreDispBuffer
	
	call drawPosition
	
	jmp main
.adr 		dw 0000h
.nOffset	dw 0000h
	
.refreshCursor:

	mov dx, word [lastCursor]
	mov al, createColor(BLACK, BRIGHT_YELLOW)
	call drawCursor
	mov dx, word [cursor]
	mov al, createColor(WHITE, BLACK)
	call drawCursor
	
	call drawPosition	
	
	mov ax, word [cursor]
	mov word [lastCursor], ax
	
	jmp main
	
.exit: 
	mov dh, byte [color]
	mov dl, 20h
	call cls
	
	mov al, byte [color]
	mov byte [0x1FFF], al
	
	; Cursor einblenden
	mov cx, 0607h
	mov ax, 0103h
	int 10h
	
	xor bx, bx
	xor ax, ax
	int 21h
;==========================================
