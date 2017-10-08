; ==================================================
; CountFiles()
;       counts how many files there are
;       in the loaded directory
; ==================================================
CountFiles:
    pusha
    push es
    
    xor si, si
    mov ax, DIRECTORY_SEGMENT
    mov word [.counter], si
    mov es, ax
    
.fileLoop:
    cmp byte [es:si], 0xE5 ; deleted elements do not count
    je .skip
    
    cmp byte [es:si], 0x00 ; last entry => stop counting here
    je .endOfDirectory
    
    inc word [.counter]
    
.skip:
    add si, 32  ; jump to the next entry
    jmp .fileLoop
    
.endOfDirectory:
    pop es
    popa
    
    mov cx, word [.counter]
    
    ret
.counter dw 0x0000
; ==================================================