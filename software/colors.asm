%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

; ==============================================
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
; ==============================================

%include "functions.asm"
%include "language.asm"

str1 db "00", 0x00
space db " ", 0x00
color db 0x00

; ==============================================
start:
	; this is a '16 by 16 loop', which will work
	; itslef through all the 256 color combinations that
	; there are
	; we have 16 foreground colors and 16 background colors
	; that we can combine in any way we want to
	; this prints the code in the colors thats it
	; represents, use this as a guide or something
    mov cx, 16
    .loopY:
        push cx
        mov cx, 16
        .loopX:
            push cx
            mov al, byte [color]
            mov si, str1
            call decToHex
            print str1, byte [color]
            inc byte [color]
            print space
            pop cx
            loop .loopX
        print NEWLINE
        pop cx
        loop .loopY

    xor ax, ax
    xor bx, bx
    int 0x21
; ==============================================
