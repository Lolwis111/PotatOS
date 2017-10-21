;=======================================
;WriteFile()
;   Schreibt eine Datei
;   SI => Dateiname
;   DI => Speicheradresse des Verzeichnisses
;   BP:BX => Daten
;   CX => Byteanzahl
;   AX <= 0=OK, 1=Error,2=Datei existiert bereits
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
    cmp word [.fileSize], 0x00
    je .writeDone
    call LoadFAT
    mov si, DIRECTORY_OFFSET+3
    mov bx, 2
    mov cx, word [.clusterCount]
    xor dx, dx
.findFreeCluster:
    lodsw
    and ax, 0x0FFF
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
    mov word [.count], 0x01
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
    mov si, DIRECTORY_OFFSET
    add si, ax
    mov ax, word [ds:si]
    or dx, dx
    jz .even
.odd:
    and ax, 0x000F
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
    and ax, 0xF000
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
    mov si, DIRECTORY_OFFSET
    add si, ax
    mov ax, word [ds:si]
    or dx, dx
    jz .lastEven
.lastOdd:
    and ax, 0x000F
    add ax, 0xFF80
    jmp .clusterDone
.lastEven:
    and ax, 0xF000
    add ax, 0x0FF8
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
    mov cx, 0x01
    mov bp, word [.dataBuffer]
    mov bx, word [.dataBuffer+2]
    call WriteSectors
    popa
    add word [.dataBuffer+2], 512
    add cx, 2
    jmp .saveLoop
.writeRootEntry:
    call LoadRoot
    mov si, word [.fileName]
    mov di, DIRECTORY_OFFSET
    mov cx, word [RootEntries]
.scanLoop:
    push cx
    push si
    push di
    mov cx, 11
    rep cmpsb
    je .entryFound
    pop di
    pop si
    add di, 32
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
    mov word [di+30], 0x0000
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

.clusterChain times 128 dw 0x00 
.clusterCount dw 0x0000
.fileName db "           ", 0x00
.fileSize dw 0x0000
.count dw 0x0000
.dataBuffer dw 0x0000, 0x0000
;=======================================