[ORG 0x9000]
[BITS 16]

jmp start

%define DISP_BACKUP displayBackupMemory

%include "defines.asm"
%include "include/memview_tools.asm"
%include "include/memview_gui.asm"

words:
    offsetAdr   dw 0x9000
    segmentAdr  dw 0x0000
    selectAdr   dw 0x0000
    lastCursor  dw 0x0000
    cursor      dw 0x0000

titleStr    db "     0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F ", 186, " 0123456789ABCDEF", 0x00

helpKey     db "F1 Hilfe", 0x00
gotoKey     db "F2 Goto", 0x00
gotoKey2    db "F3 Segment", 0x00
exitKey		db "ESC Beenden", 0x00
color 		db 0x00

readOnly    db 0x00

inputStr	db 0x0D
			db "Offset (0000-FFFF):", 0x00
			
inputStr2	db 0x0D
			db "Segment(0000-FFFF):", 0x00

%ifdef german

    helpStr		db 0x0D
                db "MEMVIEW.BIN - Hilfe", 0x0D
                db "------------------------------", 0x0D
                db "Mit den Pfeiltasten kann durch den angezeigten Speicher-", 0x0D
                db "bereich navigiert werden. Durch das Druecken von Bild-Auf,", 0x0D
                db "und Bild-Ab kann im Speicherbeich um jeweils 16 Byte weiter", 0x0D
                db "oder zurueck navigiert werden. Um einen Wert zu veraendern", 0x0D
                db "muss enter gedrueckt werden.", 0x0D
                db "Um im schreibgeschuetzten Modus zu starten, den Schalter 'R''", 0x0D
                db "aktivieren.", 0x00
      
%elifdef english

    helpStr		db 0x0D
                db "MEMVIEW.BIN - Help", 0x0D
                db "------------------------------", 0x0D
                db "You can navigate through the memomory area using the arrow", 0x0D
                db "keys. To move further in memory, you can move the selected", 0x0D
                db "are by 16-bytes up or down by pressing page-up or page-down.", 0x0D
                db "Press enter to alter the selected value.", 0x0D
                db "To start in read-only mode, pass 'R' on the command line.", 0x00
            
%endif

;================================================
; converts al to a 2-byte hex-string
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
start:
    cmp ax, -1                  ; check if an argument was passed
    je .ok                      ; if no, skip the next few lines
    
    mov si, ax                  ; else
    cmp byte [si], 'R'          ; read the first char of the argument
    jne .ok                     ; R activates read-only, everything else does nothing at all
    
    mov byte [readOnly], 0x01
    
.ok:                            ; (directly jump here if no args given)
    xor dx, dx
	mov ah, 0Eh
	int 21h

	mov al, byte [0x1FFF]       ; save color
	mov byte [color], al
	
	mov ch, 32
	mov ah, 1
	mov al, 3			
	int 0x10
	
	mov ax, VIDEO_MEMORY_SEGMENT ; set gs to point to the video memory
	mov gs, ax
	
	xor ax, ax                   ; zero out fs (this will be our segment address for the rest of the execution)
	mov fs, ax
	
	mov dx, (createColor(BLACK, BRIGHT_YELLOW)<<8)+(20h) ; standart color is yellow on black
	call cls
	
	call setupScreen        ; set up the cli gui
	
	call drawPosition       ; draw the position string (segment:offset)
	
	mov dx, word [cursor]   ; copy cursor position
	mov al, createColor(WHITE, BLACK) ; cursor color is black on white
	call drawCursor         ; draw the cursor
	
	jmp main
;==========================================


;==========================================	
main:
	call renderMemoryHex    ; draw the data in hex representation
	call renderMemoryASCII  ; draw the data in ascii right next to it
	xor ax, ax              ; wait for user input
	int 0x16
	
	cmp ah, 0x49   ; page up key, move 16 bytes backwards
	je .scrollUp
	
	cmp ah, 0x51   ; page down key, move 16 bytes forwards
	je .scrollDown
	
    
    ; arrow keys navigate the cursor (wont autoscroll)
	cmp ah, 0x48    ; arrow key up
	je .moveUp
	cmp ah, 0x4B    ; arrow key left
	je .moveLeft
	cmp ah, 0x4D    ; arrow key right
	je .moveRight
	cmp ah, 0x50    ; arrow key down
	je .moveDown
	
	cmp ah, 0x3B    ; F1 key shows help
	je .showHelp
	
	cmp ah, 0x3C    ; F2 key sets the offset address
	je .setOffset
    
    cmp ah, 0x3D    ; F3 key sets the segment address
    je .setSegment
	
	cmp ah, 0x01    ; ESC exits
	je .exit
	
	cmp ah, 0x1C    ; press enter to edit the selected byte
	je .edit
	
	jmp main
	
.scrollUp:
	sub word [offsetAdr], 0x10
	call drawPosition
	jmp main
	
.scrollDown:
	add word [offsetAdr], 0x10
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

    cmp byte [readOnly], 0x01
    je main

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
.setSegment:
    call backupDispBuffer

	mov si, inputStr2
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
	mov word [segmentAdr], cx
	
	call restoreDispBuffer
	
	call drawPosition
	
    mov ax, word [segmentAdr]
    mov fs, ax
    
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

displayBackupMemory db 0x00
