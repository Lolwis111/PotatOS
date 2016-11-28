; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % shutdown kann den Computer herunterfahren    %
; % und neustarten.                              %
; % Herunterfahren funktioniert hauptsächlich    %
; % auf alten Computern, reboot auf fast allen.  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

%include "defines.asm"

start:
	mov bx, ax

	cmp byte [bx], 'S'
	je shutdown

	cmp byte [bx], 'R'
	je reboot
	
	cmp byte [bx], 'H'
	je help
	
noargs:
	mov ah, 01h
	mov dx, .noArg
	mov bl, byte [SYSTEM_COLOR]
	int 21h
	
	xor bx, bx
	xor ax, ax
	int 21h
.noArg  db 0Dh, 0Ah
%ifdef german
        db "Syntaxfehler."
        db 0Dh, 0Ah
        db "Benutzen sie 'shutdown h' fuer Hilfe."
%elif english
        db "Syntaxerror."
        db 0Dh, 0Ah
        db "Use 'shutdown h' to get help"
%endif
        db 0Dh, 0Ah, 00h

help:
	mov ah, 01h
	mov dx, .msgHelp
	mov bl, byte [SYSTEM_COLOR]
	int 21h
	
	xor bx, bx
	int 21h
	
.msgHelp	db 0Dh, 0Ah, "shutdown [r|s|h]"
%ifdef german
			db 0Dh, 0Ah, "   r Neustart"
			db 0Dh, 0Ah, "   s Ausschalten"
			db 0Dh, 0Ah, "   h Hilfe"
%elif english
            db 0Dh, 0Ah, "   r restart"
            db 0Dh, 0Ah, "   s shutdown"
            db 0Dh, 0Ah, "   h help"
%endif
			db 0Dh, 0Ah, 00h

reboot:
	xor ax, ax
	mov ds, ax
	mov word [ds:0x0472], 0x1234
	jmp 0xF000:0xFFF0
	cli
	hlt
	
shutdown:
	mov ax, 5300h	; APM Prüfen
	xor bx, bx		; Geräte-ID
	int 15h
	jc errorAPM

	mov ax, 5304h	; Verbindung zu allen APM-Geräten trennen
	xor bx, bx		; Geräte-ID
	int 15h
	jc .discconectError
	jmp .noError
	
.discconectError:
	cmp ah, 03h
	jne errorAPM
	
.noError:
	mov ax, 5301h	; RealMode Interface ansprechen
	xor bx, bx		; Geräte-ID
	int 15h
	jc errorAPM
	
	mov ax, 5308h	; Energieverwaltung
	mov bx, 0001h	; bei allen Geräten
	mov cx, 0001h	; aktivieren
	int 15h
	jc errorAPM
	
	mov ax, 5307h	; Zustand
	mov bx, 0001h	; bei allen Geräten
	mov cx, 0003h	; auf 'off'
	int 15h
	jc errorAPM
	
	cli				; CPU Anhalten (für den Fall dass APM nicht funktioniert, was leider
                    ; sehr wahrscheinlich ist :(
	hlt
	
errorAPM:
	mov ah, 01h
	mov bl, 04h
	mov dx, .apmerror
	int 21h
	
	mov bx, 1
	xor ax, ax
	int 21h
	
%ifdef german
.apmerror db 0Dh, 0Ah, "Fehler im APM-Interface", 0Dh, 0Ah, 00h
%elif english
.apmerror db 0Dh, 0Ah, "Error in the APM interface", 0Dh, 0Ah, 00h
%endif
