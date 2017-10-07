; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt Methoden zum Lesen auf Schreiben auf  %
; % Disketten zur verfügung (LOW_LEVEL_IO)       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _FLOPPY16_INC_
%define _FLOPPY16_INC_

[BITS 16]

%include "bpb.asm"

datasector dw 0x0000
cluster dw 0x0000
absoluteSector db 0x00
absoluteHead db 0x00
absoluteTrack db 0x00

;=============================================
;ClusterLBA()
;	LBA = (cluster - 2) * Sektoren pro Cluster
;=============================================
ClusterLBA:
	xor cx, cx
	sub ax, 0x0002
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
	mov di, 0x0005
.sectorLoop:
	push ax
	push bx
	push cx
	
	call LBACHS
	
	mov ax, 0x0201
	mov ch, BYTE [absoluteTrack]
	mov cl, BYTE [absoluteSector]
	
	mov dh, BYTE [absoluteHead]
	mov dl, BYTE [DriveNumber]
	
	int 0x13
	jnc .success
	
	xor ax, ax
	int 0x13
	
	dec di
	
	pop cx
	pop bx
	pop ax
	
	cmp di, 0x00
	jnz .sectorLoop
	
	int 0x18
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
	mov di, 0x0005
.sectorLoop:
	push ax
	push bx
	push cx
	
	call LBACHS
	
	mov ax, 0x0301
	mov ch, BYTE [absoluteTrack]
	mov cl, BYTE [absoluteSector]
	
	mov dh, BYTE [absoluteHead]
	mov dl, BYTE [DriveNumber]
	
	int 0x13
	jnc .success
	
	xor ax, ax
	int 0x13
	
	dec di
	
	pop cx
	pop bx
	pop ax
	
	cmp di, 0x00
	jnz .sectorLoop
	
	int 0x18
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
