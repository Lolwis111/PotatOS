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
	call clearBuffer
	
	mov bl, byte [0x1FFF]
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
; %include "language.asm"

%include "main_util.asm" ; enthält allgemeine Befehle
%include "main_file.asm" ; enthält die Dateioperationsbefehle
%include "main_ls.asm"

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
	cmp al, 20h	; Leerzeichen
	je .copy
	cmp al, 00h
	je .return
	mov byte [di], al
	inc di
	jmp .skipLoop
.copy:
	mov di, cmdargument
	mov ax, 64
	sub ax, cx
	mov cx, ax
	rep movsb
	ret	
.return:
	ret
; ====================================================
	
	
; ====================================================
; Zeigt die Hilfe an	
; ====================================================
view_help:
	mov bl, byte [0x1FFF]
	mov ah, 01h					; Hilfe ausgeben
	mov dx, HELP
	int 21h
	
	jmp main
; ====================================================


; ====================================================	
show_version:
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, .lblName
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, .lblVersion
	int 21h

	
	mov ah, 08h
	int 21h
	; AH -> Majorversion
	; AL -> Minorversion
	push ax
	
	mov dh, ah
	add dh, 48
	mov dl, byte [0x1FFF]
	mov ah, 10h
	int 21h
	
	mov dh, '.'
	mov dl, byte [0x1FFF]
	mov ah, 10h
	int 21h
	
	pop ax
	
	mov dh, al
	add dh, 48
	mov dl, byte [0x1FFF]
	mov ah, 10h
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h

    mov ah, 0Ch
    int 21h
    push bx
    mov dx, ax
    mov ah, 01h
    mov bl, byte [0x1FFF]
    int 21h

    mov ah, 01h
    mov dx, newLine
    mov bl, byte [0x1FFF]
    int 21h

    pop bx

    mov dx, bx
    mov ah, 01h
    mov bl, byte [0x1FFF]
    int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	jmp main

.lblVersion db "Version: ", 00h
.lblName    db "PotatOS (C)", DEV_YEAR_S, "-", DEV_YEAR_C, 0Dh, 0Ah, 00h
.number 	db "00000", 00h, 00h, 00h
;====================================================


; ====================================================
; Versucht einen Befehl als externe Datei zu starten	
; ====================================================
look_extern:
	mov al, '.'
	mov si, command
	call StringLength

	cmp cx, 00h
	je .noExt
	
	mov si, command
	add si, cx
	mov di, programExt
	mov cx, 3
	rep cmpsb
	jne .eError
	jmp .extOk
	
.noExt: ; Prüfen ob ein Programm ohne Dateiendung eingegeben wurde
	mov al, 00h
	mov si, command
	call StringLength
	
	mov si, command
	add si, cx
	mov byte [si], '.'
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
	mov bp, SOFTWARE_BASE
	mov ah, 05h
	int 21h
	cmp ax, -1
	je .error
		
	mov ax, cmdargument
	jmp SOFTWARE_BASE		; und Programm ausführen
	
.error:						; Allgemeiner Fehler
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, LOAD_ERROR
	int 21h
	ret
	
.eError:					; Keine-BIN-Datei-Fehler
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, NO_PROGRAM
	int 21h
	ret
; ====================================================

	
; ====================================================
show_time:				; Zeigt die Zeit an (z.B. 12:04 Uhr)
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	mov ah, 06h
	int 21h

	mov ah, 01h
    mov bl, byte [0x1FFF]
	int 21h

    mov ah, 01h
    mov dx, newLine
    mov bl, byte [0x1FFF]
    int 21h

	jmp main
; ====================================================
	

; ====================================================
show_date:				;Zeigt das Datum an	(z.B. 12.03.2014)
	mov bl, byte [0x1FFF]
	mov ah, 01h
	mov dx, newLine
	int 21h
	
	mov ah, 07h
	int 21h
	
	mov bl, byte [0x1FFF]
	mov ah, 01h
	int 21h

    mov bl, byte [0x1FFF]
    mov dx, newLine
    mov ah, 01h
    int 21h

	jmp main
; ====================================================


; ====================================================
; Textausgabe ohne INT 21
; ====================================================
Puts:
	lodsb
	or al, al
	jz .return
	mov ah, 0Eh
	int 10h
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
.loop:
	mov byte [di], 00h
	mov byte [bp], 00h
	mov byte [si], 00h
	inc di
	inc si
	inc bp
	dec cx
	jnz .loop

	mov cx, 11
	mov di, rFileName
	mov bp, rArgument
.loop1:
	mov byte [di], 00h
	mov byte [bp], 00h
	inc di
	inc bp
	dec cx
	jnz .loop1

	pop bp
	pop di
	pop si
	ret
; ====================================================


programExt	db ".BIN"						; Dateierweiterung eines Programms
fileName 	db "             ", 00h			; Dateiname, Eingabeformat	(z.B. TEST.BIN)
rFileName	db "           ", 0Dh, 0Ah, 00h	; Dateiname, FAT12-Format	(z.B. TEST    BIN)
rArgument	db "           ", 0Dh, 0Ah, 00h ; Argument, FAT12-Format	(z.B. TEST    TXT)
; spacer 		db "          ", 00h
spacer2     db " | ", 00h
ldir		db "   <DIR>", 00h
msgWelcome	db "BOOT OK.", 0Dh, 0Ah, 00h
inputBuffer 	times 64 db 00h
cmdargument 	times 64 db 00h
command 		times 64 db 00h
commandLength	dw 0000h