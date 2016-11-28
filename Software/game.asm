[ORG 0x9000]
[BITS 16]
 
jmp main
 
%include "defines.asm"
 
_posX   db 00h
_posY   db 00h
_aX     db 00h
_aY     db 00h
 
;=======================================================
clearScreen:
	xor bx, bx
	mov dl, 0x20
	;mov dh, byte [0x1FFF]
	mov cx, 2000d
.l1:
	mov word [fs:bx], dx
	add bx, 2
	loop .l1
    
	ret
;=======================================================
 
 
;=======================================================
; cl Column
; ch Row
;=======================================================
printChar:
    push dx
	movzx bx, cl
	movzx ax, ch
	shl bx, 1
	mov cx, 160d
	mul cx
	add bx, ax
    pop dx
    
    mov byte [fs:bx], dh
	mov byte [fs:bx+1], dl
    
    ret
;=======================================================
 
 
;=======================================================
main:
    mov ax, 0xB800
    mov fs, ax

    mov dh, createColor(BLUE, WHITE)
	call clearScreen
	
    xor dx, dx
    mov ah, 0Eh
    int 21h
    
    
    mov byte [_posX], 00h
    mov byte [_posY], 00h
;=======================================================


;=======================================================    
gameLoop:

    ;mov dh, byte [_posY]
    ;mov dl, byte [_posX]
    ;mov ah, 0Eh
    ;int 21h
    
    mov cl, byte [_posX]
    mov ch, byte [_posY]
    mov dh, 0x20
    mov dl, createColor(BLUE, WHITE)
    call printChar
    
    ;mov dh, 0x20
    ;mov dl, createColor(BLUE, WHITE)
    ;mov ah, 10h
    ;int 21h
    
    cmp byte [_aX], 00h
    je .positiveX
    dec byte [_posX]
    jmp .y
.positiveX:
    inc byte [_posX]
.y:
    cmp byte [_aY], 00h
    je .positiveY
    dec byte [_posY]
    jmp .doneMove
.positiveY:
    inc byte [_posY]
.doneMove:

    cmp byte [_posX], 00h
    jne .checkXRight
    mov byte [_aX], 00h
    jmp .checkYTop
.checkXRight:
    cmp byte [_posX], 79
    jne .checkYTop
    mov byte [_aX], 01h
.checkYTop:
    cmp byte [_posY], 00h
    jne .checkYRight
    mov byte [_aY], 00h
    jmp .doneCheck
.checkYRight:
    cmp byte [_posY], 24
    jne .doneCheck
    mov byte [_aY], 01h
.doneCheck:

    mov cl, byte [_posX]
    mov ch, byte [_posY]
    mov dh, 'X'
    mov dl, createColor(BLUE, RED)
    call printChar

    ;mov dh, byte [_posY]
    ;mov dl, byte [_posX]
    ;mov ah, 0Eh
    ;int 21h
    ;mov dh, 'X'
    ;mov dl, createColor(BLUE, WHITE)
    ;mov ah, 10h
    ;int 21h
    
    mov cx, 65535       ; Prozess verlangsammen
.l2:
    push cx
    mov cx, 65535
    .l3:
        loop .l3
    pop cx
    loop .l2
    
    mov ah, 01h         ; Wenn eine Taste gedrückt wird -> Abbrechen
    int 16h
    jz gameLoop
    
    xor ax, ax
    int 16h
    
    mov dh, byte [0x1FFF]
    call clearScreen
    
	xor ax, ax          ; Programm beenden
	xor bx, bx          ; Kein Fehler
	int 21h
    
    cli
    hlt
;=======================================================
