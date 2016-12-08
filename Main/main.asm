; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Die Kommandozeile von PotatOS. Untetstützt   %
; % Farben und ist das Hauptprogramm.            %
; % include/commands.asm enthält die verfügbaren %
; % Befehle.                                     %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x2000]
[BITS 16]

%include "defines.asm"
%include "language.asm"

start:
	mov si, CLI_WELCOME ; Willkommensnachricht
	call Puts ; Ausgaben
	
	jmp SOFTWARE_BASE

; ====================================================
; Main-Funtkion des Kernels (Kommandozeile)
; ====================================================
main:
	nop
    nop
    nop
	call clearBuffer
	
	mov bl, byte [SYSTEM_COLOR]
	mov dx, ready
	mov ah, 01h
	int 21h
	
	mov dx, inputBuffer
	mov ah, 04h
	mov cx, 64
	int 21h
	
	mov si, inputBuffer
	call UpperCase
	
	call parseCommands

%ifdef _DEBUG
    mov di, command
    mov si, cmdDUMP
    mov ah, 02h
    int 21h
    test al, al
    je dump_all
%endif

	mov di, command
	mov si, cmdLS
	mov ah, 02h
	int 21h
	test al, al
	je view_dir

    mov di, command
    mov si, cmdLL
    mov ah, 02h
    int 21h
    test al, al
    je view_dir_2

	mov di, command
	mov si, cmdHELP
	mov ah, 02h
	int 21h
	test al, al
	je view_help
	
	mov di, command
	mov si, cmdTIME
	mov ah, 02h
	int 21h
	test al, al
	je show_time
	
	mov di, command
	mov si, cmdDATE
	mov ah, 02h
	int 21h
	test al, al
	je show_date
	
	mov di, command
	mov si, cmdINFO
	mov ah, 02h
	int 21h
	test al, al
	je show_version

	mov di, command
	mov si, cmdCOLOR
	mov ah, 02h
	int 21h
	test al, al
	je change_color
	
	mov di, command
	mov si, cmdCLEAR
	mov ah, 02h
	int 21h
	test al, al
	je clear_screen
	
	mov di, command
	mov si, cmdRENAME
	mov ah, 02h
	int 21h
	test al, al
	je rename_file

	mov di, command
	mov si, cmdDEL
	mov ah, 02h
	int 21h
	test al, al
	je delete_file
	
	call look_extern
	
	jmp main
; ====================================================
	
	
; ====================================================
; Includeangaben
; ====================================================
%include "commands.asm"
%include "strings.asm"
%include "common.asm"

%include "main_util.asm" ; enthält allgemeine Befehle
%include "main_file.asm" ; enthält die Dateioperationsbefehle
%include "main_ls.asm"   ; enthält die Implementierung von 'ls' und 'll'

newLine db 0Dh, 0Ah, 00h
ready db "CMD> ", 00h
; ====================================================
	

; ====================================================
parseCommands:
	mov si, command
	call UpperCase
	
	mov si, inputBuffer
	mov di, command
	xor cx, cx
.skipLoop:
	lodsb
	inc cx
	cmp al, 0x20	; Leerzeichen
	je .copy
	cmp al, 0x00
	je .return
	mov byte [di], al
	inc di
	jmp .skipLoop
.copy:
	mov di, cmdargument ; alles ab dem ersten Leerzeichen (aber maximal 64 Bytes)
	mov ax, 64          ; in das Argument kopieren
	sub ax, cx
	mov cx, ax
	rep movsb	
.return:
	ret
; ====================================================
	
	
; ====================================================
; Zeigt die Hilfe an	
; ====================================================
view_help:
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01					; Hilfe ausgeben
	mov dx, HELP
	int 21h
	
	jmp main
; ====================================================


; ====================================================	
show_version:
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, .lblName
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, .lblVersion
	int 0x21

	
	mov ah, 0x08
	int 0x21
	; AH -> Majorversion
	; AL -> Minorversion
	push ax
	
	mov dh, ah
	add dh, 48
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 0x10
	int 0x21
	
	mov dh, '.'
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 0x10
	int 0x21
	
	pop ax
	
	mov dh, al
	add dh, 48
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 0x10
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21

    mov ah, 0x0C
    int 0x21
    push bx
    mov dx, ax
    mov ah, 0x01
    mov bl, byte [SYSTEM_COLOR]
    int 0x21

    mov ah, 0x01
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 0x21

    pop bx

    mov dx, bx
    mov ah, 0x01
    mov bl, byte [SYSTEM_COLOR]
    int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21
	
	jmp main

.lblVersion db "Version: ", 00h
.lblName    db "PotatOS (C)", DEV_YEAR_S, "-", DEV_YEAR_C, 0x0D, 0x0A, 0x00
.number 	db "00000", 0x00, 0x00, 0x00
;====================================================


; ====================================================
; Versucht einen Befehl als externe Datei zu starten	
; ====================================================
look_extern:
	mov al, '.'
	mov si, command
	call StringLength

	cmp cx, 0x00
	je .noExt
	
	mov si, command
	add si, cx
	mov di, programExt
	mov cx, 4
	rep cmpsb
	jne .eError
	jmp .extOk
	
.noExt: ; Prüfen ob ein Programm ohne Dateiendung eingegeben wurde
	mov al, 0x00
	mov si, command
	call StringLength
	
	mov si, command         ; Manuell die Dateiendung anfügen
	add si, cx              ; um zu prüfen ob das Programm einfach nur ohne
	mov byte [si], '.'      ; Erweiterung aufgerufen wurde
	mov byte [si+1], 'B'
	mov byte [si+2], 'I'
	mov byte [si+3], 'N'
	
.extOk:
	mov si, command			; Dateiname an FAT12 anpassen
	mov di, rFileName
	call AdjustFileName
	cmp ax, -1
	je .error

.load:
	mov dx, rFileName		; Datei in den Speicher laden
	xor bx, bx
	mov bp, SOFTWARE_BASE   ; Basisadresse (in der Regel 0x0000:0x9000)
	mov ah, 0x05
	int 0x21
	cmp ax, -1
	je .error

    ; Größe des Programms direkt vor das Programm
    ; schreiben (für Speicherverwaltung)
    ; mov word [0x0000:SOFTWARE_BASE - 2], cx

	mov ax, cmdargument
	jmp SOFTWARE_BASE		; und in das Programm springen
	
.error:						; Allgemeiner Fehler
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, LOAD_ERROR
	int 0x21
	ret
	
.eError:					; Keine-BIN-Datei-Fehler
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, NO_PROGRAM
	int 0x21
	ret
; ====================================================

	
; ====================================================
show_time:				; Zeigt die Zeit an (z.B. 12:04 Uhr)
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21
	
	mov ah, 0x06
	int 0x21

	mov ah, 0x01
    mov bl, byte [SYSTEM_COLOR]
	int 0x21

    mov ah, 0x01
    mov dx, newLine
    mov bl, byte [SYSTEM_COLOR]
    int 0x21

	jmp main
; ====================================================
	

; ====================================================
show_date:				;Zeigt das Datum an	(z.B. 12.03.2014)
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	mov dx, newLine
	int 0x21
	
	mov ah, 0x07
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	int 0x21

    mov bl, byte [SYSTEM_COLOR]
    mov dx, newLine
    mov ah, 0x01
    int 0x21

	jmp main
; ====================================================


; ====================================================
; Textausgabe ohne INT 21
; ====================================================
Puts:
	lodsb
	or al, al
	jz .return
	mov ah, 0x0E
	int 0x10
	jmp Puts
.return:
	ret
; ====================================================


; ====================================================
; Löscht den Eingabepufferspeicher
; ====================================================
clearBuffer:
	push si
	push di
	push bp

	mov cx, 64
	mov di, command
	mov si, cmdargument
	mov bp, inputBuffer
.L1:
	mov byte [di], 00h
	mov byte [bp], 00h
	mov byte [si], 00h
	inc di
	inc si
	inc bp

    dec cx
    cmp cx, 00h
    ja .L1

	mov cx, 11
	mov di, rFileName
.L2 :
	mov byte [di], 00h
	inc di
	dec cx
    cmp cx, 00h
	ja .L2

    pop bp
	pop di
	pop si

	ret
; ====================================================


programExt	db ".BIN"						; Dateierweiterung eines Programms
fileName 	db "             ", 00h			; Dateiname, Eingabeformat	(z.B. TEST.BIN)
rFileName	db "           ", 0Dh, 0Ah, 00h	; Dateiname, FAT12-Format	(z.B. TEST    BIN)
ldir		db "   <DIR>", 00h
msgWelcome	db "BOOT OK.", 0Dh, 0Ah, 00h
inputBuffer 	times 64 db 00h
cmdargument 	times 64 db 00h
command 		times 64 db 00h
commandLength	dw 0000h
