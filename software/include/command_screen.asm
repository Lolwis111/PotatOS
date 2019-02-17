; ====================================================
; clears the terminal
; ====================================================
clear_screen:
	mov ax, VIDEO_MEMORY_SEGMENT
	mov gs, ax
	xor bx, bx
	
	mov al, byte [SYSTEM_COLOR]
	mov cx, SCREEN_BUFFER_SIZE
.clearLoop:
	mov byte [gs:bx], 0x20 ; override everything with spaces
	inc bx
	mov byte [gs:bx], al
	inc bx
	
	loop .clearLoop
	
	movecur 0, 0 ; move cursor to upper left corner
	
	jmp main
; ====================================================


; ====================================================
; changes the color of the terminal
; ====================================================
change_color:
	cmp byte [argument], 0x00
	je .color_help

	mov al, byte [argument+1]
	cmp byte [argument], al
    
    print NEWLINE

	je main

	mov ah, 0x0D
	mov dx, argument
	int 0x21
	
	cmp ax, -1
	je .color_help
	
	mov dx, cx
	mov byte [SYSTEM_COLOR], dl
	
    call screen_setColor
	
    print NEWLINE
	
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
