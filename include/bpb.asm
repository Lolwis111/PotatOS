%ifndef _BIOS_PARAMETER_BLOCK_
%define _BIOS_PARAMETER_BLOCK_

; ==================================================================================================
; BIOS Parameter Block
; Provides basic information about the disk and the file system
; ==================================================================================================
OEM                 DB "PotatOS "   ; OEM-Name (has to be 8 Bytes long)
BytesPerSector:     DW 512          ; sectorsize in bytes
SectorsPerCluster:  DB 1            ; sectors per cluster
ReservedSectors:    DW 1            ; reserved sectors
NumberOfFATS:       DB 2            ; number of FATs
RootEntries:        DW 224          ; files in the root directory
TotalSectors:       DW 2880         ; total sector count (2880 * 512 Byte = 1.44MB)
Media:              DB 0xF0         ; drive type (Floppy)
SectorsPerFAT:      DW 9            ; FAT-size in sectors
SectorsPerTrack:    DW 18           ; tracksize in sectors
HeadsPerCylinder:   DW 2            ; heads per cylinder
HiddenSectors:      DD 0            ; hidden sectors
TotalSectorsBig:    DD 0            ; totalsectors incase TotalSectors isnt big enough
DriveNumber:        DB 0            ; drive number (0 = erste Floppy)
Unused:             DB 41           ; FAT12, 1.44MB DOS Floppy
ExtBootSignature:   DB 0x29         ; signature
SerialNumber:       DD 0x9a8b7c6d   ; serial number (doesnt really matter)
VolumeLabel:        DB "POTATOSBOOT"; label (has to be 11 Bytes)
FileSystem:         DB "FAT12   "   ; filesystem name (has to be 8 Bytes, not reliable)
; ==================================================================================================

%endif
