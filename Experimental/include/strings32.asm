[BITS 32]
%ifndef _STRINGS32_H_
%define _STRINGS32_H_

str_compare:
.L1:
    mov al, byte [edi]
    inc edi
    mov bl, byte [esi]
    inc esi
    cmp al, bl
    jne .notEqual
    cmp al, 0x00
    jne .L1

    xor eax, eax
    ret
.notEqual:
    mov eax, 1
    ret

ToUpper:
.L1:
    mov al, byte [esi]
    cmp al, 0x00
    je .return
    cmp al, 'a'
    jb .L1
    cmp al, 'z'
    ja .L1
    sub byte [esi], 32
    inc esi
    jmp .L1
.return:
    ret

; ===============================================
IntToString16:
	pusha
	mov eax, ecx
	mov edi, edx
	xor ecx, ecx
    xor ebp, ebp
    
    cmp ax, 00h
    jns .digit1
    
    neg ax
    mov byte [edi], '-'
    inc edi
    
.digit1:		
	xor dx, dx
	mov bx, 10000
	div bx				; 0 0000
	
	cmp al, 00h
	jz .zero1
	
	add al, 48
	mov byte [edi], al
    inc esi
	jmp .digit2
	
.zero1:
	mov bp, 01h
	
.digit2:
	mov ax, dx
	mov bx, 1000
	xor dx, dx
	div bx				; 0 000
	
	cmp al, 00h
	jz .ok2
.nok2:
	add al, 48
	mov byte [edi], al
    inc edi
	xor bp, bp
	jmp .digit3
.ok2:
	cmp bp, 01h
	jnz .nok2
.zero2:
	mov bp, 01h
	
	
.digit3:
	mov ax, dx
	mov bx, 100
	xor edx, edx
	div bx				; 0 00

	cmp al, 00h
	jz .ok3
.nok3:
	add al, 48
	mov byte [edi], al
    inc edi
	xor bp, bp
	jmp .digit4
.ok3:	
	cmp bp, 01h
	jnz .nok3
.zero3:
	mov bp, 01h

	
.digit4:
	mov ax, dx
	mov bx, 10
	xor dx, dx
	div bx				; 0 0
	
	cmp al, 00h
	jz .ok4
.nok4:
	add al, 48
	mov byte [edi], al
    inc edi
	jmp .digit5
	
.ok4:
	; cmp byte [.status], 01h
	cmp bp, 01h
	jnz .nok4

.digit5:
	xchg ax, dx
	add al, 48
	mov byte [edi], al
    inc edi

.end:
	xor al, al
	mov byte [edi], al
    inc edi
	popa
    ret
; ===============================================


IntToString32:
.L1:
	xor edx, edx                ; 0
	mov ecx, dword [.divisor]   ; Teiler
	div ecx	                    ; Teilen
	; eax Result
	; edx Remainder
	add al, 48                  ; ASCII bilden
	mov byte [esi], al          ; ASCII speichern
	inc esi                     ; nächstes Zeichen wählen
	push edx                    ; Rest speichern
	xor edx, edx                ; Divisior durch 10 teilen (nächste Stelle)
	mov eax, dword [.divisor]
	mov ecx, 10
	div ecx
	mov dword [.divisor], eax   ; neuen Divisor speichern
	pop eax	                    ; Rest holen
	cmp dword [.divisor], 0	    ; Prüfen ob Zahl zu Ende ist
	jg .L1
	ret
.divisor	dd 1000000000

%endif
