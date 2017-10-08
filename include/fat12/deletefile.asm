;=======================================
;DeleteFile()
;   Löscht eine Datei
;   SI => Dateiname
;   AX <= 0=OK,1=Error
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
    mov di, DIRECTORY_OFFSET
.entry_loop:
    push cx
    push si
    push di
    mov cx, 11
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
    cmp cx, 31
    jl .cleanLoop
    
    call WriteRoot
    call LoadFAT
    mov di, DIRECTORY_OFFSET
    
.moreCluster:
    mov ax, word [.cluster]
    
    test ax, ax
    je .done
    
    mov bx, 3
    mul bx
    shr ax, 10
    mov si, DIRECTORY_OFFSET
    add si, ax
    mov ax, word [si]
    
    test dx, dx
    jz .even
    
.odd:
    push ax
    and ax, 0x000F
    mov word [si], ax
    pop ax
    shr ax, 4
    jmp .calcClusterCount
    
.even:
    push ax
    and ax, 0xF000
    mov word [si], ax
    pop ax
    
    and ax, 0x0FFF
    
.calcClusterCount:
    mov word [.cluster], ax
    
    cmp ax, 0x0FF8
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