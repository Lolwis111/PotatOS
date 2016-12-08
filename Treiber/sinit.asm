; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Initalisiert das System indem es config.cfg  %
; % lädt und die Optionen entsprechend ver-      %
; % verarbeitet.                                 %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start


; ==========================================
%include "defines.asm"
%include "common.asm"
%include "fat12.asm"
%include "sinit_utils.asm"
; ==========================================


; ==========================================
enableA20:				; A20-Gate aktivieren, High-Memory
	pusha
	
	call wait_input
	mov al,0xAD
	out 0x64, al
	call wait_input

	mov al, 0xD0
	out 0x64, al
	call wait_output

	in al, 0x60
	push eax
	call wait_input

	mov al, 0xD1
	out 0x64, al
	call wait_input

	pop eax
	or al, 2
	out 0x60, al

	call wait_input
	mov al, 0xAE
	out 0x64, al

	call wait_input
	popa
	
	ret
	
wait_input:
	in al, 0x64
	test al, 2
	jnz wait_input
	ret
		
wait_output:
	in al, 0x64
	test al, 1
	jz wait_output
	ret
; ==========================================

	
msg 		db 0Dh, 0Ah, "Executing SINIT.SYS...", 0Dh, 0Ah, 00h
colorByte	db 00h
msgNoCfg	db 0Dh, 0Ah, "NO Configfile! Using default configuration!", 0Dh, 0Ah, 00h
highMem		db 00h
kb_switch	db 00h
cfgLength	dw 00h

cmdColor	db "COLOR="
cmdHigh		db "HIGH="
cmdKBXY		db "YZ_SWITCH="
cmdEND		db "END"

cmdTrue		db "TRUE"
cmdFalse	db "FALSE"

start:
	mov si, msg
	call Print

	cli
	xor ax, ax
	mov es, ax
	mov ds, ax

	mov dx, 0x1000
	mov word [0x0084], dx
	xor dx, dx
	mov word [0x0086], dx

	sti
	
	call LoadRoot
	xor bx, bx
	mov bp, 0x7C00
	mov si, config
	call LoadFile
	cmp ax, -1
	je .noCfg
	
	mov word [cfgLength], cx
	add word [cfgLength], 0x7C00
	
	mov si, 0x7C00
.scanLoop:

	push si
	mov di, cmdColor
	mov cx, 06h
	rep cmpsb
	je .color
	pop si

%if _HIGH_MEM_ = TRUE
	push si
	mov di, cmdHigh
	mov cx, 05h
	rep cmpsb
	je .high
	pop si
%endif
	
	push si
	mov di, cmdKBXY
	mov cx, 0Ah
	rep cmpsb
	je .kb_yz
	pop si

	inc si
	cmp si, word [cfgLength]
	je .scanDone
	jmp .scanLoop

.color:
	mov dx, si
	call hexToDec
	cmp ax, 1
	je .noCfg
	mov byte [colorByte], cl
	
	pop si
	add si, 8
	
	jmp .scanLoop
	
.kb_yz:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .kb_ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .kb_nok
	pop si

	pop si
	jmp .scanLoop
.kb_ok:
	pop si
	pop si
	mov byte [kb_switch], 1
	add si, 14
	jmp .scanLoop
	
.kb_nok:
	pop si
	pop si
	mov byte [kb_switch], 0
	add si, 15
	jmp .scanLoop
	
.high:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .nok
	pop si

	pop si
	jmp .noCfg
.ok:
	pop si
	pop si
	mov byte [highMem], 1
	add si, 9
	jmp .scanLoop
.nok:
	pop si
	pop si
	mov byte [highMem], 0
	add si, 10
	jmp .scanLoop

.scanDone:
	pop si
	mov dl, byte [colorByte]
	call setColor
	jmp .cfg
	
.noCfg:
	pop si
	
	mov si, msgNoCfg
	call Print
	
	mov byte [colorByte], 07h
	mov byte [highMem], 00h
	mov byte [kb_switch], 00h
	
.cfg:
	cmp byte [highMem], 0
	je .done
	
	call enableA20
	
.done:
	mov cl, byte [colorByte]
	mov byte [0x1FFF], cl
	
	mov cl, byte [kb_switch]
	mov byte [0x1FFE], cl

	jmp 0x2009 ; in die Kommandozeile springen (main.sys)

    cli
    hlt
