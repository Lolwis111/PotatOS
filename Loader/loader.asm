; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stage2 Bootloader. Bereitet das System vor   %
; % indem es alle wichtigen Dateien lädt.        %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x500]
[BITS 16]

jmp main16

; ==================================================================
; NASM Befehle
; ==================================================================
%include "fat12.asm"
%include "common.asm"
%include "defines.asm"
; ==================================================================

Print:
	lodsb
	or al, al
	jz .return
	mov ah, 0Eh
	int 10h
	jmp Print
.return:
	ret


msgError		db 0Dh, 0Ah, "FATAL: MISSING SYSTEM FILE!", 00h
				db 0Dh, 0Ah, "PRESS ANY KEY TO REBOOT", 0Dh, 0Ah, 00h
msgHello		db 0Dh, 0Ah, "Loading files...", 0Dh, 0Ah, 0Dh, 0Ah, 00h

; ==================================================================	
main16:
	cli
	xor ax, ax      ; alle Segmentregister nullen
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ax, 0x3000  ; Stack nach 3000:0000 legen
	mov ss, ax
	xor sp, sp
	sti
	
	mov ax, 0003h	; Textmodus, 80x25 Zeichen, 16 Farben
	int 10h
	mov ax, 1003h	; blinkende Schrift deaktivieren
	xor bx, bx
	int 10h
	
	mov si, msgHello
	call Print

    call LoadRoot               ; Lädt die Datei strings.dat an die Adresse 0000:8000
    xor bx, bx
    mov bp, STRINGS_SYS
    mov si, Strings
    call LoadFile
    cmp ax, -1
    je .error

	call LoadRoot				; Lädt die Datei system.sys an die Adresse 0000:1000
	xor bx, bx
	mov bp, SYSTEM_SYS
	mov si, Driver
	call LoadFile
	cmp ax, -1
	je .error

	call LoadRoot				; Lädt die Datei sinit.sys an die Adresse 0000:9000
	mov si, sinit		
	xor bx, bx
	mov bp, SOFTWARE_BASE
	call LoadFile
	cmp ax, -1
	je .error

	call LoadRoot				; Lädt die Datei main.sys an die Adresse 0000:2000
	xor bx, bx
	mov bp, MAIN_SYS
	mov si, ImageName
	call LoadFile
	cmp ax, -1
	je .error
	
	jmp 0x2000
	
.error:                         ; Fehlermeldung wenn eine Datei fehlt
	mov si, msgError
	call Print
	xor ax, ax
	int 16h
	int 19h                     ; Warm-Reboot
.colorByte db 00h
; ==========================================


; ==========================================
; Löscht den Bildschirminhalt
; ==========================================
clearScreen:
	mov ax, 0xB800
	mov gs, ax
	xor bx, bx
	mov cx, 2000
.clearLoop:
	inc bx
	mov byte [gs:bx], dl
	inc bx
	loop .clearLoop
	ret
; ==========================================
