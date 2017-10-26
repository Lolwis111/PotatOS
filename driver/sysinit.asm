; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Initalize the system by reading config       %
; % from the bootloader                          %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start


; ==========================================
%include "defines.asm"
%include "common.asm"
%include "fat12.asm"
%include "sysinit_utils.asm"
%include "screen.asm"
; ==========================================
    
msg         db 0x0D, 0x0A, "Executing SYSINIT.SYS...", 0x0D, 0x0A, 0x00
colorByte   db 0x00
highMem     db 0x00
kb_switch   db 0x00

start:
    mov si, msg
    call Print

    cli
    xor ax, ax
    mov es, ax
    mov ds, ax

    mov word [0x0084], 0x1000   ; set interrupt 0x21 to point to our system.sys
    mov word [0x0086], 0x0000   ; so we have our OS-API ready to use

    sti
    
    mov cx, 0x01    ; load the bootloader (because we sneaked in some config there lmao)
    xor ax, ax
    mov es, ax
    mov ebx, 0x7000
    call ReadSectors
    
    ; get the three config bytes
    mov esi, 0x71FB
    mov al, byte [es:esi+2]
    mov byte [0x1FFE], al   ; set kbSwitch
    
    mov al, byte [es:esi]
    mov byte [0x1FFF], al   ; set color
    mov dl, al
    call screen_setColor
    
    cmp byte [es:esi+1], 0 ; set highMem
    je startTerminal
    
    call enableA20
    
startTerminal:
    ; exit this 'program' and start the terminal
    xor ax, ax
    xor bx, bx
    int 0x21
    
    cli
    hlt
