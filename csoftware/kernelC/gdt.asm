%ifndef _GDT_ASM_
%define _GDT_ASM_

gdt_start:
    dd 0x00000000
    dd 0x00000000

gdt_code:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    dw 0xFFFF
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

%define CODE_SEGMENT gdt_code - gdt_start
%define DATA_SEGMENT gdt_data - gdt_start

%endif ; _GDT_ASM_
