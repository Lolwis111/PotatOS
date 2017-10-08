;=======================================
;FindFile()
;   looks for a file in the current directory
;   SI <= filename
;
;   AX => index of the file
;   carry flag for error indication
;=======================================
FindFile:
    pusha
    push es
    
    mov di, .fileName ; copy the filename
    mov cx, 11
    rep movsb
    
    mov ax, DIRECTORY_SEGMENT
    mov es, ax
    mov word [.index], 0x00 ; zero out index
    xor si, si
    
    cld
.fileLoop:
    cmp byte [es:si], 0x00 ; if the directory ends we have not found the file
    je .fileNotFound

    push si
    mov cx, 11
    mov di, .fileName
    rep cmpsb
    je .fileFound ; if the name matches we found the file
    pop si
    add si, 32 ; jump to the next entry
    inc word [.index] ; increment index
    jmp .fileLoop
    
.fileNotFound:
    pop es
    popa
    mov ax, -1
    stc
    ret
.fileFound:
    pop si
    pop es
    popa
    mov ax, word [.index]
    clc
    ret
.index dw 0x0000
.fileName times 12 db 0x00
;=======================================