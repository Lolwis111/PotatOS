; ==========================================
; IN DH Row, DL Colum
; OUT /
; ==========================================
; setCursor:

;	movzx ax, byte [row]
;	movzx bx, byte [col] 
;	shl ax, 4
;	add bx, ax
;	shl ax, 2
;	add bx, ax

;	mov al, 0Fh
;	mov dx, 3D4h
;	out dx, al
	
;	mov ax, bx
;	mov dx, 3D5h
;	out dx, al
	
;	mov al, 0Eh
;	mov dx, 3D4h
;	out dx, al
	
;	mov ax, bx
;	shr ax, 8
;	mov dx, 3D5h
;	out dx, al
    
;	ret
; ==========================================


; ==========================================
; IN /
; OUT /
; ==========================================	
setScreen:
	mov ax, 0xB800
	xor bx, bx
	mov fs, ax
	mov ax, 1F20h
	mov cx, 2000d
	.clearLoop:
		mov word [fs:bx], ax
		add bx, 2
		loop .clearLoop
	
	mov ax, 0x1FC9
	xor bx, bx
	mov word [fs:bx], ax
	mov bx, 2

	mov ax, 0x1FCD
	mov cx, 78d
	.topLine:
		mov word [fs:bx], ax
		add bx, 2
		loop .topLine
	mov ax, 0x1FBB
	mov word [fs:bx], ax
	mov bx, 3840d
	mov cx, 78d
	mov ax, 0x1FC8
	mov word [fs:bx], ax
	add bx, 2
	mov ax, 0x1FCD
	.bottomLine:
		mov word [fs:bx], ax
		add bx, 2
		loop .bottomLine
	mov ax, 0x1FBC
	mov word [fs:bx], ax

	mov bx, 160d
	mov cx, 23d
	mov ax, 0x1FBA
	.leftLine:
		mov word [fs:bx], ax
		add bx, 160d
		loop .leftLine
	
	mov bx, 318d
	mov cx, 23d
	mov ax, 0x1FBA
	.rightLine:
		mov word [fs:bx], ax
		add bx, 160d
		loop .rightLine
		
	ret
; ==========================================
	
	
; ==========================================
; IN AH=Color
; OUT /
; ==========================================
ClearScreen:
	mov al, 20h
	xor bx, bx
	mov cx, 2000
.clearLoop:
	mov word [fs:bx], ax
	add bx, 2
	loop .clearLoop
	ret
; ==========================================
