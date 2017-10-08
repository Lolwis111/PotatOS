; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % stage2 bootloader. loads all the important   %
; % files and does some initalisation            %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x500]
[BITS 16]

jmp start

%include "fat12.asm"
%include "common.asm"
%include "defines.asm"

; ====================================================================================
Print:
	lodsb
	or al, al
	jz .return
	mov ah, 0x0E
	int 0x10
	jmp Print
.return:
	ret
; ====================================================================================
    
    
; ====================================================================================
msgError1		db 0x0D, 0x0A, "strings.sys missing!", 0x00
msgError2		db 0x0D, 0x0A, "system.sys missing!", 0x00
msgError3		db 0x0D, 0x0A, "sysinit.sys missing!", 0x00
msgHello		db 0x0D, 0x0A, "Loading files...", 0x0D, 0x0A, 0x0D, 0x0A, 0x00
; ====================================================================================


; ====================================================================================
start:
	cli
	xor ax, ax      ; zero out all the segments
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ax, 0x3000  ; put stack to 0x3000:0x0000
	mov ss, ax
	xor sp, sp
	sti
	
	mov ax, 0x0003	; go into 16 color, 80x25 chars textmode
	int 0x10
	mov ax, 0x1003	; we do not need blinking
	xor bx, bx
	int 0x10
	
	mov si, msgHello
	call Print
    
    call LoadRoot               ; load 'strings.sys' at 0x0000:0x8000
    xor bp, bp
    mov bx, STRINGS_SYS
    mov si, Strings
    call ReadFile
    jc .error1

	call LoadRoot				; load 'system.sys' 0x0000:0x1000
	xor bp, bp
	mov bx, SYSTEM_SYS
	mov si, Driver
	call ReadFile
	jc .error2

	call LoadRoot				; load 'sysinit.sys' at 0x0000:0x9000
	xor bp, bp
	mov bx, SOFTWARE_BASE
    mov si, Sysinit
	call ReadFile
	jc .error3
    
	jmp SOFTWARE_BASE ; jump to the loaded program (in this case its sysinit.sys)
	
    
; if any of the files is missing we have a problem
.error1:
    mov si, msgError1
    jmp .error
.error2:
    mov si, msgError2
    jmp .error
.error3:
    mov si, msgError3
.error:
    call Print
	xor ax, ax
	int 0x16
	int 0x19                    ; try rebooting when everything goes wrong
; ====================================================================================