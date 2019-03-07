; ==============================
; prints a string
; es:si <= string address
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


