; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % shutdown can restart or shutdown your computer %
; % Restart should work on any x86 compatible      %
; % computer. Shutdown requires apm which is       %
; % mostly supported by older machines			   %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

%include "functions.asm"
%include "language.asm"

; ===========================================
start:
	mov bx, ax

	cmp byte [bx], 'S' ; one letter as an argument will do the job
	je shutdown

	cmp byte [bx], 'R'
	je reboot
	
	cmp byte [bx], 'H'
	je help
; ===========================================
	
	
; ===========================================
noargs: ; if there is no args, ask the user to try H for Help
    print .msgNoArg
	
	EXIT EXIT_SUCCESS
	
.msgNoArg db 0x0D, 0x0A
%ifdef german
        db "Syntaxfehler.\r\n"
        db "Benutzen sie 'shutdown h' fuer Hilfe."
%elif english
        db "Syntaxerror.\r\n"
        db "Use 'shutdown h' to get help"
%endif
        db "\r\n", 0x00
; ===========================================


; ===========================================
help: ; help prints a message
    print .msgHelp
	
	EXIT EXIT_SUCCESS ; and then exits

.msgHelp	db "\r\nshutdown [r|s|h]"
%ifdef german
			db "\r\n   r Neustart"
			db "\r\n   s Ausschalten"
			db "\r\n   h Hilfe"
%elif english
            db "\r\n   r restart"
            db "\r\n   s shutdown"
            db "\r\n   h help"
%endif
			db "\r\n", 0x00
; ===========================================			
			

; ===========================================
reboot:
	xor ax, ax
	mov ds, ax
	mov word [ds:0x0472], 0x1234
	jmp 0xF000:0xFFF0
	cli
	hlt
; ===========================================
	
	
; ===========================================
shutdown:
	mov ax, 0x5300	; check for APM
	xor bx, bx		; device ID
	int 0x15
	jc errorAPM

	mov ax, 0x5304	; disconnect any APM devices 
	xor bx, bx		; device ID
	int 0x15
	jc .discconectError
	jmp .noError
	
.discconectError:
	cmp ah, 0x03
	jne errorAPM
	
.noError:
	mov ax, 0x5301	; activiate real mode interface
	xor bx, bx		; device ID
	int 0x15
	jc errorAPM
	
	mov ax, 0x5308	; select energy management
	mov bx, 0x0001	; on all devices
	mov cx, 0x0001	; and set it to active
	int 0x15
	jc errorAPM
	
	mov ax, 0x5307	; now turn all the 
	mov bx, 0x0001	; device off
	mov cx, 0x0003	; 
	int 0x15
; ===========================================
	
	
; ===========================================
errorAPM:
	print .msgApmError, 0x04 ; if stuff wont work we print a message
    
    print SHUTDOWN
    
    cli ; and stop the cpu
    hlt
	
.msgApmError db "\r\n"
%ifdef german 
    db "Fehler im APM-Interface"
%elif english
    db "Error in the APM interface"
%endif
    db "\rr\n", 0x00
; ===========================================
