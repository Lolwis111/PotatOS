%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"
;%include "strings.asm"
;%include "fat12/file.asm"

;path db "/this/is/a/test/path.exe", 0x00
;path2 db "/thispathiswaytoolong/file.dat", 0x00
;pathTooLongException db "Folder/filenames can only be 11 characters long!", 0x00

start:
    mov ah, 0xF0
    int 0x21

    mov cx, 126
.loop1:
    ALLOC
    loop .loop1

    EXIT 0

    ;PRINT NEWLINE
    ;xor ax, ax
    ;mov es, ax
    ;mov ds, ax
;
;    mov si, path2
;    mov di, buffer
;    xor cx, cx
;.parseLoop:
 ;   lodsb
 ;   test al, al
 ;;   jz .end
 ;   cmp al, '/'
 ;   je .splitterFound
 ;   stosb
 ;   inc cx
  ;  cmp cx, 11
  ;;  je .pathTooLong
  ;  jmp .parseLoop
;;.splitterFound:
;    push si
;    LOADDIRECTORY buffer
;    mov di, buffer
;    mov cx, 11
;    mov al, 0x20
;    rep stosb
;    mov di, buffer
;    pop si
;    xor cx, cx
;    jmp .parseLoop
;.end:
;    PRINT NEWLINE
;    PRINT buffer
;    PRINT NEWLINE
;    EXIT 0
;.pathTooLong:
;    PRINT pathTooLongException
;    EXIT 1

;buffer times 11 db 0x20
;                db 0x00
