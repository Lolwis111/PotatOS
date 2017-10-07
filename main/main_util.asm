%ifdef _DEBUG
; ====================================================
; gibt den Inhalt der Puffer aus
; ====================================================
dump_all:
    print newLine

    print inputBuffer

    print newLine

    print cmdargument

    print newLine

    print command

    print newLine

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
	cmp byte [cmdargument], 0x00
	je .color_help
	
	mov al, byte [cmdargument+1]
	cmp byte [cmdargument], al
    
    print newLine
    
	je main

	mov ah, 0x0D
	mov dx, cmdargument
	int 21h
	
	cmp ax, -1
	je .color_help
	
	mov dx, cx
	;mov ax, VIDEO_MEMORY_SEGMENT
	;mov gs, ax
	;mov bx, 0x01
	mov byte [SYSTEM_COLOR], dl
	
    call screen_setColor
    
;	mov cx, 2000
;.clearLoop:
;	mov byte [gs:bx], dl
;	add bx, 0x02
;	loop .clearLoop
	
    print newLine
	
	jmp main
	
.error:
    print .errorStr
	jmp main
	
.color_help:
    print COLOR_HELP
	jmp main

.errorStr db "\r\nError\r\n", 0x00
.color db "00000", 0x00
; ====================================================

