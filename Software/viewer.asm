; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt ein einfaches Programm zur Bild-      %
; % anzeige dar. Kann *.llp Bilder anzeigen.     %
; % TODO: LLP Dokumentation                      %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start


%include "strings.asm"
%include "language.asm"
%include "defines.asm"

; msgLoading	db 0Dh, 0Ah, "Die Datei wird geladen...", 0Dh, 0Ah, 00h
msgFile		db 0Dh, 0Ah, "Datei:", 00h
input		times 12 db 0
fileName	times 12 db 0
reg_es		dw 0000h

; =====================================================================
start:
	mov bx, ax
	cmp byte [bx], 00h	;Prüfen ob Argument vorhanden ist
	je .noArgument		;Nein?

	mov si, ax			;Wenn ja dann Datei aus dem Argument laden
	mov di, fileName
	call AdjustFileName
	
	mov dx, fileName
	xor bx, bx
	mov ebp, 0x9200 
	mov ah, 05h
	int 21h				;Datei laden
	cmp ax, -1
	je .error
	
	jmp init
; =====================================================================	


; =====================================================================
.noArgument:
	mov dx, msgFile			;Dateiname von Eingabe holen
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 01h
	int 21h
	mov dx, input
	mov ah, 04h
	mov cx, 11
	int 21h
	
	mov si, input			;In Großbuchstaben wandeln
	call UpperCase
	
	mov si, input			;Dateiname an FAT12 anpassen
	mov di, fileName
	call AdjustFileName
	cmp ax, -1
	je .error
	
	mov dx, fileName
	xor bx, bx
	mov ebp, 0x9200
	mov ah, 05h
	int 21h				;Datei laden
	cmp ax, -1
	je .error
	jmp init
	
.error:
	mov dx, FILE_NOT_FOUND_ERROR		;Fehlermeldung anzeigen
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 01h
	int 21h
	
	mov bx, 1
	xor ax, ax
	int 21h
; =====================================================================
	
	
; =====================================================================
exitV:
	xor ax, ax
	int 16h

	mov ax, 0003h
	int 10h
	
	mov ax, word [reg_es]
	mov es, ax
	
.clear_screen:
	mov ax, VIDEO_MEMORY_SEGMENT
	mov gs, ax
	xor bx, bx
	mov cx, SCREEN_BUFFER_SIZE
	mov al, byte [SYSTEM_COLOR]
.clearLoop:
	inc bx
	mov byte [gs:bx], al
	inc bx
	loop .clearLoop
	
	xor bx, bx
	xor ax, ax
	int 21h
;======================================================================


; =====================================================================	
init:
	mov ax, es
	mov word [reg_es], ax
	
	; Grafikmodus aktivieren, 320x200, 256 Farben
	mov ax, 0013h
	int 10h
	
	mov ax, 0x920
	mov es, ax
	mov esi, 03h

	mov ah, 0Ch
	mov bh, 00h
	xor cx, cx		;X
	xor dx, dx		;Y
; ======================================================================
	
	
; ======================================================================
loopX:
	movzx bp, byte [es:esi]
	inc esi
	
	mov al, byte [es:esi]
	inc esi
	
.drawLoop:
	inc cx
	int 10h
	sub bp, 1
	jnz .drawLoop
	
	cmp cx, 320
	je .newLine
	jmp loopX
	
.newLine:
	xor cx, cx
	add dx, 1
	cmp dx, 200
	je exitV
	
	jmp loopX
; ======================================================================
