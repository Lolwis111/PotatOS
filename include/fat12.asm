; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt Methoden für das FAT12-Dateisystem    %
; % zur verfügung. Lesen, Schreiben, Löschen,    %
; % Umbenennen, Anlegen, Suchen                  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _FAT12_INC_
%define _FAT12_INC_

[BITS 16]

%include "floppy16.asm"
%define ROOT_OFFSET 4000h
%define FAT_SEG 380h 	;380h
%define ROOT_SEG 400h 	;400h

;=======================================
;LoadRoot()
;	Rootverzeichnis nach 7E00 laden
;=======================================
LoadRoot:
	pusha
	push es

	xor cx, cx	
	mov ax, 32d
	xor dx, dx
	
	mul word [RootEntries]
	
	div word [BytesPerSector]
	
	xchg ax, cx
	
	mov al, byte [NumberOfFATS]
	
	mul word [SectorsPerFAT]
	
	add ax, word [ReservedSectors]
	
	mov word [datasector], ax
	
	add word [datasector], cx
	
	xor bx, bx
	mov es, bx
	mov bx, ROOT_OFFSET
	call ReadSectors
	
	pop es
	popa
	
	ret
;=======================================


;=======================================
;WriteRoot()
;	Schreibt das (geänderte) Rootverzeichnis
;	auf den Datenträger
;=======================================
WriteRoot:
	pusha
	push es

	xor cx, cx
	mov ax, 32d
	xor dx, dx
	mul WORD [RootEntries]
	
	div WORD [BytesPerSector]
	
	xchg ax, cx
	
	mov al, byte [NumberOfFATS]
	mul WORD [SectorsPerFAT]
	add ax, WORD [ReservedSectors]
	
	mov word [datasector], ax
	add word [datasector], cx
	
	xor bx, bx
	mov es, bx
	mov bx, ROOT_OFFSET
	call WriteSectors
	
	pop es
	popa
	ret
;=======================================


;=======================================
;LoadFAT()
;	FAT nach 7C00 laden
;	ES => Rootverzeichnis
;=======================================
LoadFAT:
	pusha
	push es
	
	xor ax, ax
	mov al, byte [NumberOfFATS]
	
	mul word [SectorsPerFAT]
	mov cx, ax
	
	mov ax, word [ReservedSectors]
	
	push word FAT_SEG
	xor bx, bx
	pop es
	call ReadSectors
	
	pop es
	popa
	ret
;=======================================


;=======================================
;LoadFAT()
;	FAT nach 7C00 laden
;	ES => Rootverzeichnis
;=======================================
WriteFAT:
	pusha
	push es
	
	xor ax, ax
	mov al, byte [NumberOfFATS]
	
	mul word [SectorsPerFAT]
	mov cx, ax
	
	mov ax, word [ReservedSectors]
	
	push word FAT_SEG
	xor bx, bx
	pop es
	
	call WriteSectors
	
	pop es
	popa
	ret
;=======================================


;=======================================
;FindDir()
;	Sucht ein Verzeichnis im Rootverzeichnis
;	SI => Verzeichnisname
;	AX <= Index des Verzeichnisses
;=======================================
FindDir:
	push cx
	push dx
	push bx
	
	call LoadRoot
	
	mov cx, word [RootEntries]
	mov bx, si
	mov di, ROOT_OFFSET
	cld
.loop1:
	push cx
	
	mov si, bx
	mov cx, 11
	push di
	rep cmpsb
	pop di
	jne .skip
	
	add di, 11d
	test byte [di], 00010000b
	jnz .Found
	
.skip:
	pop cx
	add di, 20h
	loop .loop1
	
.NotFound:
	pop bx
	pop dx
	pop cx
	
	mov ax, -1
	ret
.Found:
	pop ax
	pop bx
	pop dx
	pop cx
	
	ret
;=======================================


;=======================================
;FindFile()
;	Sucht eine Datei im Rootverzeichnis
;	SI => Dateiname

;	AX <= Index der Datei
;=======================================
FindFile:
	push cx
	push dx
	push bx
	
	call LoadRoot
	
	mov cx, word [RootEntries]
	mov bx, si
	mov di, ROOT_OFFSET
	cld
.loop1:
	push cx
	
	mov si, bx
	mov cx, 11
	push di
	rep cmpsb
	pop di
	
	je .Found
	
	pop cx
	add di, 20h
	loop .loop1
	
.NotFound:
	pop bx
	pop dx
	pop cx
	
	mov ax, -1
	ret
.Found:
	pop ax
	pop bx
	pop dx
	pop cx
	
	ret
;=======================================


;=======================================
;DeleteFile()
;	Löscht eine Datei
;	SI => Dateiname
;	AX <= 0=OK,1=Error
;=======================================
DeleteFile:
	pusha
	
	call LoadRoot
	push si
	call FindFile
	cmp ax, -1
	je .notFoundError
	pop si

	mov cx, word [RootEntries]
	mov di, ROOT_OFFSET
.entry_loop:
	push cx
	push si
	push di
	mov cx, 11d
	rep cmpsb
	je .found
	
	pop di
	pop si
	
	add di, 32
	pop cx
	loop .entry_loop
	
	jmp .error
	
.found:
	pop di
	pop si
	pop cx
	
	mov ax, word [es:di+26]
	mov word [.cluster], ax
	
	mov byte [di], 0xE5
	
	inc di
	
	xor cx, cx
.cleanLoop:
	mov byte [di], 0
	inc di
	inc cx
	cmp cx, 31d
	jl .cleanLoop
	
	call WriteRoot
	call LoadFAT
	mov di, 3800h
	
.moreCluster:
	mov ax, word [.cluster]
	
	test ax, ax
	je .done
	
	mov bx, 3
	mul bx
	shr ax, 10
	mov si, 3800h
	add si, ax
	mov ax, word [si]
	
	test dx, dx
	jz .even
	
.odd:
	push ax
	and ax, 000Fh
	mov word [si], ax
	pop ax
	shr ax, 4
	jmp .calcClusterCount
	
.even:
	push ax
	and ax, 0xF000
	mov word [si], ax
	pop ax
	
	and ax, 0FFFh
	
.calcClusterCount:
	mov word [.cluster], ax
	
	cmp ax, 0FF8h
	jae .end
	
	jmp .moreCluster
	
.end:
	call WriteFAT
	
.done:

	popa
	xor ax, ax
	ret
.notFoundError:
	pop si
	mov ax, 1
	ret
.error:

	popa
	mov ax, -1
	ret

.cluster dw 0
;=======================================


;=======================================
;CreateFile()
;	Erzeugt eine leere Datei
;	DI => Speicheradresse des Verzeichnisses
;	SI => Dateiname
;	AX <= 0=OK,1=Error
;=======================================
CreateFile:
	push es
	pusha
	xor ax, ax
	push si
	mov es, ax
	call LoadRoot
	call FindFile
	cmp ax, -1
	jne .error	
	
	mov cx, WORD [RootEntries]
	mov di, ROOT_OFFSET
.entry_loop:
	mov al, byte [di]
	cmp al, 00h
	je .found
	cmp al, 0E5h
	je .found
	add di, 32
	loop .entry_loop
	
.noSpaceError:
	pop si
	popa
	mov ax, 1
	pop es
	ret
	
.found:
	pop si
	
	mov cx, 11d
	rep movsb
	
	sub di, 11
	
	mov ah, 2h
	int 1Ah

	; ch Stunden
	; cl Minuten
	; dh Sekunde
	
	mov byte [.minute], cl
	shr dh, 1
	mov byte [.second], dh
	
	mov al, ch
	call .bcdToInt
	and ax, 001Fh
	shl ax, 11d
	mov bp, ax
	mov al, byte [.minute]
	call .bcdToInt
	and ax, 003Fh
	shl ax, 5d
	add bp, ax
	mov al, byte [.second]
	call .bcdToInt
	and ax, 001Fh
	add bp, ax
	
	push bp
	
	mov ah, 04h
	int 1Ah
	
	; cl Jahr
	; dh Monat
	; dl Tag
	
	mov byte [.minute], dh
	mov byte [.second], dl
	
	mov al, cl
	call .bcdToInt
	add ax, 20d
	and ax, 007Fh
	shl ax, 9d
	mov si, ax
	mov al, byte [.minute]
	call .bcdToInt
	and ax, 000Fh
	shl ax, 5d
	add si, ax
	mov al, byte [.second]
	call .bcdToInt
	and ax, 001Fh
	add si, ax
	
	mov byte [di+11], 0		; Attributes
	
	mov byte [di+12], 0		; Reserved
	mov byte [di+13], 0		; Reserved
	
	pop bp
	
	mov word [di+14], bp	; Creation time
	
	push bp
	
	mov word [di+16], si
	
	;mov byte [di+16], 0		; Creation date
	;mov byte [di+17], 0		; Creation date
	
	;mov byte [di+18], 0		; Last access date
	;mov byte [di+19], 0		; Last access date
	mov word [di+16], si
	
	mov word [di+18], si
	
	mov byte [di+20], 0		; Ignore in FAT12
	mov byte [di+21], 0		; Ignore in FAT12
	
	pop bp
	mov word [di+22], bp	; Last write time
	
	;mov byte [di+24], 0		; Last write date
	;mov byte [di+25], 0		; Last write date
	mov word [di+24], si
	
	mov byte [di+26], 0		; First logical cluster
	mov byte [di+27], 0		; First logical cluster

	mov byte [di+28], 0		; File size
	mov byte [di+29], 0		; File size
	mov byte [di+30], 0		; File size
	mov byte [di+31], 0		; File size
	
	call WriteRoot
	
	popa
	xor ax, ax
	pop es
	ret
.error:
	pop si
	popa
	mov ax, -1
	pop es
	
	ret
; AL -> BCD
; AX <- Number
.bcdToInt:
	mov bl, al			;Speichern
	and ax, 0Fh			;die Oberen Bits löschen
	mov cx, ax			;kopieren
	shr bl, 4			;die Oberen Bits über die Unteren Bits schreiben
	mov al, 10
	mul bl				;AX = 10 * bl		(Zehnerstelle)
	add ax, cx			;Untere Stellen addieren
	ret
.minute db 00h
.second db 00h
;=======================================


;=======================================
;WriteFile()
;	Schreibt eine Datei
;	SI => Dateiname
;	DI => Speicheradresse des Verzeichnisses
;	BP:BX => Daten
;	CX => Byteanzahl
;	AX <= 0=OK, 1=Error,2=Datei existiert bereits
;=======================================
WriteFile:
	push es
	pusha

	xor ax, ax
	mov es, ax
	mov word [.fileName], si
	mov word [.fileSize], cx
	mov word [.dataBuffer], bp
	mov word [.dataBuffer+2], bx
	mov di, .clusterChain
	mov cx, 64
	xor al, al
	rep stosw
	mov ax, word [.fileSize]
	mov bx, 512
	xor dx, dx
	div bx
	cmp dx, 0
	jg .add_sector
	jmp .carry_on
.add_sector:
	inc ax
.carry_on:
	mov word [.clusterCount], ax
	mov si, word [.fileName]
	call CreateFile
	cmp ax, -1
	je .error
	cmp word [.fileSize], 00h
	je .writeDone
	call LoadFAT
	mov si, 3803h
	mov bx, 2
	mov cx, word [.clusterCount]
	xor dx, dx
.findFreeCluster:
	lodsw
	and ax, 0FFFh
	jz .foundEvenCluster
.moreOdd:
	inc bx
	dec si
	lodsw
	shr ax, 4
	or ax, ax
	jz .foundOddCluster
.moreEven:
	inc bx
	jmp .findFreeCluster
.foundEvenCluster:
	push si
	mov si, .clusterChain
	add si, dx
	mov word [si], bx
	pop si
	dec cx
	test cx, cx
	jz .listDone
	add dx, 2
	jmp .moreOdd
.foundOddCluster:
	push si
	mov si, .clusterChain
	add si, dx
	mov word [si], bx
	pop si
	dec cx
	test cx, cx
	jz .listDone
	add dx, 2
	jmp .moreEven
.listDone:
	xor cx, cx
	mov word [.count], 01h
.chainLoop:
	mov ax, word [.count]
	cmp ax, word [.clusterCount]
	je .lastCluster
	mov di, .clusterChain
	add di, cx
	mov bx, word [di]
	mov ax, bx
	xor dx, dx
	mov bx, 3
	mul bx
	mov bx, 2
	div bx
	mov si, 3800h
	add si, ax
	mov ax, word [ds:si]
	or dx, dx
	jz .even
.odd:
	and ax, 000Fh
	mov di, .clusterChain
	add di, cx
	mov bx, word [di+2]
	shl bx, 4
	add ax, bx
	mov word [ds:si], ax
	inc word [.count]
	add cx, 2
	jmp .chainLoop
.even:
	and ax, 0F000h
	mov di, .clusterChain
	add di, cx
	mov bx, word [di+2]
	add ax, bx
	mov word [ds:si], ax
	inc word [.count]
	add cx, 2
	jmp .chainLoop
.lastCluster:
	mov di, .clusterChain
	add di, cx
	mov ax, word [di]
	xor dx, dx
	mov bx, 3
	mul bx
	mov bx, 2
	div bx
	mov si, 3800h
	add si, ax
	mov ax, word [ds:si]
	or dx, dx
	jz .lastEven
.lastOdd:
	and ax, 000Fh
	add ax, 0FF80h
	jmp .clusterDone
.lastEven:
	and ax, 0F000h
	add ax, 0FF8h
.clusterDone:
	mov word [ds:si], ax
	call WriteFAT
	xor cx, cx
.saveLoop:
	mov di, .clusterChain
	add di, cx
	mov ax, word [di]
	cmp ax, 0
	je .writeRootEntry
	pusha
	add ax, 31
	mov cx, 01h
	mov bp, word [.dataBuffer]
	mov bx, word [.dataBuffer+2]
	call WriteSectors
	popa
	add word [.dataBuffer+2], 512d
	add cx, 2
	jmp .saveLoop
.writeRootEntry:
	call LoadRoot
	mov si, word [.fileName]
	mov di, ROOT_OFFSET
	mov cx, word [RootEntries]
.scanLoop:
	push cx
	push si
	push di
	mov cx, 11d
	rep cmpsb
	je .entryFound
	pop di
	pop si
	add di, 32d	
	pop cx
	loop .scanLoop
	jmp .error
.entryFound:
	pop di
	pop si
	pop cx
	mov ax, word [.clusterChain]
	mov word [di+26], ax
	mov cx, word [.fileSize]
	mov word [di+28], cx
	mov word [di+30], 0000h
	call WriteRoot
.writeDone:
	popa
	pop es
	xor ax, ax
	ret
.error:
	popa
	pop es
	mov ax, -1
	ret

.clusterChain times 128 dw 00h 
.clusterCount dw 00h
.fileName db "           ", 00h
.fileSize dw 00h
.count dw 0000h
.dataBuffer dq 00h
;=======================================


;=======================================
;LoadFile()
;	Lädt eine Datei
;	SI => Dateiname
;	BP:BX => Zielbuffer
;	DI => Speicheradresse des Verzeichnisses
;	AX <= 0=OK, -1=ERROR
;	CX <= Anzahl Sektoren
;=======================================
LoadFile:
	push ecx
	xor ecx, ecx
	
.findFile:
	push bx
	push bp
	
	call LoadRoot
	
	call FindFile
	cmp ax, -1
	jne .loadImagePre
	
	pop bp
	pop bx
	pop ecx
	
	mov ax, -1
	ret
	
.loadImagePre:
	sub edi, ROOT_OFFSET
	sub eax, ROOT_OFFSET
	
	mov ax, ROOT_SEG
	mov es, ax
	
	mov dx, word [es:di+001Ah]		; Startcluster
	
	push ecx
	mov ecx, dword [es:di+001Ch]	; Dateigröße
	mov word [.fileSize], cx
	pop ecx
	
	mov word [cluster], dx
	
	pop bx
	pop es
	
	push bx
	push es
	
	call LoadFAT
	
.loadImage:
	mov ax, word [cluster]
	pop es
	pop bx
	
	call ClusterLBA
	
	movzx cx, byte [SectorsPerCluster]
	
	call ReadSectors
	
	pop ecx
	inc ecx
	push ecx
	
	push bx
	push es

	mov ax, FAT_SEG
	xor bx, bx
	mov es, ax
	
	mov ax, word [cluster]
	mov dx, ax
	mov cx, ax
	shr dx, 00001h
	add cx, dx
	
	xor bx, bx
	add bx, cx
	mov dx, word [es:bx]
	test ax, 0001h
	jnz .oddCluster
	
.evenCluster:
	and dx, 0FFFh
	
	jmp .done
.oddCluster:
	shr dx, 4h
	
.done:
	mov word [cluster], dx
	cmp dx, 0FF0h
	
	jb .loadImage
.success:
	xor ax, ax
	
	pop es
	pop bx
	pop ecx
	
	mov cx, word [.fileSize]
	ret
.fileSize dw 0000h
.rootOffset dd 00000000h
;=======================================

%endif
