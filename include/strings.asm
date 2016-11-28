; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt Methoden zur Stringmanipulation       %
; % bereit. Können von allen Anwendungen genutzt %
; % werden. Erfordert stos, lods und movs        %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _STRINGS_INC_
%define _STRINGS_INC_

;==============================
;Dateiname von TEST.BIN nach TEST    BIN wandeln.
;si => Dateiname
;di <= FAT12 Dateiname
;==============================
AdjustFileName:
	xor cx, cx
.copy:
	lodsb
	cmp al, '.'
	je .extension
	cmp al, 00h
	je .error
	
	stosb
	inc cx
	jmp .copy
	
.extension:
	cmp cx, 8
	je .copyExtension
	
.addSpaces:
	mov byte [di], ' '
	inc di
	inc cx
	cmp cx, 8
	jl .addSpaces
.copyExtension:
	movsb
	movsw
	xor ax, ax
	ret
.error:
	mov ax, -1
	ret
;==============================

;==============================
;Dateiname von "TEST" nach "TEST       " wandeln.
;si => Dateiname
;di <= FAT12 Dateiname
;==============================
AdjustDirName:
	xor cx, cx
.copy:
	lodsb
	cmp al, 00h
	je .extension
	
	stosb
	inc cx
	jmp .copy
	
.extension:
	cmp cx, 11
	jl .addSpaces
	
.addSpaces:
	mov byte [di], ' '
	inc di
	inc cx
	cmp cx, 11
	jl .addSpaces
	xor ax, ax
	ret
.error:
	mov ax, -1
	ret
;==============================

;==============================
;String in Großbuchstaben wandeln
;SI => String
;==============================
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
;==============================


;==============================
; SI -> String
; AL -> Splitter
; CX <- Länge
;==============================
StringLength:
	push bx
	push dx
	push bp
	xor cx, cx
.charLoop:
	cmp byte [si], al
	je .ok
	cmp byte [si], 00h
	je .noOk
	inc si
	inc cx
	jmp .charLoop
.ok:
	pop bp
	pop dx
	pop bx
	ret
.noOk:
	pop bp
	pop dx
	pop bx
	xor cx, cx
	ret
;==============================


;==============================
;Index des ersten Leerzeichens abrufen (Parameter parsen)
;SI => String
;CX <= Index
;==============================
fileNameLength:
	push bx
	push dx
	push bp
	xor cx, cx
.loop1:
	lodsb
	or al, al
	jz .error
	cmp al, ' '
	je .done
	inc cx
	jmp .loop1
.done:
	pop bp
	pop dx
	pop bx
	ret
.error:
	pop bp
	pop dx
	pop bx
	mov cx, -1
	ret
	
.noArgs		db "NO ARGUMENT", 0Dh, 0Ah, 00h
;==============================

;==============================
;Index des ersten Leerzeichens abrufen (Parameter parsen)
;AX => String1
;BX => String2
;CX <= Index
;==============================
;AppendString:
;	mov si, ax
;	push ax
;	mov al, 00h
;	call StringLength
;	pop ax
;	add ax, cx
;	push ax
;	mov si, bx
;	call StringLength
;	pop ax
;	mov di, ax
;	mov si, bx
;	rep movsb
	
;	ret
;==============================
	
%endif
