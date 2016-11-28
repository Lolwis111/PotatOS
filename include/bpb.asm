%ifndef _BIOS_PARAMETER_BLOCK_
%define _BIOS_PARAMETER_BLOCK_

; =========================================================
; BIOS Parameter Block
; Stellt Informationen zum Dateisystem bereit
; =========================================================
OEM					DB "PotatOS "	; OEM-Name (Muss 8 Bytes lang sein)
BytesPerSector:  	DW 512          ; Sektorengroesse in Byte
SectorsPerCluster: 	DB 1            ; Sektoren pro Cluster
ReservedSectors: 	DW 1            ; reservierte Sektoren (einer fuer Bootloader)
NumberOfFATS: 		DB 2            ; Anzahl an FATs
RootEntries: 		DW 224          ; maximale Anzahl an Dateien in root (FAT12 Limit)
TotalSectors: 		DW 2880         ; Gesamtanzahl an Sektoren (2880 * 512 Byte = 1.44MB)
Media: 				DB 0xF0         ; Laufwerkstyp (Floppy)
SectorsPerFAT: 		DW 9            ; FAT-Groesse in Sektoren
SectorsPerTrack: 	DW 18d          ; Spurgroesse in Sektoren
HeadsPerCylinder: 	DW 2            ; Lesekoepfe pro Zylinder
HiddenSectors: 		DD 0            ; Versteckte Sektoren
TotalSectorsBig:    DD 0            ; TODO: Beschreibung
DriveNumber:		DB 0            ; Laufwerksnummer (0 = erste Floppy)
Unused: 			DB 41           ; FAT12, 1.44MB DOS Floppy
ExtBootSignature: 	DB 0x29         ; Bootsignatur
SerialNumber:		DD 0x00         ; Seriennummer (idr egal)
VolumeLabel:		DB "POTATOSBOOT"; Laufwerkstitel (muss 11 Bytes lang sein)
FileSystem:			DB "FAT12   "	; Dateisystem (muss 8 Bytes lang sein, ist nicht verlaesslich)
; =========================================================

%endif
