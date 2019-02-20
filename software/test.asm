%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"
%include "strings.asm"
%include "fat12/file.asm"

fname1 db "README2 TXT", 0x00
fname2 db "ABCDEFGHIJK", 0x00
ERR db "\n\rERR\n\r", 0x00
OK db "\n\rOK\n\r", 0x00

start:
    mov bl, 0xFF
    call fat12_parseAttributes
    PRINT si
    PRINT NEWLINE

    ;mov dx, fname1
    ;mov ah, 0x13
    ;int 0x21
    ;cmp ax, -1
    ;je .notFound1
;.found1:
    ;print OK
    ;jmp .test2
;.notFound1:
    ;print ERR
;.test2:
    ;print NEWLINE
    ;mov dx, fname2
    ;mov ah, 0x13
    ;int 0x21
    ;cmp ax, -1
    ;je .notFound2
;.found2:
    ;print OK
    ;jmp .exit
;.notFound2:
    ;print ERR
.exit:
    PRINT NEWLINE
    EXIT EXIT_SUCCESS
.buf times 64 db 0x00
