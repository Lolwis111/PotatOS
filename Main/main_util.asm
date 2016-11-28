; ====================================================
; Löscht den kompletten Text aus der Konsole
; ====================================================
clear_screen:
	mov ax, 0xB800
	mov gs, ax
	xor bx, bx
	
	mov al, byte [0x1FFF]
	mov cx, 2000
.clearLoop:
	mov byte [gs:bx], 20h
	inc bx
	mov byte [gs:bx], al
	inc bx
	
	loop .clearLoop
	
	xor dx, dx
	mov ah, 0Eh
	int 21h
	
	jmp main
; ====================================================


; ====================================================
; Wechselt die Farbe der Konsole
; ====================================================
change_color:
	cmp byte [cmdargument], 00h
	je .color_help
	
	mov al, byte [cmdargument+1]
	cmp byte [cmdargument], al
	
	je main

	mov ah, 0Dh
	mov dx, cmdargument
	int 21h
	
	cmp ax, -1
	je .color_help
	
	mov dx, cx
	mov ax, 0xB800
	mov gs, ax
	mov bx, 01h
	mov byte [0x1FFF], dl
	
	mov cx, 2000
.clearLoop:
	mov byte [gs:bx], dl
	add bx, 02h
	loop .clearLoop
	
	mov ah, 01h
	mov dx, newLine
	mov bl, byte [0x1FFF]
	int 21h
	
	jmp main
	
.error:
	mov dx, .errorStr
	mov bl, byte [0x1FFF]
	mov ah, 01h
	int 21h
	jmp main
	
.color_help:
	mov dx, .colorHelp
	mov bl, byte [0x1FFF]
	mov ah, 01h
	int 21h
	jmp main
	
.colorHelp	db 0Dh, 0Ah, "Farbe wird durch zwei Ziffern angegeben"
			db 0Dh, 0Ah, "0 Schwarz   8 Grau"
			db 0Dh, 0Ah, "1 Blau      9 Hellblau"
			db 0Dh, 0Ah, "2 Gruen     A Hellgruen"
			db 0Dh, 0Ah, "3 Cyan      B Hellcyan"
			db 0Dh, 0Ah, "4 Rot       C Hellrot"
			db 0Dh, 0Ah, "5 Magenta   D Hellmagenta"
			db 0Dh, 0Ah, "6 Braun     E Hellgelb"
			db 0Dh, 0Ah, "7 Weiss     F Hellweiss"
			db 0Dh, 0Ah, 00h
		   
.errorStr db 0Dh, 0Ah, "Error", 0Dh, 0Ah, 00h
.color db "00000", 00h
; ====================================================

