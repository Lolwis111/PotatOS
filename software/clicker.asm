%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "strings.asm"
%include "language.asm"
%include "keys.asm"
%include "functions.asm"

damage dd 0x00000001
coins dd 0x00000000
bonus dd 0x00000000

; ===============================================
start:
    mov dh, 0x07
    mov dl, 0x20
    call clearScreen
	

main:
	call printScore

	xor ax, ax
	int 0x16
	
	cmp ah, KEY_SPACE
	je .attack
	
	cmp ah, KEY_ENTER
	je .buyBonus
	
	jmp main
.attack:
	
	mov ecx, dword [damage]
	add dword [coins], ecx
	
	mov ecx, dword [bonus]
	add dword [coins], ecx
	
	jmp main
	
.buyBonus:
	sub dword [coins], 50
	add dword [bonus], 10
	jmp main
	
	
printScore:

	ltostr .scoreStr, dword [coins]
	ltostr .damageStr, dword [damage]

	movecur 1, 0
	print .scoreStr
	
	movecur 20, 0
	print .damageStr
	
	ret
.scoreStr times 13 db 0x00
.damageStr times 13 db 0x00

clearScreen:
	pusha
	
	xor bx, bx
	mov cx, (SCREEN_WIDTH * SCREEN_HEIGHT) * 2
.loop1:
	mov word [gs:bx], dx
	add bx, 2
	loop .loop1
	
	popa
	ret
