[ORG 0x9000]

jmp start

%define KERNEL_OFFSET 0x10000
%define KERNEL_SEGMENT 0x1000
%include "../../include/functions.asm"

kernel db "KERNEL  SYS"

start:
    LOADFILE kernel, 0, KERNEL_SEGMENT

    call switchToPM

    jmp $

%include "gdt.asm"
%include "switchToPM.asm"
%include "a20.asm"
%include "print32.asm"

[BITS 32]
beginPM:
    call enableA20

    mov ebx, msgProtected
    call print32
    call KERNEL_OFFSET
    
    jmp $

msgProtected db "We are now in 32 Bit protected mode."
