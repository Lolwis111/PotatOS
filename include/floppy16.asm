; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt Methoden zum Lesen auf Schreiben auf  %
; % Disketten zur verfügung (LOW_LEVEL_IO)       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _FLOPPY16_INC_
%define _FLOPPY16_INC_

[BITS 16]

%include "bpb.asm"

datasector dw 0000h
cluster dw 0000h
absoluteSector db 00h
absoluteHead db 00h
absoluteTrack db 00h

;=============================================
;ClusterLBA()
;	LBA = (cluster - 2) * Sektoren pro Cluster
;=============================================
ClusterLBA:
	xor cx, cx
	sub ax, 0002h
	mov cl, byte [SectorsPerCluster]
	
	mul cx
	
	add ax, word [datasector]
	
	ret
;=============================================

;=============================================
;LBACHS()
;	absolut Sektor = (logischer Sektor / Sektoren pro Spur) + 1
;	absolut Kopf   = (logischer Sektor / Sektoren pro Spur) MOD Anzahl Köpfe
;	absolut Spur   = logischer Sektor / (Sektoren pro Spur * Anzahl Köpfe)
;=============================================
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
;=============================================

;=============================================
;ReadSectors()
;	CX => Anzahl Sektoren
;	AX => Startsektor
;	ES:EBX => Zielbuffer
;=============================================
ReadSectors:
.main:
	mov di, 0005h
.sectorLoop:
	push ax
	push bx
	push cx
	
	call LBACHS
	
	mov ax, 0201h
	mov ch, BYTE [absoluteTrack]
	mov cl, BYTE [absoluteSector]
	
	mov dh, BYTE [absoluteHead]
	mov dl, BYTE [DriveNumber]
	
	int 13h
	jnc .success
	
	xor ax, ax
	int 13h
	
	dec di
	
	pop cx
	pop bx
	pop ax
	
	cmp di, 00h
	jnz .sectorLoop
	
	int 18h
.success:
	pop cx
	pop bx
	pop ax
	
	add bx, WORD [BytesPerSector]
	
	inc ax
	
	loop .main
	ret
;=============================================


;=============================================
;WriteSectors()
;	CX => Anzahl Sektoren
;	AX => Startsektor
;	ES:BX => Daten
;=============================================
WriteSectors:
.main:
	mov di, 0005h
.sectorLoop:
	push ax
	push bx
	push cx
	
	call LBACHS
	
	mov ax, 0301h
	mov ch, BYTE [absoluteTrack]
	mov cl, BYTE [absoluteSector]
	
	mov dh, BYTE [absoluteHead]
	mov dl, BYTE [DriveNumber]
	
	int 13h
	jnc .success
	
	xor ax, ax
	int 13h
	
	dec di
	
	pop cx
	pop bx
	pop ax
	
	cmp di, 00h
	jnz .sectorLoop
	
	int 18h
.success:
	pop cx
	pop bx
	pop ax
	
	add bx, WORD [BytesPerSector]
	
	inc ax
	
	loop .main
	ret
;=============================================

%endif
