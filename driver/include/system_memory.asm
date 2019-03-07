initMemory:
    push eax
    push di
    push cx
    push es

    mov ax, 0xFFFF
    mov gs, ax

    xor di, di
    xor eax, eax
    mov cx, 126
    rep stosd

    pop es
    pop cx
    pop di
    pop eax
    iret

; ========================================================
; finds the first available 512 byte page
; in the pagetable
; on success, gs:bp points to the page
; on error the carry flag is set and gs:bp 
; is undefined
; =======================================================
allocPage:
    call private_allocPage
    iret
private_allocPage:
    push ax
    push cx

    mov ax, 0xFFFF
    mov gs, ax

    xor bp, bp
    xor cx, cx
.entryLoop:
    cmp word [gs:bp], 0x00
    je .found
    add bp, 8
    inc cx
    cmp cx, 126
    jne .entryLoop
.notFound:
    stc
    pop cx
    pop ax
    ret
.found:
    shl cx, 9       ; page offset = 1024 + (index * 512)
    add cx, 0x400   ;
    mov word [gs:bp+0], 0x0001  ; status
    mov word [gs:bp+2], 0xFFFF  ; segment
    mov word [gs:bp+4], cx      ; offset
    mov word [gs:bp+6], 0x0200  ; length
    mov bp, cx
    clc
    pop cx
    pop ax
    ret
; ========================================================


; ========================================================
; frees the page with the given address
; alloc gives gs:bp, free only needs bp to free the page
; ========================================================
freePage:
    call private_freePage
    iret
private_freePage:
    push gs
    push ax
    push cx
    push si

    mov ax, 0xFFFF
    mov gs, ax
    xor si, si
    xor cx, cx
.entryLoop:
    cmp word [gs:si+4], bp
    je .found
    add si, 8
    inc cx
    cmp cx, 126
    jne .entryLoop
.notFound:
    stc
    pop si
    pop cx
    pop ax
    pop gs
    ret
.found:
    mov word [gs:si+0], 0x0000
    clc
    pop si
    pop cx
    pop ax
    pop gs
    ret
; ========================================================
