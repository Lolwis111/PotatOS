; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt den Bootloader von PotatOS dar.       %
; % Lädt die Datei loader.sys und startet diese. %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x0]           ; 7C00 -> Register später setzen
[BITS 16]

start: 
    jmp boot

%include "bpb.asm" ; BIOS Parameter Block
%include "defines.asm"

; ==============================
; prints a string
; si <= string address
; ==============================
Print:
    lodsb
    or al, al
    jz .return
    mov ah, 0x0E
    int 0x10
    jmp Print
.return:
    ret
; ==============================


; ==============================
; CX = sector count
; AX = start sector
; ES:BX = target buffer address
; =========================================================
ReadSectors:
    .main:
        mov di, 0x0005                          ; give it five tries
    .sectorloop:
        push ax
        push bx
        push cx
        call LBACHS                             ; lineare Sektorangabe in Cluster-Sektor-Head wandeln
        mov ax, 0x0201                          ; BIOS: einen Sektor lesen
        mov ch, byte [absoluteTrack]            ; Spur
        mov cl, byte [absoluteSector]           ; Sektor
        mov dh, byte [absoluteHead]             ; Kopf
        mov dl, byte [DriveNumber]              ; Laufwerk (normalerweise 0)
        int 0x13                                ; BIOS aufrufen
        jnc .success                            ; Fehler? Nein-> Weiter
        xor ax, ax                              ; Ja -> Laufwerk zurücksetzen 
        int 0x13                                ; 
        dec di                                  ; und nochmal probieren.
        pop cx
        pop bx
        pop ax
        jnz .sectorloop
        int 0x18                                ; Nach fünf versuchen kommt der Tod
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
    sub ax, 0x0002
    movzx cx, byte [SectorsPerCluster]
    mul cx
    add ax, word [datasector]
    ret
; ============================================================


; ============================================================
; Linear Block Adresse nach Cylinder Head Sektor Adresse konvertieren
; AX => LBA Adresse
;
; Sektor      = (logischer Sektor / Sektoren pro Spur) + 1
; Kopf    = (logischer Sektor / Sektoren pro Spur) MOD Anzahl Köpfe
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
    cli                     ; set all the segments
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ax, 0x7BFF      ; create a stack
    mov ss, ax
    mov sp, 0x7BFF
    
    sti

    mov byte [SYSTEM_COLOR], 0x07 ; Default color is white on black
    
    mov si, msgLoading
    call Print
    
; load the root directory
LoadRoot:
    ; calculate size in cx
    xor cx, cx  
    xor dx, dx
    mov ax, 0x0020          ; 32 bytes per entry
    mul word [RootEntries]  ; size = 32 Byte * entry count
    div word [BytesPerSector]
    xchg ax, cx
    
    ; Startadresse in AX berechnen
    mov al, byte [NumberOfFATS]         ;
    mul word [SectorsPerFAT]            ; calculate size of fat
    add ax, word [ReservedSectors]      ; add size of bootsector
    mov word [datasector], ax           ; base address of the root dir
    add word [datasector], cx
    
    ; Rootverzeichnis laden (0x7C00:0x0200)
    mov bx, 0x0200
    call ReadSectors


    ; Nach LOADER.SYS suchen
    mov cx, word [RootEntries]
    mov di, 0x0200  ; Basisadresse des Rootverzeichnis
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
    movzx ax, byte [NumberOfFATS]
    mul word [SectorsPerFAT]
    mov cx, ax
    
    ; FAT Position in AX berechnen
    mov ax, word [ReservedSectors]
    
    ; FAT nach 0x7C00:0x0200 laden
    mov bx, 0x0200
    call ReadSectors
    
    mov si, msgNewLine
    call Print
    mov ax, 0x0050  ; Bootdatei Zieladresse
    xor bx, bx
    mov es, ax      ; Bootdatei Zieladresse
    push bx
LoadImage:
    pop bx
    mov ax, word [cluster]
    call ClusterLBA         ; convert address
    movzx cx, byte [SectorsPerCluster]
    call ReadSectors
    push bx
    
    ; calculate next cluster
    mov ax, word [cluster]
    mov dx, ax
    mov cx, ax
    shr dx, 1
    mov bx, 0x0200
    add cx, dx
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
    mov word [cluster], dx  ; save new cluster
    cmp dx, 0x0FF0
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
    int 0x16        ; wait for any key
    int 0x19        ; Reset 
    
        
absoluteSector db 0
absoluteHead db 0
absoluteTrack db 0

datasector  dw 0x0000
cluster     dw 0x0000
ImageName   db "LOADER  SYS"
msgLoading  db 0x0D, 0x0A, "Loading Bootimage..."
msgNewLine  db 0x0D, 0x0A, 0x00
msgOK       db "OK", 0x0D, 0x0A, 0x00
msgFailure  db 0x0D, 0x0A, "ERROR: PRESS ANY KEY TO RESET", 0x0D, 0x0A, 0x00

times 507-($-$$) db 0   ; pad this file to 507 Bytes (leaving 3 Bytes for config + 2 Bytes for signature)

; =======================================================================
; config section - this is where the config for the 16-bit mode is saved
; =======================================================================
config_color_byte db 0x07       ; default is white on black
config_highmem_enable db 0x00   ; disable high memory per default
config_zy_switch db 0x00        ; dont switch z and y on keyboard per default
; =======================================================================

dw 0xAA55               ; and make the last two bytes the boot signature
