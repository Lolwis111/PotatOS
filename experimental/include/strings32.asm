[BITS 32]
%ifndef _STRINGS32_H_
%define _STRINGS32_H_

; ===========================================================================
str_compare:
    cld
    .L1:
        cmpsb
        je .ret
.ret:
    ret
;str_compare:
;.L1:
;    mov al, byte [edi]
;    inc edi
    
;    mov bl, byte [esi]
;    inc esi
    
;    cmp al, bl
;    jne .notEqual
;    
;    cmp al, 0x00
;    jne .L1
;
;    xor eax, eax
;    ret
;.notEqual:
;    mov eax, 1
;    ret
; ===========================================================================


; ===========================================================================
ToUpper:
.L1:
    mov al, byte [esi]
    test al, al
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
; ===========================================================================


; ===========================================================================
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
; ===========================================================================

%endif
