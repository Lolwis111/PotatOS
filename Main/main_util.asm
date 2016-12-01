%ifdef _DEBUG
; ====================================================
; gibt den Inhalt der Puffer aus
; ====================================================
dump_all:
    mov ah, 01h
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, inputBuffer
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, cmdargument
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, command
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    mov ah, 01h
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 21h

    jmp main
; ====================================================
%endif

; ====================================================
; Löscht den kompletten Text aus der Konsole
; ====================================================
clear_screen:
	mov ax, VIDEO_MEMORY_SEGMENT
	mov gs, ax
	xor bx, bx
	
	mov al, byte [SYSTEM_COLOR]
	mov cx, SCREEN_BUFFER_SIZE
.clearLoop:
	mov byte [gs:bx], 0x20 ; Bildbereich mit Leerzeichen überschreiben
	inc bx
	mov byte [gs:bx], al
	inc bx
	
	loop .clearLoop
	
	xor dx, dx  ; Cursorposition auf 0;0 setzen
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
	mov ax, VIDEO_MEMORY_SEGMENT
	mov gs, ax
	mov bx, 01h
	mov byte [SYSTEM_COLOR], dl
	
	mov cx, 2000
.clearLoop:
	mov byte [gs:bx], dl
	add bx, 02h
	loop .clearLoop
	
	mov ah, 01h
	mov dx, newLine
	mov bl, byte [SYSTEM_COLOR]
	int 21h
	
	jmp main
	
.error:
	mov dx, .errorStr
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 01h
	int 21h
	jmp main
	
.color_help:
	mov dx, COLOR_HELP	
    mov bl, byte [SYSTEM_COLOR]
	mov ah, 01h
	int 21h
	jmp main

.errorStr db 0Dh, 0Ah, "Error", 0Dh, 0Ah, 00h
.color db "00000", 00h
; ====================================================

