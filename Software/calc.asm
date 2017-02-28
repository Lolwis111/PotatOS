; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % small calculator                             %
; % can do +, -, *, / and mod                    %
; % capable of base10 to base2, base8 and base16 %
; % numbers can be 32-bit                        %
; % (this has bugs for some reason)              %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%include "language.asm"

%define STD_COLOR createColor(BLACK, BRIGHT_BLUE)
%define NUM_COLOR createColor(BLACK, BRIGHT_YELLOW)

%ifdef german
    lblOptions  db 0x0D, 0x0A
                db 0x0D, 0x0A, "Befehle: add, sub, div, mul, toBin, toHex, toOct, help, exit"
                db 0x0D, 0x0A, 0x00
                
    msgResult	db 0x0D, 0x0A, "Ergebnis: ", 0x00
%elifdef english
    lblOptions  db 0x0D, 0x0A
                db 0x0D, 0x0A, "Commands: add, sub, div, mul, toBin, toHex, toOct, help, exit"
                db 0x0D, 0x0A, 0x00
                
    msgResult   db 0x0D, 0x0A, "Result: ", 0x00
%endif

msgNewLine		db 0x0D, 0x0A, 0x00
msgReady		db "> ", 0x00
msgOverflow     db 0x0D, 0x0A, "Overflow", 0x0D, 0x0A, 0x00

lblA			db "A = ", 0x00
lblB			db 0x0D, 0x0A, "B = ", 0x00
lblResult		db "0000000000", 0x00, 0x00, 0x00
inputString		db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

cmdANS          db "ANS", 0x00
cmdADD			db "ADD", 0x00
cmdSUB			db "SUB", 0x00
cmdDIV			db "DIV", 0x00
cmdMUL			db "MUL", 0x00
cmdTOBIN        db "TOBIN", 0x00
cmdTOHEX        db "TOHEX", 0x00
cmdTOOCT        db "TOOCT", 0x00

cmdEXIT			db "EXIT", 0x00

color db 0x00

; lblNumber		db "0000000000", 00h, 00h

numberA			dd 0x00000000
numberB			dd 0x00000000
result	        dd 0x00000000

; ==========================================
; ClearScreen
; ==========================================
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
; ==========================================


; ==========================================
; AH Color
; SI String
; BX Position
; ==========================================
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
; ==========================================
	

; ==========================================
start:
    mov al, byte [SYSTEM_COLOR]
    mov byte [color], al
    mov byte [SYSTEM_COLOR], NUM_COLOR

	mov dh, createColor(BLACK, WHITE)
	mov dl, 0x20
	call cls

	jmp main
; ==========================================
	
	
; ==========================================
main:
    mov ah, 0x01
    mov bl, NUM_COLOR
    mov dx, lblOptions
    int 0x21
    
	mov ah, 0x01				; >
	mov bl, NUM_COLOR
	mov dx, msgReady
	int 0x21
	
	mov ah, 0x04				; read command from keyboard
	mov dx, command
	mov cx, 5
	int 0x21
	
	mov si, command			; make command upper case
	call UpperCase
	
	mov bl, NUM_COLOR
	mov ah, 0x01				
	mov dx, msgNewLine
	int 0x21
	
	mov di, command			; EXIT-Command?
	mov si, cmdEXIT
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je exit
	
	mov di, command			; ADD-Command?
	mov si, cmdADD
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je add_numbers
	
	mov di, command			; SUB-Command?
	mov si, cmdSUB
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je sub_numbers
	
	mov di, command			; DIV-Command?
	mov si, cmdDIV
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je div_numbers
	
	mov di, command			; MUL-Command?
	mov si, cmdMUL
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je mul_numbers

    mov di, command         ; toBin-Command?
    mov si, cmdTOBIN
    mov ah, 0x02
    int 0x21
    cmp al, 0x00
    je dec_to_bin

    mov di, command         ; toHex-Command?
    mov si, cmdTOHEX
    mov ah, 0x02
    int 0x21
    cmp al, 0x00
    je dec_to_hex

    mov di, command         ; toOct-Command?
    mov si, cmdTOOCT    
    mov ah, 0x02
    int 0x21
    cmp al, 0x00
    je dec_to_oct
    
	jmp main
; ===============================================


; ==============================================
readA:
    mov bl, NUM_COLOR
    mov ah, 0x01
    mov dx, lblA
    int 0x21

    mov ah, 0x04
    mov cx, 9
    mov dx, inputString
    int 0x21

    mov si, inputString
    call UpperCase
    mov di, cmdANS
    mov ah, 0x02
    int 0x21
    cmp al, 0x00
    je .ans

    mov ah, 0x09
    mov dx, inputString
    int 0x21
    cmp ax, -1
    je .ret
    ret
.ans:
    mov ecx, dword [result]
    xor ax, ax
    ret
.ret:
    xor ecx, ecx
    mov ax, -1
    ret
; ==============================================


; ===============================================
readNumbers:
    call readA
    cmp ax, -1
    je .ret
    
    mov dword [numberA], ecx
    
    mov bl, NUM_COLOR
    mov ah, 0x01
    mov dx, lblB
    int 0x21
    
    mov ah, 0x04
    mov dx, inputString
    mov cx, 9
    int 0x21

    mov si, inputString
    call UpperCase
    mov di, cmdANS
    mov ah, 0x02
    int 0x21
    cmp al, 0x00
    je .ans

    mov ah, 0x09
    mov dx, inputString
    int 0x21
    cmp ax, -1 
    je .ret
.ok:
    mov dword [numberB], ecx
    ret
.ans:
    mov ecx, dword [result]
    jmp .ok
.ret:
    xor ecx, ecx
    mov ax, -1
    ret
; ===============================================


; ===============================================
add_numbers:
	call readNumbers
	cmp ax, -1
    je main
    
	mov eax, dword [numberA]
	add eax, dword [numberB]
    jnc .noOverflow

    mov ah, 0x01
    mov bl, createColor(RED, BLACK)
    mov dx, msgOverflow
    int 0x21

.noOverflow:
	mov ecx, eax				; convert result to string
    mov dword [result], eax
	mov ah, 0xAA
	mov dx, lblResult 
	int 0x21
	
	mov bl, NUM_COLOR
	mov ah, 0x01
	mov dx, msgResult
	int 0x21
	
	mov ah, 0x01				; print result
	mov dx, lblResult
	mov bl, STD_COLOR
	int 0x21
    
	jmp main
; ===============================================
    
    
; ===============================================
sub_numbers:
	call readNumbers
    cmp ax, -1
    je main
	
	mov ecx, dword [numberA]
    mov eax, ecx
	sub ecx, dword [numberB]
    jo .overflow
    jmp .noOverflow

.overflow:
    mov ah, 0x01
    mov bl, createColor(RED, BLACK)
    mov dx, msgOverflow
    int 0x21

.noOverflow:  
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
    mov dword [result], ecx
	mov ah, 0xAA             ; convert result to string
	mov dx, lblResult 
	int 0x21
;.ok:    
	mov bl, NUM_COLOR
	mov ah, 0x01
	mov dx, msgResult
	int 0x21
    
	mov ah, 0x01			 ; print result
	mov dx, lblResult
	mov bl, STD_COLOR
	int 0x21

	jmp main
; ===============================================
    
    
; ===============================================
div_numbers:
	call readNumbers
	cmp ax, -1
    je main
    
    cmp dword [numberB], 0x00
    je .div0
    
	xor edx, edx
    mov eax, dword [numberA]
    mov ecx, dword [numberB]
	idiv ecx					; divide
	
	;AX => Ergebnis
	;DX => Rest
	
	push edx
	push eax
    
    mov dword [result], eax

	pop ecx
	mov ah, 0xAA				; convert result to string
	mov dx, lblResult 
	int 0x21
	
	mov bl, NUM_COLOR
	mov ah, 0x01
	mov dx, msgResult
	int 0x21
	
	mov ah, 0x01				; print result
	mov dx, lblResult
	mov bl, STD_COLOR
	int 0x21
	
	mov ah, 0x01				
	mov dx, msgNewLine
	mov bl, NUM_COLOR
	int 0x21
	
	pop ecx
	mov ah, 0xAA				; this is basically modulo, convert that to string too
	mov dx, lblResult 
	int 0x21
	
	mov bl, NUM_COLOR
	mov ah, 0x01
	mov dx, .lblRest
	int 0x21
	
	mov ah, 0x01				; print modulo
	mov dx, lblResult
	mov bl, STD_COLOR
	int 0x21
    
	jmp main
.div0:
    mov bl, createColor(BLACK, RED)
    mov ah, 01h
    mov dx, DIV_NULL_ERROR
    int 21h
    jmp main
.lblRest		db "Rest    : ", 00h
; ===============================================

    
; ===============================================
mul_numbers:
	call readNumbers
	
	mov eax, dword [numberA]
	imul dword [numberB]

    mov dword [result], eax

	push eax					; low part
	
    ;push dx					; high part	
	;pop cx
	;mov ah, 03h				
	;mov dx, lblResult 
	;int 21h
	
	;mov ah, 01h
	;mov dx, .lblHoch
	;int 21h
	
	;mov ah, 01h				
	;mov dx, lblResult
	;int 21h
	
	;mov ah, 01h			
	;mov dx, msgNewLine
	;int 21h
	
	pop ecx
	mov ah, 0xAA				; convert low part to string
	mov dx, lblResult 
	int 0x21
	
	mov bl, NUM_COLOR
	mov ah, 0x01
	mov dx, msgResult
	int 0x21
	
	mov ah, 0x01				; print low part
	mov dx, lblResult
	mov bl, STD_COLOR
	int 0x21

	jmp main
; ===============================================	


; ===============================================
dec_to_bin:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 32
    mov edi, .bitString+33
.bitLoop:
    push cx
    xor edx, edx
    mov ebx, 2
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec di

    pop eax
    pop cx
    loop .bitLoop

    mov ah, 0x01
    mov bl, NUM_COLOR
    mov dx, .bitString
    int 0x21

    jmp main
.bitString db 0x0D, 0x0A, "00000000000000000000000000000000", 0x00
; ===============================================


; ===============================================
dec_to_hex:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 8
    mov di, .hexString+9
.charLoop:
    push cx
    
    xor edx, edx
    mov ebx, 16
    div ebx
    push eax

    mov si, .hexChars
    add si, dx
    mov al, byte [si]
    mov byte [di], al
    dec di

    pop eax
    
    pop cx
    loop .charLoop

    mov ah, 0x01
    mov bl, NUM_COLOR
    mov dx, .hexString
    int 0x21


    jmp main
.hexString db 0x0D, 0x0A, "00000000", 0x00
.hexChars db "0123456789ABCDEF"
; ===============================================


; ===============================================
dec_to_oct:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 12
    mov di, .octString+13
.charLoop:
    push cx
    xor edx, edx
    mov ebx, 8
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec di

    pop eax
    pop cx
    loop .charLoop

    mov ah, 0x01
    mov bl, NUM_COLOR
    mov dx, .octString
    int 0x21


    jmp main
.octString db 0x0D, 0x0A, "000000000000", 0x00
; ===============================================


; ===============================================
exit:
    mov dh, byte [color]
	mov dl, 0x20
    mov byte [SYSTEM_COLOR], dh
	call cls

	xor bx, bx
	mov ah, 0x00
	int 0x21
; ===============================================


; ===============================================
UpperCase:
    push si
.loop1:
	cmp byte [si], 0x00
	je .return
	
	cmp byte [si], 'a'
	jb .noatoz
	cmp byte [si], 'z'
	ja .noatoz
	
	sub byte [si], 0x20
	inc si
	
	jmp .loop1
.return:
    pop si
	ret
.noatoz:
	inc si
	jmp .loop1
; ===============================================

command db 0x00
