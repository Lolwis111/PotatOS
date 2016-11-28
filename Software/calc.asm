; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Kleiner Taschenrechner                       %
; % beherscht +, -, *, / und mod                 %
; % Nur Ganzzahlen von -32768 bis + 32677        %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"

%define STD_COLOR createColor(BLACK, BRIGHT_BLUE)
%define NUM_COLOR createColor(BLACK, BRIGHT_YELLOW)

lblOptions		db 0Dh, 0Ah
%ifdef german
                db 0Dh, 0Ah, "Befehle: add, sub, div, mul, exit"
%elif english
                db 0Dh, 0Ah, "Commands: add, sub, div, mul, exit"
%endif

                db 0Dh, 0Ah, 00h

%ifdef german
    msgResult	db 0Dh, 0Ah, "Ergebnis: ", 00h
%elif english
    msgResult   db 0Dh, 0Ah, "Result: ", 00h
%endif

msgNewLine		db 0Dh, 0Ah, 00h
msgReady		db "> ", 00h

lblA			db "A = ", 00h
lblB			db 0Dh, 0Ah, "B = ", 00h
lblResult		db "00000", 00h, 00h, 00h
inputString		db 00h, 00h, 00h, 00h, 00h, 00h

cmdADD			db "ADD", 00h
cmdSUB			db "SUB", 00h
cmdDIV			db "DIV", 00h
cmdMUL			db "MUL", 00h
cmdEXIT			db "EXIT", 00h

color db 00h
;lblNumber		db "0000000000", 00h, 00h
numberA			dd 0
numberB			dd 0
;numberResult	dd 0

;==========================================
;ClearScreen
;==========================================
cls:
	pusha
	xor bx, bx
	mov cx, SCREEN_BUFFER_SIZE
.loop1:
	mov word [gs:bx], dx
	add bx, 2
	loop .loop1
	popa
    
    xor dx, dx
    mov ah, 0Eh
    int 21h
    
	ret
;==========================================


;==========================================
; AH Color
; SI String
; BX Position
;==========================================
printString:
	pusha
.chars:
	mov al, byte [si]
	inc si
	test al, al
	jz .return
	mov byte [gs:bx], al
	inc bx
	mov byte [gs:bx], ah
	inc bx
	jmp .chars
.return:
	popa
	ret
;==========================================
	

;======================================
; EAX <- Zahl
; ESI -> String
;======================================
;strToInt:
;	pusha
;	xor ebp, ebp
;.loop1:
;	cmp byte [si], 00h
;	je .done
;	cmp byte [si], 0Dh
;	je .done
;	cmp byte [si], 0Ah
;	je .done
;	cmp byte [si], '0'
;	jb .error
;	cmp byte [si], '9'
;	ja .error
;	shl ebp, 1
;	mov eax, ebp
;	shl ebp, 2
;	add ebp, eax
;	movzx eax, byte [si]
;	inc si
;	sub al, 48d
;	add ebp, eax
;	jmp .loop1
;.done:
;	mov dword [.result], ebp
;	popa
;	mov eax, dword [.result]
;	ret
;.error:
;	popa
;	mov eax, -1
;	ret
;.result		dd 0
;======================================
	
	
;======================================
; EAX -> Zahl
; SI <- String
;======================================
;intToStr:
;	pusha
	
;	mov ebp, 1_000_000_000
;	mov ecx, 10					
;.loop1:
;	xor edx, edx				; 0
;	div ebp
;	; eax Result
;	; edx Remainder
;	add al, 48d					; ASCII bilden
;	mov byte [si], al			; ASCII speichern
;	inc si						; nächstes Zeichen wählen
;	push edx					; Rest speichern
;	xor edx, edx				; 0
;	mov eax, ebp
;	div ecx						; Divisior durch 10 teilen (nächste Stelle)
;	mov ebp, eax				; neuen Divisior speichern
;	pop eax						; Rest holen
;	cmp ebp, 0					; Prüfen ob das Ende erreich wurde
;	jg .loop1
	
;	popa
;	ret
;======================================
	

;==========================================
;DrawGUI
;==========================================
;drawGUI:
;	mov bx, cursorPos(40, 19)
;	mov byte [gs:bx], '1'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(42, 19)
;	mov byte [gs:bx], '2'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(44, 19)
;	mov byte [gs:bx], '3'
;	mov byte [gs:bx+1], NUM_COLOR
	
	
;	mov bx, cursorPos(40, 21)
;	mov byte [gs:bx], '4'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(42, 21)
;	mov byte [gs:bx], '5'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(44, 21)
;	mov byte [gs:bx], '6'
;	mov byte [gs:bx+1], NUM_COLOR
	
	
;	mov bx, cursorPos(40, 23)
;	mov byte [gs:bx], '7'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(42, 23)
;	mov byte [gs:bx], '8'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	mov bx, cursorPos(44, 23)
;	mov byte [gs:bx], '9'
;	mov byte [gs:bx+1], NUM_COLOR
	
;	ret
;==========================================
	

;==========================================
;DrawBorders
;==========================================
;drawBorder:
;	mov bx, cursorPos(21, 0)
;	mov cx, 38
;.top:
;	mov byte [gs:bx], 205
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	inc bx
;	loop .top
	
;	mov bx, cursorPos(21, 24)
;	mov cx, 38
;.bottom:
;	mov byte [gs:bx], 205
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	inc bx
;	loop .bottom
	
;	mov bx, cursorPos(20, 1)
;	mov cx, 23d
;.left:
;	mov byte [gs:bx], 186
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	add bx, 159
;	loop .left
	
;	mov bx, cursorPos(59, 1)
;	mov cx, 23d
;.right:
;	mov byte [gs:bx], 186
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	add bx, 159
;	loop .right
	
;	mov bx, cursorPos(20, 0)
;	mov byte [gs:bx], 201
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(59, 0)
;	mov byte [gs:bx], 187
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(20, 24)
;	mov byte [gs:bx], 200
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(59, 24)
;	mov byte [gs:bx], 188
;	mov byte [gs:bx+1], STD_COLOR

;	mov bx, cursorPos(21, 18)
;	mov cx, 38
;.separator:
;	mov byte [gs:bx], 205
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	inc bx
;	loop .separator
	
;	mov bx, cursorPos(20, 18)
;	mov byte [gs:bx], 204
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(59, 18)
;	mov byte [gs:bx], 185
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(21, 5)
;	mov cx, 38
;.separator2:
;	mov byte [gs:bx], 205
;	inc bx
;	mov byte [gs:bx], STD_COLOR
;	inc bx
;	loop .separator2
	
;	mov bx, cursorPos(20, 5)
;	mov byte [gs:bx], 204
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(59, 5)
;	mov byte [gs:bx], 185
;	mov byte [gs:bx+1], STD_COLOR
	
;	mov bx, cursorPos(45, 3)
;	mov cx, 13
;.separator3:
;	mov byte [gs:bx], 196
;	inc bx
;	mov byte [gs:bx], NUM_COLOR
;	inc bx
;	loop .separator3
	
;	ret
;==========================================


;==========================================
start:
    mov al, byte [SYSTEM_COLOR]
    mov byte [color], al
    mov byte [SYSTEM_COLOR], NUM_COLOR

	mov dh, createColor(BLACK, WHITE)
	mov dl, 20h
	call cls

	jmp main
	
	;mov bl, createColor(BLACK, BRIGHT_BLUE)
	;mov dx, msgWelcome		;Startnachricht anzeigen
	;mov ah, 01h
	;int 21h
	
	;mov ax, 0xB800
	;mov gs, ax
	
	;call drawBorder
	;call drawGUI

	;mov si, lblNumber
	;mov eax, dword [numberA]
	;call intToStr
	
	;mov ah, NUM_COLOR
	;mov bx, cursorPos(48, 1)
	;mov si, lblNumber
	;call printString

	
	;mov si, lblNumber
	;mov eax, dword [numberB]
	;call intToStr

	;mov ah, NUM_COLOR
	;mov bx, cursorPos(48, 2)
	;mov si, lblNumber
	;call printString

	
	;mov si, lblNumber
	;mov eax, dword [numberResult]
	;call intToStr

	;mov ah, NUM_COLOR
	;mov bx, cursorPos(48, 4)
	;mov si, lblNumber
	;call printString
	
	;mov bx, cursorPos(46, 2)
	;mov byte [gs:bx], '+'
	;mov byte [gs:bx+1], NUM_COLOR
	
	;xor ax, ax
	;int 16h

;==========================================
	
	
;==========================================
main:
    mov ah, 01h
    mov bl, NUM_COLOR
    mov dx, lblOptions
    int 21h
    
	mov ah, 01h				;> 
	mov bl, NUM_COLOR
	mov dx, msgReady
	int 21h
	
	mov ah, 04h				;Befehl von der Tastatur einlesen
	mov dx, command
	mov cx, 5
	int 21h
	
	mov si, command			;in Großbuchstaben wandeln
	call UpperCase
	
	mov bl, NUM_COLOR
	mov ah, 01h				;Zeilenumbruch
	mov dx, msgNewLine
	int 21h
	
	mov di, command			;EXIT-Command?
	mov si, cmdEXIT
	mov ah, 02h
	int 21h
	cmp al, 00h
	je exit
	
	mov di, command			;ADD-Command?
	mov si, cmdADD
	mov ah, 02h
	int 21h
	cmp al, 00h
	je add_numbers
	
	mov di, command			;SUB-Command?
	mov si, cmdSUB
	mov ah, 02h
	int 21h
	cmp al, 00h
	je sub_numbers
	
	mov di, command			;DIV-Command?
	mov si, cmdDIV
	mov ah, 02h
	int 21h
	cmp al, 00h
	je div_numbers
	
	mov di, command			;MUL-Command?
	mov si, cmdMUL
	mov ah, 02h
	int 21h
	cmp al, 00h
	je mul_numbers
    
	jmp main
;===============================================
    
    
;===============================================
readNumbers:
    mov bl, NUM_COLOR
    mov ah, 01h
    mov dx, lblA
    int 21h
    
    mov ah, 04h
    mov cx, 5
    mov dx, inputString
    int 21h
    
    mov ah, 09h
    mov dx, inputString
    int 21h
    cmp ax, -1
    je .ret
    
    mov word [numberA], cx
    
    mov bl, NUM_COLOR
    mov ah, 01h
    mov dx, lblB
    int 21h
    
    mov ah, 04h
    mov dx, inputString
    mov cx, 5
    int 21h
    
    mov ah, 09h
    mov dx, inputString
    int 21h
    cmp ax, -1 
    je .ret
    
    mov word [numberB], cx
    ret
.ret:
    xor cx, cx
    mov ax, -1
    ret
;===============================================


;===============================================
add_numbers:
	call readNumbers
	cmp ax, -1
    je main
    
	movzx eax, word [numberA]
	add ax, word [numberB]
	
	mov cx, ax				;Ergebnis in String wandeln
	mov ah, 03h
	mov dx, lblResult 
	int 21h
	
	mov bl, NUM_COLOR
	mov ah, 01h
	mov dx, msgResult
	int 21h
	
	mov ah, 01h				;Ergebnis ausgeben
	mov dx, lblResult
	mov bl, STD_COLOR
	int 21h
    
	jmp main
;===============================================
    
    
;===============================================
sub_numbers:
	call readNumbers
    cmp ax, -1
    je main
	
	movzx ecx, word [numberA]
    mov ax, cx
	sub cx, word [numberB]
              
    ;cmp ax, word [numberB]
    ;jge .print
       
    ;mov ax, 65535
    ;sub ax, cx
    ;inc ax
    
    ;mov cx, ax
    ;mov ah, 03h
    ;mov dx, lblResult+1
    ;int 21h
          
    ;mov byte [lblResult], '-'
    ;jmp .ok
          
;.print:
	mov ah, 03h             ;Ergebnis in String wandeln
	mov dx, lblResult 
	int 21h

;.ok:    
	mov bl, NUM_COLOR
	mov ah, 01h
	mov dx, msgResult
	int 21h
    
	mov ah, 01h				;Ergebnis ausgeben
	mov dx, lblResult
	mov bl, STD_COLOR
	int 21h

	jmp main
;===============================================
    
    
;===============================================
div_numbers:
	call readNumbers
	cmp ax, -1
    je main
    
    cmp word [numberB], 00h
    je .div0
    
	xor dx, dx
    movzx eax, word [numberA]
    movzx ecx, word [numberB]
	idiv cx					;Dividieren
	
	;AX => Ergebnis
	;DX => Rest
	
	push dx
	push ax

	pop cx
	mov ah, 03h				;Ergebnis in String wandeln
	mov dx, lblResult 
	int 21h
	
	mov bl, NUM_COLOR
	mov ah, 01h
	mov dx, msgResult
	int 21h
	
	mov ah, 01h				;Ergebnis ausgeben
	mov dx, lblResult
	mov bl, STD_COLOR
	int 21h
	
	mov ah, 01h				;Zeilenumbruch
	mov dx, msgNewLine
	mov bl, NUM_COLOR
	int 21h
	
	pop cx
	mov ah, 03h				;Rest in String wandeln
	mov dx, lblResult 
	int 21h
	
	mov bl, NUM_COLOR
	mov ah, 01h
	mov dx, .lblRest
	int 21h
	
	mov ah, 01h				;Rest ausgeben
	mov dx, lblResult
	mov bl, STD_COLOR
	int 21h
    
	jmp main
.div0:
    mov bl, createColor(BLACK, RED)
    mov ah, 01h
    mov dx, .lblDiv0
    int 21h
    jmp main
    
.lblDiv0        db 0Dh, 0Ah, "Ungueltige Division durch 0!", 0Dh, 0Ah, 00h
.lblRest		db "Rest    : ", 00h
;===============================================

    
;===============================================
mul_numbers:
	call readNumbers
	
	movzx eax, word [numberA]
	imul word [numberB]

	push ax					;Niederweriger Teil
	;push dx					;Höherwertiger Teil
	
	;pop cx
	;mov ah, 03h				;Hohen Teil in String wandeln
	;mov dx, lblResult 
	;int 21h
	
	;mov ah, 01h
	;mov dx, .lblHoch
	;int 21h
	
	;mov ah, 01h				;Hohen Teil ausgeben
	;mov dx, lblResult
	;int 21h
	
	;mov ah, 01h				;Zeilenumbruch
	;mov dx, msgNewLine
	;int 21h
	
	pop cx
	mov ah, 03h				;Niedrigen Teil in String wandeln
	mov dx, lblResult 
	int 21h
	
	mov bl, NUM_COLOR
	mov ah, 01h
	mov dx, msgResult
	int 21h
	
	mov ah, 01h				;Niedrigen ausgeben
	mov dx, lblResult
	mov bl, STD_COLOR
	int 21h
	
	jmp main
;.lblHoch	db "High: ", 00h
;===============================================	


;===============================================
exit:
    mov dh, byte [color]
	mov dl, 20h
    mov byte [SYSTEM_COLOR], dh
	call cls

	xor bx, bx
	mov ah, 00h
	int 21h
;===============================================


;===============================================
UpperCase:
.loop1:
	cmp byte [si], 00h
	je .return
	
	cmp byte [si], 'a'
	jb .noatoz
	cmp byte [si], 'z'
	ja .noatoz
	
	sub byte [si], 20h
	inc si
	
	jmp .loop1
.return:
	ret
.noatoz:
	inc si
	jmp .loop1
;===============================================

command db 00h
