; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt den Hauptteil des Systems dar. Stellt %
; % alle Betriebssystemfunktionen als Interrupt  %
; % 33 zur Verfügung.                            %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x1000]
[BITS 16]

main:
	cmp ah, 00h			; Zum Kernel springen
	je exitProgram
	
	cmp ah, 01h			; Einen 0 terminierten String ausgeben
	je printString
	
	cmp ah, 02h			; Zwei Zeichenketten miteinander vergleichen
	je compareString
	
    cmp ah, 03h			; Zahl in String wandeln
	je intToStr
    
	cmp ah, 04h			; Eine Zeichenkette von der Tastatur einlesen
	je readLine
	
    cmp ah, 05h			; Eine Datei in einen Speicherbereich laden
	je loadFile
    
	cmp ah, 06h			; Zeitstring abrufen
	je getTimeString
	
	cmp ah, 07h			; Datumsstring abrufen
	je getDateString
	
	cmp ah, 08h			; Systemversion abrufen
	je getSystemVersion

    cmp ah, 09h			; String in Zahl wandeln
    je stringToInt

    cmp ah, 0Ah         ; Löscht eine Datei
	je deleteFile    

    cmp ah, 0Bh         ; Zufallszahl erzeugen 
    je random           ; TODO: so implementieren dass es auch funktioniert :)
   
    cmp ah, 0Ch         ; Gibt CPU Informationen
    je hardwareInfo

   	cmp ah, 0Dh         ; Ein Hex-Byte in eine Zahl wandeln
	je hexToDec

   	cmp ah, 0Eh         ; Cursorposition setzen
	je setCursorPosition
   
   	cmp ah, 0Fh         ; Cursorposition lesen
	je getCursorPosition
   
    cmp ah, 10h         ; ein einzelnes Zeichen ausgeben
	je printCharC
   
    cmp ah, 11h         ; Root speichern
	je getRootDir
	
	cmp ah, 12h         ; Root laden
	je setRootDir
	
	cmp ah, 13h         ; Datei suchen
	je findFile
    
	cmp ah, 14h         ; Datei speichern
	je writeFile
    
    cmp ah, 15h         ; ein Byte in einen Hex-String wandeln
	je decToHex

    cmp ah, 16h
    je bcdToInt

	iret

%include "fat12.asm"
%include "common.asm"
%include "defines.asm"
%include "language.asm"
	
col db 00h
row db 09h
	
; =====================================================
; Beendet ein Programm und springt zurück zu PotatOS
; =====================================================
exitProgram:	
	test bx, bx     ; Überprüfen ob das Programm einen Fehlercode angegeben hat 
	jnz .rError     ; Der Wert 0 entspricht "Kein Fehler".
.r:
	mov dh, byte [row]  ; den Cursor in der aktuellen Zeile
	mov dl, 00h         ; an den linken Bildschirmrand
	call private_setCursorPosition ; setzen.
	
	jmp MAIN_SYS+9  ; Die Datei main.sys liegt an der Adressse MAIN_SYS, allerdings
                    ; sind die ersten 9-Bytes nur für den Bootvorgang vorgesehen.

.rError:
	mov bl, byte [ds:SYSTEM_COLOR] ; Bei einem Fehlercode != 0 wird eine Fehlermeldung 
	mov dx, SOFTWARE_ERROR         ; ausgegeben.
	call private_printString
	
	jmp .r
	
;.msgReturnError db 0Dh, 0Ah
;    db "Das Programm hat einen Fehlerverursacht und wurde beendet."
;    db 0Dh, 0Ah, 00h
; =====================================================


; =====================================================
; DX -> String
; BL -> Color
; =====================================================
printString: ; öffentlicher Wrapper
	call private_printString
	iret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
private_printString:
    mov si, dx  ; String in das Source-Register kopieren        
	mov dl, bl  ; Farbwert kopieren
	push bx     ; Originalstring sichern
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.charLoop:
	lodsb       ; alle Zeichen durchgehen
	test al, al ; und bei \0 abrechen.
	jz .end
	mov dh, al  ; für jedes Zeichen wird einfach die PrintChar Funktion aufgerufen.
	call printChar
	
	jmp .charLoop
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.end:
	pop bx ; am Ende muss nur noch die Cursorposition angepasst werden
	mov dh, byte [row]
	mov dl, byte [col]
	call private_setCursorPosition
	ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
printCharC: ; öffentlicher Wrapper
	call printChar
	iret
	
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printChar:
	push dx
	mov ax, VIDEO_MEMORY_SEGMENT ; die Adresse relativ zum Segment berechnen.
	mov gs, ax                
	movzx bx, byte [col]   ; Grobe Formel: x * 2 + (y * SCREEN_WIDTH)
	movzx ax, byte [row]
	shl bx, 1
	mov cx, SCREEN_WIDTH*2
	mul cx
	add bx, ax
	pop dx
	
	cmp dh, 0Dh ; Zeilenumbruche speziell behandeln
	je .cr
	cmp dh, 0Ah
	je .lf
	
	mov byte [gs:bx], dh    ; Farbwert und Zeichen in den Speicher kopieren
	mov byte [gs:bx+1], dl
	add bx, 2
	
	inc byte [col]
	
	cmp byte [col], 160 ; ist der Cursor am rechten Bildschirmrand angekommen wird 
                        ; automatisch umgebrochen.
	je .newLine	
	ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.newLine:
	mov byte [col], 00h ; Cursor an den linken Rand setzen
	inc byte [row]      ; Zeile um eins erhöhen
	
	cmp byte [row], 23
	jae .moveBuffer     ; am unteren Rand angekommen, wird der gesamte Bildbereich nach oben gescrollt
	
	ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.cr:
	mov byte [col], 00h ; Wagenrücklauf: Cursor an den linken Rand setzen
	ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.lf:
	inc byte [row]      ; Umbruch: Cursor eine Zeile nach unten bewegen
	cmp byte [row], 23
	jae .moveBuffer     ; ist der Cursor ganz unten wird der Bildbereich nach oben gescrollt
	ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.moveBuffer:
	push si
	mov byte [row], 22  ; Den kompletten Videospeicher, beginnend ab Zeile 2 
	mov ax, es          ; um eine Zeile nach oben verschieben, und die letzte Zeile mit 
                        ; leerzeichen füllen.
	push ax
	mov ax, ds
	push ax
	
	mov ax, VIDEO_MEMORY_SEGMENT
	mov es, ax
	mov ds, ax
	mov si, 160
	mov di, 00h
	mov cx, (SCREEN_BUFFER_SIZE - SCREEN_WIDTH)
	rep movsw
	
	pop ax
	mov ds, ax
	pop ax
	mov es, ax
	pop si
	ret
; =====================================================		


; =====================================================
; DH -> Row
; DL -> Column
; =====================================================
private_setCursorPosition:
	movzx ax, dh
	movzx bx, dl

	mov byte [row], dh ; Systeminterne Cursorposition speichern
	mov byte [col], dl
	shl ax, 4          ; Hardwarecursor im VGA Cursor ebenfalls setzen
	add bx, ax
	shl ax, 2
	add bx, ax

	mov al, 0Fh
	mov dx, 3D4h
	out dx, al
	
	mov ax, bx
	mov dx, 3D5h
	out dx, al
	
	mov al, 0Eh
	mov dx, 3D4h
	out dx, al
	
	mov ax, bx
	shr ax, 8
	mov dx, 3D5h
	out dx, al
	
	ret
setCursorPosition: ; öffentlicher Wrapper
	call private_setCursorPosition
	iret
; =====================================================	


; =====================================================	
getCursorPosition:
	mov dh, byte [row] ; Interne Cursorposition zurückgeben (entspricht immer
	mov dl, byte [col] ; der Position des Hardwarecursors)
	iret
; =====================================================	


; =========================================
; Lädt eine Datei an eine beliebige Speicherposition
; Buffer    => BX:BP
; Dateiname => DX
; Speicheradresse des Verzeichnisses => AX [VERALTET]
; AX <= Ergebnis, 0 = OK, -1 = ERROR
; CX <= Size 
; =========================================
loadFile: ; stellt einen Wrapper für FAT12.ASM Methoden dar
	push bp
	push bx
	push dx
	
	call LoadRoot
	
	pop dx
	pop bx
	pop bp
	
	xor ax, ax
	mov si, dx
	call LoadFile
	iret
; =========================================


; =========================================
; DX -> Dateiname
; CX -> Byteanzahl
; AX -> Speicheradresse des Verzeichnisses
; BX:BP -> Daten
; =========================================
writeFile:
	mov si, dx
    push si
    call FindFile
    pop si
    cmp ax, -1
    je .return
	call WriteFile
.return:
	iret
; =========================================


; =========================================
; AX -> Speicheradresse des Verzeichnisses
; =========================================
getRootDir:
	call LoadRoot
	mov bp, ROOT_OFFSET
	mov cx, word [RootEntries]
	iret
; =========================================


; =========================================
; AX -> Speicheradresse des Verzeichnisses
; =========================================
setRootDir:
	call WriteRoot
	iret
; =========================================


; =========================================
; DX -> Dateiname
; =========================================
deleteFile:
	mov si, dx
	call DeleteFile
	iret
; =========================================


; =========================================
; DX -> Dateiname
; =========================================
findFile:
	mov si, dx
	call FindFile
	iret
; =========================================


; =========================================
; Liest eine Zeichenkette von der Tastatur
; DX => Zielstring
; CX => Max. Anzahl Zeichen
; CX <= Anzahl Zeichen
; =========================================
readLine:
	mov di, dx ; String ins Destinations-Register kopieren
	mov word [.counter], 00h ; Zähler auf 0 setzen
.kbLoop:
	xor ax, ax            ; auf einen Tastendruck warten
	int 16h
	test al, al             ; ist AL = 0 handelt es sich um eine Sondertaste 
	jz .kbLoop

	cmp al, 0Dh	        	; Enter?
	je .return	    		; Ja beenden
	
	cmp al, 08h             ; Rücktaste?	
	je .back                ; Ja letztes Zeichen löschen
	
	inc byte [.counter]     ; Zähler inkrementieren
	cmp byte [.counter], cl ; und ggf. weitere Eingabe unterbinden
	jg .kbLoop
	
	cmp byte [SYSTEM_KB_STATUS], 0 ; Prüfen ob Y und Z vertauscht werden müssen
	je .store
	
	cmp al, 'z' ; wenn ja wird einfach umgemappt
	je .y
	cmp al, 'y'
	je .z
	cmp al, 'Z'
	je .Y
	cmp al, 'Y'
	je .Z
	
	jmp .store
	
.y:
	mov al, 'y'
	jmp .store
.Y:
	mov al, 'Y'
	jmp .store
.z:
	mov al, 'z'
	jmp .store
.Z:
	mov al, 'Z'
.store: ; speichert das Zeichen in al im Zielstring, gibt es auf dem Bildschirm aus und 
        ; inkrementiert alle notwendigen Adressen
	stosb				; Zeichen speichern
	
	pusha
	
	mov dh, al
	mov dl, byte [ds:SYSTEM_COLOR]
	call printChar
	mov dl, byte [col]
	mov dh, byte [row]
	call private_setCursorPosition
	
	popa
	
	jmp .kbLoop			; nächstes Zeichen einlesen
	
.back:
	cmp byte [.counter], 00h
	jbe .kbLoop
	dec byte [.counter]
	
	pusha
	
;	; Ausgabe
	dec byte [col]
	
	mov dh, 00
	mov dl, byte [ds:SYSTEM_COLOR]
	call printChar
	
	dec byte [col]
	mov dh, byte [row]
	mov dl, byte [col]
	call private_setCursorPosition
	
	popa
	
	; Variable
	dec di				; ein Zeichen zurück springen
	mov al, 00h			
	stosb				; mit null überschreiben
	dec di				; ein zeichen zurückspringen
	
	jmp .kbLoop
	
.return:
	xor al, al
	stosb				; 0 Anhängen (Stringende)
	movzx cx, byte [.counter]
	iret				; Return
	
.counter db 00h


; =========================================
; Vergleicht zwei Zeichenketten miteinander
; DI => Zeichenkette 1
; SI => Zeichenkette 2
; AL <= 0 gleich, 1 verschieden
; =========================================
compareString:
	xor al, al
	push di
.Loop:
	lodsb
	scasb
	jne .NotEqual
	;cmp al, 00h
	test al, al
	jnz .Loop

	xor al, al
	pop di
	iret
.NotEqual:
	mov al, 01h
	pop di
	iret
; =========================================


; =========================================
; intToStr
; dx => String
; cx => Zahl
; =========================================
intToStr:
	pusha
	mov ax, cx
	mov di, dx
	xor cx, cx
    xor bp, bp
    
    cmp ax, 00h
    jns .digit1
    
    neg ax
    mov byte [di], '-'
    inc di
    
.digit1:		
	xor dx, dx
	mov bx, 10000
	div bx				; 0 0000
	
	cmp al, 00h
	jz .zero1
	
	add al, 48
	stosb
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
	stosb
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
	xor dx, dx
	div bx				; 0 00

	cmp al, 00h
	jz .ok3
.nok3:
	add al, 48
	stosb
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
	stosb
	jmp .digit5
	
.ok4:
	; cmp byte [.status], 01h
	cmp bp, 01h
	jnz .nok4

.digit5:
	xchg ax, dx
	add al, 48
	stosb

.end:
	xor al, al
	stosb
	popa
	iret
; =========================================


; =========================================
; Zeitstring erzeugen
; DX <= String
; =========================================
getTimeString:
	mov ah, 02h
	int 1Ah
	mov di, .timeStr
	;CH Stunden
	;CL Minuten
	push cx
	mov al, ch
	call private_bcdToInt
	
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	inc di
	pop cx
	
	mov al, cl
	call private_bcdToInt
	
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	mov dx, .timeStr

	iret

.timeStr db "00:00 Uhr", 00h
; =========================================


; =========================================
; Datumsstrings erzeugen
; DX <= Stringoffset
; =========================================
getDateString:
	mov ah, 04h
	int 1Ah
	mov di, .dateStr
	; CH Jahrhundert
	; CL Jahr
	; DH Monat
	; DL Tag
	
	push cx
	push dx
	mov al, dl
	call private_bcdToInt
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	inc di
	
	pop dx
	mov al, dh
	call private_bcdToInt
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	inc di
	
	pop cx
	push cx
	mov al, ch
	call private_bcdToInt
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	pop cx
	mov al, cl
	call private_bcdToInt
	mov bl, 10
	div bl
	add al, 48
	stosb
	mov al, ah
	add al, 48
	stosb
	
	mov dx, .dateStr

	iret
	
.dateStr db "00.00.0000", 00h
; =========================================
; al => BCD Byte
; ax <= Integer
private_bcdToInt:
	mov bl, al			; Speichern
	and ax, 0Fh			; die Oberen Bits löschen
	mov cx, ax			; kopieren
	shr bl, 4			; die Oberen Bits über die Unteren Bits schreiben
	mov al, 10
	mul bl				; AX = 10 * bl		(Zehnerstelle)
	add ax, cx			; Untere Stellen addieren
	ret
bcdToInt:
    call private_bcdToInt
    mov cx, ax
    iret
; =========================================

getSystemVersion:
	mov ah, 0
	mov al, 7
	iret
; =========================================


; ======================================================
; String in Zahl umwandeln
; DX => String
; CX <= Number
; AX <= -1 Error
; ======================================================
stringToInt:
	mov word [.number], 00h
	mov si, dx
    
    mov byte [.sign], 00h
    
    cmp byte [si], '-'
    jne .loop1
    
    inc si
    mov byte [.sign], 01h
    
.loop1:
	cmp byte [ds:si], 00h
	je .done

	cmp byte [ds:si], 0Dh
	je .done
	
	cmp byte [ds:si], 0Ah
	je .done
	
	cmp byte [ds:si], '0'
	jb .error
	cmp byte [ds:si], '9'
	ja .error
	
	mov ax, word [.number]
	shl ax, 1
	mov bx, ax
	shl ax, 2
	add ax, bx
	mov word [.number], ax
	
	mov ah, byte [ds:si]
	sub ah, 48
	
	add [.number], ah
	
	inc si
	jmp .loop1
    
.error:
	mov ax, -1
	xor cx, cx
    
	iret
	
.done:
	
    mov cx, word [.number]
    
    cmp byte [.sign], 01h
    jne .ret
    
    neg cx
    
.ret:
    xor ax, ax
	iret
.number dw 0
.sign db 00h
; ======================================================


; ======================================================
; CL -> dings
; DX <- Hexstring
; ======================================================
decToHex:
	pusha
	pushf
	
	mov ax, cx
	mov si, dx
	xor ah, ah

	mov bl, 16
	div bl
	mov bx, .hexChar
	add bl, al
	mov al, byte [bx]
	mov byte [ds:si], al
	inc si
	mov bx, .hexChar
	add bl, ah
	mov al, byte [bx]
	mov byte [ds:si], al
	inc si
	mov byte [ds:si], 00h
	
	popf
	popa
	
	iret
.hexChar db "0123456789ABCDEF"
; ======================================================


; ======================================================
hexToDec:
	mov si, dx
	xor ax, ax
	xor bx, bx
	mov al, byte [ds:si]
	inc si
	
	cmp al, 48	; Ziffern 0-9
	je .num16
	cmp al, 49
	je .num16
	cmp al, 50
	je .num16
	cmp al, 51
	je .num16
	cmp al, 52
	je .num16
	cmp al, 53
	je .num16
	cmp al, 54
	je .num16
	cmp al, 55
	je .num16
	cmp al, 56
	je .num16
	cmp al, 57
	je .num16
.chars:			; Ziffern A-F
	cmp al, 65
	je .char16
	cmp al, 66
	je .char16
	cmp al, 67
	je .char16
	cmp al, 68
	je .char16
	cmp al, 69
	je .char16
	cmp al, 70
	je .char16

	cmp cx, 1
	je .noc
	mov cx, 1
	sub al, 32
	jmp .chars
.noc:
	mov ax, -1
	iret
	
.num16:
	sub ax, 48
	shl ax, 4
	jmp .hex2
.char16:
	sub ax, 55
	shl ax, 4
.hex2:
	mov bx, ax
	mov al, byte [ds:si]
	inc si
	cmp al, 48
	je .num161
	cmp al, 49
	je .num161
	cmp al, 50
	je .num161
	cmp al, 51
	je .num161
	cmp al, 52
	je .num161
	cmp al, 53
	je .num161
	cmp al, 54
	je .num161
	cmp al, 55
	je .num161
	cmp al, 56
	je .num161
	cmp al, 57
	je .num161
.chars2:
	cmp al, 65
	je .char161
	cmp al, 66
	je .char161
	cmp al, 67
	je .char161
	cmp al, 68
	je .char161
	cmp al, 69
	je .char161
	cmp al, 70
	je .char161
	
	cmp cx, 2
	je .noc2
	mov cx, 2
	sub al, 32
	jmp .chars2
.noc2:
	mov ax, -1
	xor cx, cx
	iret
.num161:
	sub ax, 48
	add bx, ax
	jmp .end
.char161:
	sub ax, 55
	add bx, ax
.end:
    xor ax, ax
	mov cx, bx
	iret
; ======================================================

; ======================================================
random:
    mov ah, 04h
    int 1Ah
    mov ah, 02h
    int 1Ah

    mov ax, cx
    rol ax, cl
    rol dx, 8
    mov cx, ax
    add cx, dx
    mov ax, cx
    xor ax, word [seed]
    mov word [seed], ax
    mov cx, ax
    
    iret
seed dw 623 
; ======================================================


; ======================================================
; Hardwareinfo
; Zeigt Prozessorinformationen an
; AX => CPU Hersteller
; BX => CPU Modell
; ======================================================
hardwareInfo:
    call .getCpuInfo

    mov ax, .vendorString
    mov bx, .modelString

    iret

.getCpuInfo:
    xor eax, eax
    cpuid
    mov [.vendorString], ebx
    mov [.vendorString+4], edx
    mov [.vendorString+8], ecx
	
    mov eax, 80000000h
    cpuid
    cmp eax, 80000004h
    jnge .return
	
    mov eax, 80000002h
    cpuid
    mov [.modelString], eax
    mov [.modelString+4], ebx
    mov [.modelString+8], ecx
    mov [.modelString+12], edx
	
    mov eax, 80000003h
    cpuid
    mov [.modelString+16], eax
    mov [.modelString+20], ebx
    mov [.modelString+24], ecx
    mov [.modelString+28], edx
	
    mov eax, 80000004h
    cpuid
    mov [.modelString+32], eax
    mov [.modelString+36], ebx
    mov [.modelString+40], ecx
    mov [.modelString+44], edx
.return:
    ret
.vendorString times 13 db 00h
.modelString times 49 db 00h
; ======================================================
