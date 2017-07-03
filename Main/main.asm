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
%include "functions.asm"

start:
	mov si, CLI_WELCOME ; Willkommensnachricht
	call Puts ; Ausgeben
	
	jmp SOFTWARE_BASE

; ====================================================
; Main-Funtkion des Kernels (Kommandozeile)
; ====================================================
main:
	nop
    nop
    nop
	call clearBuffer
    
    print ready
	
    readline inputBuffer, 64
	
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

    strcmp command, cmdLS
    je view_dir

    strcmp command, cmdLL
    je view_dir_2

	strcmp command, cmdHELP
	je view_help
	
	strcmp command, cmdTIME
	je show_time
	
	strcmp command, cmdDATE
	je show_date
	
	strcmp command, cmdINFO
	je show_version

	strcmp command, cmdCOLOR
	je change_color
	
	strcmp command, cmdCLEAR
	je clear_screen
	
	strcmp command, cmdRENAME
	je rename_file

	strcmp command, cmdDEL
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
    print HELP ; Hilfe ausgeben
	
	jmp main
; ====================================================


; ====================================================	
show_version:
    print newLine
    
    print newLine
	
    print .lblName
    
    print .lblVersion
	
	mov ah, 08h
	int 21h
	; AH -> Majorversion
	; AL -> Minorversion
	push ax
	
	mov dh, ah
	add dh, 48
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 10h
	int 21h
	
	mov dh, '.'
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 10h
	int 21h
	
	pop ax
	
	mov dh, al
	add dh, 48
	mov dl, byte [SYSTEM_COLOR]
	mov ah, 10h
	int 21h
	
    print newLine

    mov ah, 0Ch
    int 21h
    push bx
    print ax

    print newLine

    pop bx

    print bx
	
	print newLine
	
	jmp main

.lblVersion db "Version: ", 0x00
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
	mov cx, 0x04
	rep cmpsb
	jne .eError
	jmp .extOk
	
.noExt: ; Prüfen ob ein Programm ohne Dateiendung eingegeben wurde
	mov al, 00h
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
	jmp SOFTWARE_BASE ; und in das Programm springen
	
.error: ; Allgemeiner Fehler
    print LOAD_ERROR
	ret
	
.eError: ; Keine-BIN-Datei-Fehler
    print NO_PROGRAM
	ret
; ====================================================

	
; ====================================================
show_time:				; Zeigt die Zeit an (z.B. 12:04 Uhr)
    print newLine
    
	mov ah, 0x06
	int 0x21

	mov ah, 0x01
    mov bl, byte [SYSTEM_COLOR]
	int 0x21
    
    print newLine

	jmp main
; ====================================================
	

; ====================================================
show_date:				;Zeigt das Datum an	(z.B. 12.03.2014)
	print newLine
	
	mov ah, 0x07
	int 0x21
	
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 0x01
	int 0x21

    print newLine

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
.Loop1:
	mov byte [di], 0x00
	mov byte [bp], 0x00
	mov byte [si], 0x00
	inc di
	inc si
	inc bp

    dec cx
    cmp cx, 00h
    ja .Loop1

	mov cx, 11
	mov di, rFileName
.Loop2 :
	mov byte [di], 0x00
	inc di
	dec cx
    cmp cx, 0x00
	ja .Loop2

    pop bp
	pop di
	pop si

	ret
; ====================================================


programExt	db ".BIN"						    ; Dateierweiterung eines Programms
fileName 	db "             ", 0x00			; Dateiname, Eingabeformat	(z.B. TEST.BIN)
rFileName	db "           ", 0x0D, 0x0A, 0x00	; Dateiname, FAT12-Format	(z.B. TEST    BIN)
ldir		db "   <DIR>", 0x00
msgWelcome	db "BOOT OK.", 0x0D, 0x0A, 0x00
inputBuffer 	times 64 db 0x00
cmdargument 	times 64 db 0x00
command 		times 64 db 0x00
commandLength	dw 0x0000
