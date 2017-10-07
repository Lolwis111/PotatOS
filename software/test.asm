%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"

fileName db "TEST1   DIR", 0x00
newLine db "\r\n", 0x00

start:
    
    loadfile fileName, directory
    cmp ax, -1
    je .error
    
    mov si, directory
.fileLoop:
    cmp byte [si], 0x00
    je .directoryDone
    
    mov di, fileName
    mov cx, 11
    rep movsb
    
    push si
    print newLine
    print fileName
    pop si
    
    add si, 21
    jmp .fileLoop
.directoryDone:
    print newLine

    EXIT EXIT_SUCCESS
.error:
    EXIT EXIT_FAILURE
    
directory db 0x00