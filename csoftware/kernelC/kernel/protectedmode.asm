[ORG 0x9000]

jmp start

%define KERNEL_OFFSET 0x10000
%define KERNEL_SEGMENT 0x1000

kernel db "KERNEL  SYS"

start:
    mov dx, kernel
    mov bx, 0
    mov bp, KERNEL_SEGMENT
    mov ah, 0x05
    int 0x21

    call enableA20

    jmp switchToPM

%include "gdt.asm"
%include "switchToPM.asm"
%include "a20.asm"

[BITS 32]
beginPM:

    call KERNEL_OFFSET
    
    jmp $