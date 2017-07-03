; ====================================================
; Listet alle Dateien auf der Diskette auf
; (inkl. Dateigröße)
; ====================================================
view_dir:
	mov word [.fileSize], 00h   ; Gesamtgröße auf 0 initalisieren
	print newLine
	
	print LS_LABEL_1 ; Label1 ausgeben (siehe language.asm)
	
	mov ah, 11h
	int 21h						; Stammverzeichnis laden
	
	xor ax, ax
	mov si, bp					; Startadresse Stammverzeichnis
	mov es, ax
	cld
.fileLoop:
	push cx
	
	mov di, fileName    ; die ersten 11 Bytes im Verzeichnis entsprechen jeweils 
	mov cx, 11          ; Dateinamen -> in fileName kopieren
	rep movsb
	
	mov al, byte [si]           ; die Dateiattribute ebenfalls kopieren
	mov byte [.attributes], al
	
	cmp byte [cmdargument], 00h ; prüfen ob ein Endungs-Filter angegeben wurde (z.B. bin)
	je .noFilter
	
	push si
	
	mov si, fileName    ; wenn ja -> nur Dateien mit entsprechender Endung ausgeben
	mov di, rFileName
	call AdjustFileName ; Dateiname anpassen
	mov cx, 3
	mov si, rFileName   ; die letzten drei Zeichen testen
	mov di, cmdargument
	add si, 8
	rep cmpsb
	jne .skip           ; keine Übereinstimmung -> Eintrag überspringen
	
	pop si
.noFilter:
	add si, 17
	mov ecx, dword [si]     ; Dateigröße laut Dateisystem kopieren
	add word [.fileSize], cx; Und zur Gesamtgröße addieren
	push si
	mov si, fileName
	lodsb
	cmp al, 0xE5            ; prüfen ob die Datei als gelöscht markiert ist
	je .del
	cmp al, 0x00            ; prüfen ob der letzte Eintrag erreich wurde
	je .eod
	mov ah, 03h
	mov dx, .number         ; Dateigröße in String wandeln
	int 21h

    mov si, fileName        ; Dateiname in NAME.EXT wandeln
    call ReadjustFileName

    print di ; Dateiname ausgeben
	
	test byte [.attributes], 00010000b
	jnz .dir ; prüfen ob es ein Ordner ist
	
    mov ah, 0Fh ; wenn nein ->  an X-Position gehen 
    int 21h
    mov dl, 20
    mov ah, 0Eh
    int 21h

	print .number ; und die Dateigröße ausgeben
	jmp .ok
	
.dir:
    print ldir ; Verzeichnisse werden mit <DIR> kenntlich gemacht
	
.ok:
    print newLine ; OK => newLine ausgeben
	pop si
	jmp .next             ; und zum nächsten Eintrag gehen
.skip:                    ; direkt Hierhin springen wenn der Eintrag übersprungen werden soll
	pop si              
	add si, 17 ; nächsten Eintrag berechnen
	jmp .next
.del:
	pop si
.next:
	pop cx
	add si, 4 ; 32 Byte pro Eintrag 
	
	dec cx
	cmp cx, 00h
	jne .fileLoop
	jmp .end
.eod:
	pop si
	pop cx
.end:
    print LS_LABEL_2

	mov cx, word [.fileSize]
	mov ah, 03h
	mov dx, .number
	int 21h
	
    print .number
	
	print newLine
	
	jmp main
.number db "00000", 00h
.fileSize dw 0000h
.attributes db 00h
; ====================================================


; ====================================================
; Gibt alle Dateinamen hintereinander einfach aus
; ====================================================
view_dir_2:
	mov word [.fileSize], 00h
    print newLine
	
	mov ah, 11h
	int 21h						; Stammverzeichnis laden
	
	xor ax, ax
	mov si, bp					; Startadresse Stammverzeichnis
	mov es, ax
	cld
.fileLoop:
	push cx
	
	mov di, fileName
	mov cx, 11
	rep movsb
	
	mov al, byte [si]
	mov byte [.attributes], al
	add si, 17
	mov ecx, dword [si]
	add word [.fileSize], cx
	push si
	mov si, fileName
	lodsb
	cmp al, 0xE5
	je .del
	cmp al, 0x00
	je .eod

    mov si, fileName
    call ReadjustFileName

	print di
	
    print .spacer2

	test byte [.attributes], 00010000b ; Prüfen ob das Attribut "Verzeichnis" gesetzt?
	jnz .dir

	jmp .ok
	
.dir:
	mov bl, byte [SYSTEM_COLOR]
	mov ah, 01h
	mov dx, ldir
	int 21h
	
.ok:
	pop si
	jmp .next
.skip:
	pop si
	add si, 17
	jmp .next
.del:
	pop si
.next:
	pop cx
	add si, 4					; 32 Byte pro Eintrag
	
	dec cx
	cmp cx, 00h
	jne .fileLoop
	jmp .end
.eod:
	pop si
	pop cx
.end:

    print newLine

    print LS_LABEL_2

	mov cx, word [.fileSize]
	mov ah, 03h
	mov dx, .number
	int 21h
	
	print .number
	
	print newLine
	
	jmp main
.number db "00000", 00h
.spacer2 db " | ", 00h
.fileSize dw 0000h
.attributes db 00h
; ====================================================
