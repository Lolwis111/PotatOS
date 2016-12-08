; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt den Bootloader von PotatOS dar.       %
; % Lädt die Datei loader.sys und startet diese. %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x0]			; 7C00 -> Register später setzen
[BITS 16]

start: 
	jmp boot

%include "bpb.asm" ; BIOS Parameter Block
%include "defines.asm"

; ==============================
; Gibt eine Zeichenkette aus
; SI => Adresse der Zeichenkette
; ==============================
Print:
	lodsb
	or al, al
	jz .return
	mov ah, 0Eh
	int 10h
	jmp Print
.return:
	ret
; ==============================


; ==============================
; CX = Anzahl Sektoren
; AX = Startsektor
; ES:BX = Zieladresse
; =========================================================
ReadSectors:
	.main:
		mov di, 0005h                           ; Fünf mal versuchen die Datei zu lesen
    .sectorloop:
		push ax
		push bx
		push cx
		call LBACHS 							; lineare Sektorangabe in Cluster-Sektor-Head wandeln
		mov ax, 0201h                           ; BIOS: einen Sektor lesen
		mov ch, byte [absoluteTrack]            ; Spur
		mov cl, byte [absoluteSector]           ; Sektor
		mov dh, byte [absoluteHead]             ; Kopf
		mov dl, byte [DriveNumber]              ; Laufwerk (normalerweise 0)
		int 13h                                 ; BIOS aufrufen
		jnc .success                            ; Fehler? Nein-> Weiter
		xor ax, ax                              ; Ja -> Laufwerk zurücksetzen 
		int 13h                                 ; 
		dec di                                  ; und nochmal probieren.
		pop cx
		pop bx
		pop ax
		jnz .sectorloop
        int 18h 								; Nach fünf versuchen kommt der Tod
	.success:
		pop cx
		pop bx
		pop ax
		add bx, word [BytesPerSector]           ; den nächsten Pufferbereich addressieren
		inc ax                                  ; den nächsten Sektor addressieren
		loop .main                              ; und weiterlesen.
		ret
;==========================================================


; =========================================================
; Adresse aus Cluster berechnen
; LBA = (Cluster - 2) * Sektoren pro Cluster
; =========================================================
ClusterLBA:
	sub ax, 0002h
	xor cx, cx
	mov cl, byte [SectorsPerCluster]
	mul cx
	add ax, word [datasector]
	ret
; ============================================================


; ============================================================
; Linear Block Adresse nach Cylinder Head Sektor Adresse konvertieren
; AX => LBA Adresse
;
; Sektor	  = (logischer Sektor / Sektoren pro Spur) + 1
; Kopf	  = (logischer Sektor / Sektoren pro Spur) MOD Anzahl Köpfe
; Zylinder = logischer Sektor / (Sektoren pro Spur * Anzahl Köpfe)
; ============================================================
LBACHS:
	xor dx, dx
	div word [SectorsPerTrack] 
	inc dl
	mov byte [absoluteSector], dl
	xor dx, dx
	div word [HeadsPerCylinder]
	mov byte [absoluteHead], dl
	mov byte [absoluteTrack], al
	ret
; ============================================================
	

; ============================================================
; Der eigentlich Bootvorgang
; ============================================================
boot: 
	mov byte [SYSTEM_BOOT_DRIVE], dl   ; Startlaufwerk sichern

    cli                     ; Segmente entsprechend setzen
	mov ax, 07C0h
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ax, 0x7BFF      ; Stack erzeugen
    mov ss, ax
    mov sp, 0x7BFF
	
    sti

	mov byte [SYSTEM_COLOR], 07h ; Standartfarbe (Weiß auf schwarz) setzen
	
	mov si, msgLoading
	call Print
	
; Rootverzeichnis laden
LoadRoot:
    ; Größe in CX berechnen
    xor cx, cx  
    xor dx, dx
    mov ax, 0020h 			; 32 Byte einträge
    mul word [RootEntries]	; Größe = 32 Byte * Anzahl Einträge
    div word [BytesPerSector]
    xchg ax, cx
	
    ; Startadresse in AX berechnen
    mov al, byte [NumberOfFATS]         ;
    mul word [SectorsPerFAT]            ; Größe der FAT's berechnen
    add ax, word [ReservedSectors]      ; Bootsektor Größe addieren
    mov word [datasector], ax           ; Basisadresse des Rootverzeichnis
	add word [datasector], cx
	
    ; Rootverzeichnis laden (0x7C00:0x0200)
    mov bx, 0200h
    call ReadSectors


    ; Nach LOADER.SYS suchen
    mov cx, word [RootEntries]
    mov di, 0200h   ; Basisadresse des Rootverzeichnis
.Loop:
    push cx
    mov cx, 11      ; 11 Zeichen pro Dateiname
    mov si, ImageName
    push di
    rep cmpsb       ; Auf übereinstimmung prüfen
    pop di
    je LoadFAT      ; Datei laden wenn überstimmung
	pop cx
    add di, 32	
    loop .Loop      ; Nächste Datei überprüfen
    jmp Failure     ; Datei nicht vorhanden
	
LoadFAT:
    mov si, msgNewLine
    call Print
    ; Startcluster speichern
    mov dx, word [di+26]    ; 32 Byte Eintrag -> Offset 26 Startadresse
    mov word [cluster], dx
	
    ; FAT Größe in CX berechnen
    xor ax, ax
    mov al, byte [NumberOfFATS]
    mul word [SectorsPerFAT]
    mov cx, ax
	
	; FAT Position in AX berechnen
    mov ax, word [ReservedSectors]
	
    ; FAT nach 0x7C00:0x0200 laden
    mov bx, 0200h
    call ReadSectors
	
    mov si, msgNewLine
    call Print
    mov ax, 0050h   ; Bootdatei Zieladresse
	mov es, ax      ; Bootdatei Zieladresse
	xor bx, bx
	push bx

LoadImage:
	mov ax, word [cluster]
	pop bx
	call ClusterLBA	        ; Adresse konvertieren
	xor cx, cx
	mov cl, byte [SectorsPerCluster]
	call ReadSectors
	push bx
	
	; nächstes Dateicluster berechnen
	mov ax, word [cluster]
	mov cx, ax
	mov dx, ax
	shr dx, 1
	add cx, dx
	mov bx, 0200h
	add bx, cx
	mov dx, word [bx]
	test ax, 1
	jnz .oddCluster
	
.evenCluster:
	and dx, 0000111111111111b
	jmp .done
	
.oddCluster:
	shr dx, 4
	
.done:
	mov word [cluster], dx	; neues Cluster speichern
	cmp dx, 0FF0h
	jb LoadImage
	mov si, msgOK
	call Print
	jmp 0x0050:0x0000
	
	cli
	hlt

Failure:
	mov si, msgFailure
	call Print
	xor ax, ax
	int 16h			; Warten auf Tastendruck
	int 19h			; Reset	
	
		
absoluteSector db 0
absoluteHead db 0
absoluteTrack db 0

datasector  dw 0000h
cluster     dw 0000h
ImageName   db "LOADER  SYS"
msgLoading  db 0Dh, 0Ah, "Loading Bootimage...", 0Dh, 0Ah, 00h
msgNewLine  db 0Dh, 0Ah, 00h
msgOK       db "OK", 0Dh, 0Ah, 00h
msgFailure  db 0Dh, 0Ah, "ERROR LOADER.SYS: Press any key to reset", 0Dh, 0Ah, 00h
		
times 510-($-$$) db 0   ; Dateigröße auf 512 Bytes füllen
dw 0xAA55               ; (bzw. 510 da die letzen beiden Bootsignatur sind)
