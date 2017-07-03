; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % shutdown kann den Computer herunterfahren    %
; % und neustarten.                              %
; % Herunterfahren funktioniert hauptsächlich    %
; % auf alten Computern, reboot auf fast allen.  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

%include "defines.asm"
%include "functions.asm"

start:
	mov bx, ax

	cmp byte [bx], 'S'
	je shutdown

	cmp byte [bx], 'R'
	je reboot
	
	cmp byte [bx], 'H'
	je help
	
noargs:
    print .noArg
	
	EXIT 0
    
.noArg db 0x0D, 0x0A

%ifdef german
        db "Syntaxfehler."
        db 0x0D, 0x0A
        db "Benutzen sie 'shutdown h' fuer Hilfe."
%elif english
        db "Syntaxerror."
        db 0x0D, 0x0A
        db "Use 'shutdown h' to get help"
%endif
        db 0x0D, 0x0A, 0x00

help:
    print .msgHelp
	
	EXIT 0
	
.msgHelp	db 0x0D, 0x0A, "shutdown [r|s|h]"
%ifdef german
			db 0x0D, 0x0A, "   r Neustart"
			db 0x0D, 0x0A, "   s Ausschalten"
			db 0x0D, 0x0A, "   h Hilfe"
%elif english
            db 0x0D, 0x0A, "   r restart"
            db 0x0D, 0x0A, "   s shutdown"
            db 0x0D, 0x0A, "   h help"
%endif
			db 0x0D, 0x0A, 0x00

reboot:
	xor ax, ax
	mov ds, ax
	mov word [ds:0x0472], 0x1234
	jmp 0xF000:0xFFF0
	cli
	hlt
	
shutdown:
	mov ax, 0x5300	; APM Prüfen
	xor bx, bx		; Geräte-ID
	int 0x15
	jc errorAPM

	mov ax, 0x5304	; Verbindung zu allen APM-Geräten trennen
	xor bx, bx		; Geräte-ID
	int 0x15
	jc .discconectError
	jmp .noError
	
.discconectError:
	cmp ah, 0x03
	jne errorAPM
	
.noError:
	mov ax, 0x5301	; RealMode Interface ansprechen
	xor bx, bx		; Geräte-ID
	int 0x15
	jc errorAPM
	
	mov ax, 0x5308	; Energieverwaltung
	mov bx, 0x0001	; bei allen Geräten
	mov cx, 0x0001	; aktivieren
	int 0x15
	jc errorAPM
	
	mov ax, 0x5307	; Zustand
	mov bx, 0x0001	; bei allen Geräten
	mov cx, 0x0003	; auf 'off'
	int 0x15
	jc errorAPM
	
	cli				; CPU Anhalten (für den Fall dass APM nicht funktioniert, was leider
                    ; sehr wahrscheinlich ist :(
	hlt
	
errorAPM:
	print .apmerror, 0x04
    
	EXIT 1
	
.apmerror db 0x0D, 0x0A
%ifdef german 
    db "Fehler im APM-Interface"
%elif english
    db "Error in the APM interface"
%endif
    db 0x0D, 0x0A, 0x00
