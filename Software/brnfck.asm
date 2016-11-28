; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % BRNFCK.ASM  ->  BRNFCK.BIN                   %
; %                                              %
; % Stellt einen einfachen Brainfuck interpreter %
; % zur verfuegung.                              %
; % TODO:                                        %
; %     - Schleifen Befehle [, ] implementieren  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"

%define STD_COLOR createColor(BLACK, BRIGHT_BLUE)
%define NUM_COLOR createColor(BLACK, BRIGHT_YELLOW)


; ==========================================

segments    dw 0000h, 0000h, 0000h

msgNewLine	db 0Dh, 0Ah, 00h

msgExit     db 0Dh, 0Ah
%ifdef german
            db "Ausfuehrung beendet."
%elif english
            db "Done."
%endif
            db 0Dh, 0Ah, 00h

msgReady	db "Brainfuck> ", 00h

pointer     dw 0000h

inputString times 256 dw 00h

color db 00h
; ==========================================


; ==========================================
; ClearScreen
; > löscht den Bildschirminhalt
; ==========================================
cls:
	pusha
	xor bx, bx
	mov cx, 2000
.loop1:
	mov word [gs:bx], dx
	add bx, 2
	loop .loop1
	popa
    
    xor dx, dx
    mov ah, 0Eh
    int 21h
    
	ret
; ==========================================	


; ==========================================
; Initalisiert das Programm
; ==========================================
start:
    mov al, byte [0x1FFF]
    mov byte [color], al
    mov byte [0x1FFF], NUM_COLOR

	mov dh, createColor(BLACK, WHITE)
	mov dl, 20h
	call cls

	jmp main
; ==========================================
	
	
; ==========================================
; Liest ein Brainfuck-Programm ein
; und fuehrt es im Anschluss aus
; ==========================================
main:
	mov ah, 01h				;> 
	mov bl, NUM_COLOR
	mov dx, msgReady
	int 21h
	
	mov ah, 04h				;Befehl von der Tastatur einlesen
	mov dx, inputString
	mov cx, 64
	int 21h
	
	mov bl, NUM_COLOR
	mov ah, 01h				;Zeilenumbruch
	mov dx, msgNewLine
	int 21h
    
    mov word [pointer], buffer

    mov si, inputString
	jmp run
; ===============================================


;===============================================
run:
    mov al, byte [si]
    inc si

    cmp al, '<'
    je .decPointer
    
    cmp al, '>'
    je .incPointer
    
    cmp al, '+'
    je .add1
    
    cmp al, '-'
    je .sub1

    cmp al, '.'
    je .print

    cmp al, ','
    je .read

    cmp al, '['
    je loopStart
    
    cmp al, ']'
    je loopEnd
    
    cmp al, 00h
    je exit
    
    jmp run
    
.decPointer:
    dec word [pointer]
    jmp run
    
.incPointer:
    inc word [pointer]
    jmp run
    
.add1:
    mov bx, buffer
    add bx, word [pointer]
    inc byte [bx]
    jmp run
    
.sub1:
    mov bx, buffer
    add bx, word [pointer]
    dec byte [bx]
    jmp run
    
.print:
    mov bx, buffer
    add bx, word [pointer]
    mov dh, byte [bx]
    mov dl, byte [0x1FFF]
    mov ah, 10h
    int 21h
    jmp run
    
.read:
    xor ax, ax
    int 16h
    mov bx, buffer
    add bx, word [pointer]
    mov byte [bx], al
    jmp run

loopStart:
    mov bx, buffer
    add bx, word [pointer]
    
    cmp byte [bx], 00h
    jne run

    mov byte [loopValue], 00h
    mov di, si
.searchLoop:
    cmp byte [di], '['
    je .incV1
    
    cmp byte [di], ']'
    je .decV1
    inc di
    jmp .searchLoop
    
.incV1:
    inc byte [loopValue]
    jmp .searchLoop
.decV1:
    cmp byte [loopValue], 00h
    je .startFound
    
    dec byte [loopValue]
    
    jmp run
.startFound:
    mov si, di
    jmp .searchLoop
   
    
loopEnd:
    mov bx, buffer
    add bx, word [pointer]
    
    cmp byte [bx], 00h
    je run

    mov byte [loopValue], 00h
    mov di, si

.searchLoop:
    cmp byte [di], ']'
    je .incV1
    
    cmp byte [di], '['
    je .decV1
   
    dec di
    jmp .searchLoop
    
.incV1:
    inc byte [loopValue]
    jmp .searchLoop
    
.decV1:
    cmp byte [loopValue], 00h
    je .endFound
    
    dec byte [loopValue]
    
    jmp run
.endFound:
    mov si, di
    jmp .searchLoop
   
loopValue db 00h    

;===============================================


; ===============================================
; Beendet das Programm und leert dabei
; den Bildschirminhalt
; ===============================================
exit:
    mov dx, msgExit
    mov bl, byte [0x1FFF]
    mov ah, 01h
    int 21h

    xor ax, ax
    int 16h

    mov dh, byte [color]
	mov dl, 20h
    mov byte [0x1FFF], dh
	call cls

	xor bx, bx
	xor ax, ax
	int 21h
    cli
    hlt
; ===============================================

buffer db 00h
