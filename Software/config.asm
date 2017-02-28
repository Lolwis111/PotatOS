[ORG 0x9000]
[BITS 16]

jmp start

%ifdef german 
    %define CURSOR_X 0x19
%elif english
    %define CURSOR_X (0x19 - 0x08)
%endif

%include "defines.asm"
fileName db "CONFIG  CFG", 00h

colorByte	db 00h
highMem		db 00h
kb_switch	db 00h
cfgLength	dw 00h
fileLenght  dw 00h

cmdColor	db "COLOR=", 00h
cmdHigh		db "HIGH=", 00h
cmdKBXY		db "YZ_SWITCH=", 00h
cmdEND		db "END", 00h

cmdTrue		db "TRUE ", 00h
cmdFalse	db "FALSE", 00h


;================================================
; CX < Bool
; DX > String
;================================================
boolToString:
    cmp cx, 1
    je .true
    mov dx, cmdFalse
    ret
.true:
    mov dx, cmdTrue
    ret
;================================================


;================================================
drawCursor:
    push dx
    mov ah, 0Fh
    int 21h
    
    movzx bx, dl
    mov cx, 160
    movzx ax, dh
    mul cx
    shl bx, 1
    add bx, ax
    pop dx
    inc bx
    mov cx, 5
.l1:
    mov byte [gs:bx], dl
    add bx, 2
    loop .l1

    ret
;================================================


;================================================
printOptions:
    mov dh, 03h
    mov dl, CURSOR_X
    mov ah, 0Eh
    int 21h
    
    mov cl, byte [colorByte]
    mov ah, 15h
    mov dx, .colorStr
    int 21h
    
    mov ah, 01h
    mov dx, .colorStr
    mov bl, createColor(BLACK, MAGENTA)
    int 21h
    
    mov dh, 04h
    mov dl, CURSOR_X
    mov ah, 0Eh
    int 21h

    movzx cx, byte [kb_switch]
    call boolToString
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    int 21h
    
    mov dh, 05h
    mov dl, CURSOR_X
    mov ah, 0Eh
    int 21h

    movzx cx, byte [highMem]
    call boolToString
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    int 21h
    
    ret
.colorStr db "00", 00h
;================================================


;================================================
; DrawBorder:
;================================================
drawBorder:
	mov bx, cursorPos(0, 0)
	mov cx, SCREEN_WIDTH
.top:
	mov byte [gs:bx], 196
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	inc bx
	loop .top
    
    mov bx, cursorPos(0, 2)
    mov cx, SCREEN_WIDTH
.top2:
	mov byte [gs:bx], 196
	inc bx
	mov byte [gs:bx], createColor(BLACK, BLUE)
	inc bx
	loop .top2
	
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
	mov cx, (SCREEN_HEIGHT - 2)
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
	
    mov bx, cursorPos(0, 2)
	mov byte [gs:bx], 195
    
    mov bx, cursorPos(79, 2)
	mov byte [gs:bx], 180
    
	ret
;================================================


;================================================
drawGUI:
    mov dx, 0101h
    mov ah, 0Eh
    int 21h
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    mov dx, .lblTitle
    int 21h
    
    mov dx, 0301h
    mov ah, 0Eh
    int 21h
    
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    mov dx, .lblColor
    int 21h
    
    mov dx, 0401h
    mov ah, 0Eh
    int 21h
    
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    mov dx, .lblKB
    int 21h
    
    mov dx, 0501h
    mov ah, 0Eh
    int 21h
    
    mov ah, 01h
    mov bl, createColor(BLACK, MAGENTA)
    mov dx, .lblHigh
    int 21h
    
    ret
%ifdef german
.lblTitle   db "Konfigurationseditor 0.1", 00h
.lblColor   db "Farbe der Shell       : ", 00h
.lblKB      db "Y und Z vertauschen   : ", 00h
.lblHigh    db "High-Memory aktivieren: ", 00h
%elif english
.lblTitle   db "configuration editor 0.1", 00h
.lblColor   db "shell color:    ", 00h
.lblKB      db "switch y and z: ", 00h
.lblHigh    db "enable highmem: ", 00h
%endif
;================================================


; ===============================================
; den kompletten Bildschirm leeren
; ===============================================
clearScreen:
	pusha
	xor bx, bx
	mov cx, 2000
.loop1:
	mov word [gs:bx], dx
	add bx, 2
	loop .loop1
    
    xor dx, dx
    mov ah, 0Eh
    int 21h
    
    popa
    
	ret
; ===============================================

start:
    mov dh, createColor(BLACK, MAGENTA)
    mov dl, 0x20
    call clearScreen

    call drawBorder
    call drawGUI

    mov dx, fileName
	xor bx, bx
	mov bp, configFile
	mov ah, 05h
	int 21h				; Datei laden
	mov word [fileLenght], cx
	cmp ax, -1
	je .loadError
    
    mov word [cfgLength], cx
	add word [cfgLength], configFile
    
    mov si, configFile
    
; ================================================
.scanLoop:
	push si
	mov di, cmdColor
	mov cx, 6
	rep cmpsb
	je .color
	pop si

	push si
	mov di, cmdHigh
	mov cx, 5
	rep cmpsb
	je .high
	pop si
	
	push si
	mov di, cmdKBXY
	mov cx, 10
	rep cmpsb
	je .kb_yz
	pop si
	
	inc si
	cmp si, word [cfgLength]
	je .cfg
	jmp .scanLoop
; ================================================

; ================================================
.color:
	mov dx, si
    mov ah, 0Dh
    int 21h
    
	cmp ax, 1
	je .noCfg
	mov byte [colorByte], cl
	
	pop si
	add si, 8
	
	jmp .scanLoop
; ================================================

; ================================================	
.kb_yz:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .kb_ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .kb_nok
	pop si

	pop si
	jmp .scanLoop
; ================================================
    
; ================================================
.kb_ok:
	pop si
	pop si
	mov byte [kb_switch], 1
	add si, 14
	jmp .scanLoop
; ================================================
    
; ================================================
.kb_nok:
	pop si
	pop si
	mov byte [kb_switch], 0
	add si, 15
	jmp .scanLoop
; ================================================
    
; ================================================
.high:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .nok
	pop si

	pop si
	jmp .noCfg
; ================================================
    
; ================================================
.ok:
	pop si
	pop si
	mov byte [highMem], 1
	add si, 9
	jmp .scanLoop
; ================================================

; ================================================
.nok:
	pop si
	pop si
	mov byte [highMem], 0
	add si, 10
	jmp .scanLoop
; ================================================
	
; ================================================
.noCfg:
	pop si
	
	mov si, .msgLoadError
	mov ah, 01h
    mov bl, byte [0x1FFF]
    int 21h
	
	mov byte [colorByte], 07h
	mov byte [highMem], 00h
	mov byte [kb_switch], 00h
; ================================================
	
; ================================================
.cfg:

    call printOptions
    
    jmp mainLoop
; ================================================

; ================================================
%ifdef german
.msgLoadError db 0Dh, 0Ah, "Die Konfigurationsdatei konnte nicht gelesen werden!"
              db 0Dh, 0Ah, "Setze Standartwerte!", 0Dh, 0Ah, 00h
%elif english
.msgLoadError db 0Dh, 0Ah, "Unable to read config file!"
              db 0Dh, 0Ah, "Using defaults!", 0Dh, 0Ah, 00h
%endif
.loadError:
    mov bl, createColor(BLACK, RED)
    mov ah, 01h
    mov dx, .msgLoadError
    int 21h

    mov bx, -1
; ================================================


; ================================================
mainLoop:
    xor ax, ax
    int 16h
    
    cmp ah, 48h
    je .moveUp
    cmp ah, 50h
    je .moveDown
    
    cmp ah, 1Ch
    je .edit
    
    cmp ah, 01h
    je .end

    jmp mainLoop
    
.moveUp:
    dec byte [cursor_pos]
    
    cmp byte [cursor_pos], 02h
    jne .move
    mov byte [cursor_pos], 05h
    jmp .move
    
.moveDown:
    inc byte [cursor_pos]
    
    cmp byte [cursor_pos], 06h
    jne .move
    mov byte [cursor_pos], 03h

.move:
    mov dl, createColor(BLACK, MAGENTA)
    call drawCursor

    mov dh, byte [cursor_pos]
    mov dl, CURSOR_X
    mov ah, 0Eh
    int 21h
    
    mov dl, createColor(WHITE, MAGENTA)

    jmp mainLoop
    
.edit:

    cmp byte [cursor_pos], 03h
    je .editColor

    cmp byte [cursor_pos], 04h
    je .switchKB
    
    cmp byte [cursor_pos], 05h
    je .switchHigh

    jmp .return
.editColor:

    jmp .return

.switchKB:
    cmp byte [kb_switch], 01h
    je .zeroKB
    mov byte [kb_switch], 01h
    jmp .return
.zeroKB:
    mov byte [kb_switch], 00h
    jmp .return
    
.switchHigh:
    cmp byte [highMem], 01h
    je .zeroHigh
    mov byte [highMem], 01h
    jmp .return
.zeroHigh:
    mov byte [highMem], 00h
    jmp .return
    
.return:
    call printOptions
    jmp mainLoop
    
.end:
    xor bx, bx
    jmp exit
    
cursor_pos db 03h
; ================================================

    
; ===============================================
; beendet das Programm
; ===============================================
exit:
    mov dh, byte [0x1FFF]
    mov dl, 0x20
    call clearScreen
    
    xor ax, ax
    int 21h
    cli
    hlt
; ===============================================

configFile db 00h
