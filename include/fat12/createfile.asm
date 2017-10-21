;=======================================
;CreateFile()
;   Erzeugt eine leere Datei
;   DI => Speicheradresse des Verzeichnisses
;   SI => Dateiname
;   AX <= 0=OK,1=Error
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
    mov di, DIRECTORY_OFFSET
.entry_loop:
    mov al, byte [di]
    cmp al, 0x00
    je .found
    cmp al, 0xE5
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
    
    mov cx, 11
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
    and ax, 0x001F
    shl ax, 11
    mov bp, ax
    mov al, byte [.minute]
    call .bcdToInt
    and ax, 0x003F
    shl ax, 5
    add bp, ax
    mov al, byte [.second]
    call .bcdToInt
    and ax, 0x001F
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
    add ax, 20
    and ax, 0x007F
    shl ax, 9
    mov si, ax
    mov al, byte [.minute]
    call .bcdToInt
    and ax, 0x000F
    shl ax, 5
    add si, ax
    mov al, byte [.second]
    call .bcdToInt
    and ax, 0x001F
    add si, ax
    
    mov byte [di+11], 0     ; Attributes
    
    mov byte [di+12], 0     ; Reserved
    mov byte [di+13], 0     ; Reserved
    
    pop bp
    
    mov word [di+14], bp    ; Creation time
    
    push bp
    
    mov word [di+16], si
    
    ;mov byte [di+16], 0        ; Creation date
    ;mov byte [di+17], 0        ; Creation date
    
    ;mov byte [di+18], 0        ; Last access date
    ;mov byte [di+19], 0        ; Last access date
    mov word [di+16], si
    
    mov word [di+18], si
    
    mov byte [di+20], 0     ; Ignore in FAT12
    mov byte [di+21], 0     ; Ignore in FAT12
    
    pop bp
    mov word [di+22], bp    ; Last write time
    
    ;mov byte [di+24], 0        ; Last write date
    ;mov byte [di+25], 0        ; Last write date
    mov word [di+24], si
    
    mov byte [di+26], 0     ; First logical cluster
    mov byte [di+27], 0     ; First logical cluster

    mov byte [di+28], 0     ; File size
    mov byte [di+29], 0     ; File size
    mov byte [di+30], 0     ; File size
    mov byte [di+31], 0     ; File size
    
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
    mov bl, al          ;Speichern
    and ax, 0x0F        ;die Oberen Bits löschen
    mov cx, ax          ;kopieren
    shr bl, 4           ;die Oberen Bits über die Unteren Bits schreiben
    mov al, 10
    mul bl              ;AX = 10 * bl       (Zehnerstelle)
    add ax, cx          ;Untere Stellen addieren
    ret
.minute db 0x00
.second db 0x00
;=======================================