[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%include "strings.asm"
%include "language.asm"

%define COLOR createColor(BLACK, WHITE)
%define FILE_OFFSET 0x9500

; ===============================================
start:
	push ax
    mov dh, COLOR
    mov dl, 0x20
	call clearScreen
	pop ax
	
	cmp ax, -1			; Prüfen ob Argument vorhanden ist
	je .noArgument		; Nein?

	mov si, ax			; Wenn ja dann Datei aus dem Argument laden
	mov di, fileName
	call AdjustFileName
	
	mov dx, fileName
	xor bx, bx
	mov bp, FILE_OFFSET
	mov ah, 05h
	int 21h				; Datei laden
	mov word [fileLenght], cx
	cmp ax, -1
	je .error
	
	jmp init
	
.noArgument:
	mov dx, msgFile			; Dateiname von Eingabe holen
	mov ah, 01h
    mov bl, COLOR
	int 21h
	mov dx, input
	mov ah, 04h
	mov cx, 11
	int 21h
	
	mov si, input			; In Großbuchstaben wandeln
	call UpperCase
	
	mov si, input			; Dateiname an FAT12 anpassen
	mov di, fileName
	call AdjustFileName
	cmp ax, -1
	je .error
	
	mov dx, fileName		; Datei laden
	xor bx, bx
	mov bp, FILE_OFFSET
	mov ah, 05h
	int 21h
	mov word [fileLenght], cx
	cmp ax, -1
	je .error

	jmp init
	
.error:
	mov dx, newLine
    mov bl, COLOR
    mov ah, 01h
	int 21h
	
	mov dx, FILE_NOT_FOUND_ERROR		; Fehlermeldung anzeigen
    mov bl, COLOR
	mov ah, 01h
	int 21h
	
    mov bx, 1
    jmp exit
; ===============================================


; ===============================================
; Datensektion
; ===============================================
lblTop 		db 177
			times 11 db 20h
			times 148 db 177
			db 00h

%ifdef german
lblBottom 	times 81 db 177
			db 24, " Hochscrollen", 177, 25, " Runterscrollen", 177, "ESC Beenden", 177, "F5 Neu laden"
			times 22 db 177
			db 00h
%elif english
lblBottom   times 81 db 177
            db 24, " scroll up", 177, 25, " scroll down", 177, "ESC quit", 177, "F5 reload"
            times 34 db 177
            db 00h
%endif
			
linesToSkip	dw 00h
fileLenght 	dw 00h

%ifdef german
msgFile		db 0Dh, 0Ah, "Datei:", 00h
%elif english
msgFile     db 0Dh, 0Ah, "File:", 00h
%endif
newLine     db 0Dh, 0Ah, 00h
input		times 12 db 0
fileName	times 12 db 0
; ===============================================


; ===============================================
; Zusätzliche Funktionen
; ===============================================

	
; ===============================================
; die Titel bzw. Statusleiste ausgeben
; ===============================================
setUpScreen:
	xor dx, dx
    mov ah, 0Eh
    int 21h
	
	mov ah, 01h
    mov bl, COLOR
	mov dx, lblTop
	int 21h
	
	mov dl, 00
	mov dh, 23
    mov ah, 0Eh
    int 21h
	
	mov ah, 01h
    mov bl, COLOR
	mov dx, lblBottom
	int 21h
	
	ret
; ===============================================


; ===============================================
; ein einzelnes Zeichen ausgeben (ohne Veränderung
; der Cursorposition)
; >DL X
; >DH Y
; ===============================================
printChar:

    pusha
    
    push ax
    mov ax, dx
    movzx bx, dl
    movzx ax, dh
    shl bx, 1
	mov cx, 160
	mul cx
	add bx, ax
    pop ax
    mov word [gs:bx], ax
    
    popa
    
    ret
; ===============================================

	
; ===============================================
; den kompletten Bildschirm leeren
; ===============================================
clearScreen:
	pusha
	xor bx, bx
	mov cx, SCREEN_BUFFER_SIZE
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

	
; ===============================================
; die Position im Dokument in der Statusleiste
; ausgeben.
; ===============================================
renderPosition:
	mov dl, 73
	mov dh, 23
    mov ah, 0Eh
    int 21h
	
	mov ah, 03h
	mov dx, .positionString
	mov cx, word [linesToSkip]
	int 21h
    
	mov ah, 01h
    mov bl, COLOR
	mov dx, .positionString
	int 21h
	
	mov dl, 00
	mov dh, 02
    mov ah, 0Eh
    int 21h
    
	ret
.positionString db "00000", 00h
; ===============================================


; ===============================================
; Das Textfeld leeren
; ===============================================
clearTextArea:
    pusha
    mov bx, 320
    mov cx, 1680
    mov dl, 0x20
    mov dh, COLOR
.l1:
    mov word [gs:bx], dx
    add bx, 2
    loop .l1
    popa

    ret
; ===============================================


; ===============================================
; Den Inhalt der Datei im Textfeld ausgeben
; ===============================================
renderText:    
    call clearTextArea

    xor ax, ax
    mov es, ax
    mov esi, FILE_OFFSET
    cmp word [linesToSkip], 00h
    je .ok    
    
    xor dx, dx    
    xor cx, cx
.skipLoop:
    mov al, byte [es:esi]
    inc si
    inc cx
    
    cmp al, 0Ah
    je .skipNewLine
    
    cmp cx, 79
    je .skipNewLine
    
    jmp .skipLoop
    
.skipNewLine:
    inc dx
    xor cx, cx
    
    cmp dx, word [linesToSkip]
    je .ok
    
    jmp .skipLoop
    
.ok:
    ; ---------------
    ; |  BH  |  BL  |
    ; ---------------
    ; |  Y   |  X   |
    ; ---------------
    mov bx, 0200h
.charLoop:
    mov al, byte [es:esi]
    
    inc esi
    
    cmp al, 00h
    je .done
    cmp al, 0Ah
    je .newLine
    
    cmp al, 0Dh
    je .charLoop

    mov dx, bx
    mov ah, COLOR
    call printChar
    inc bl
    
    cmp bl, 79
    je .newLine
    
    jmp .charLoop

.newLine:
    xor bl, bl
    inc bh
    cmp bh, 21
    je .done

    jmp .charLoop
    
.done:
    ret
; ===============================================


; ===============================================
; Den Editor initalisieren
; ===============================================
init:
	mov word [linesToSkip], 00h

	call clearScreen
	call setUpScreen
	
	mov dl, 1
	mov dh, 0
    mov ah, 0Eh
    int 21h
	
	mov ah, 01h
    mov bl, COLOR
	mov dx, fileName
	int 21h
	
	xor dx, dx
	mov dx, 2
    mov ah, 0Eh
    int 21h
	
	call renderText
	call renderPosition
	
	jmp main
	
.error:
	mov ah, 01h
    mov bl, byte [SYSTEM_COLOR]
	mov dx, FILE_NOT_FOUND_ERROR 
	int 21h
	
    mov bx, 1
    jmp exit
; ===============================================


; ===============================================
; Hauptschleife des Programms
; ===============================================
main:
    call renderPosition
	call renderText
    
	mov ah, 00h
	int 16h

	cmp ah, 48h		; Pfeil-Hoch
	je .scrollUp
	
	cmp ah, 50h
	je .scrollDown	; Pfeil-Runter
	
	cmp ah, 3Fh     ; F5 Taste
	je init
	
	cmp ah, 01h		; Escape-Taste
	je regularExit
	
	jmp main
	
.scrollDown:

	inc word [linesToSkip]

	jmp main

.scrollUp:

	cmp word [linesToSkip], 00h
	je main
	
	dec word [linesToSkip]

	jmp main
; ===============================================
    
    
; ===============================================
; Programm beenden
; ===============================================
regularExit:
    xor bx, bx
exit:
	; Programm beenden
    mov dh, byte [SYSTEM_COLOR]
    mov dl, 0x20
	call clearScreen
    
	xor ax, ax
	int 21h
; ===============================================
