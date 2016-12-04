%ifndef _GDT_H_
%define _GDT_H_

gdt_start:
.null:
    dd 0
    dd 0
.kernelCode:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0
.kernelData:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0
.userCode:
    dw 0xFFFF
    dw 0
    db 0
    db 11111010b
    db 11001111b
    db 0
.userData:
    dw 0xFFFF
    dw 0
    db 0
    db 11110010b
    db 11001111b
    db 0
gdt_end:
gdt:
    dw gdt_end - gdt_start - 1
    dd gdt_start

%endif
