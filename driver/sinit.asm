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
%include "sinit_utils.asm"
%include "screen.asm"
; ==========================================


; ==========================================
enableA20: ; enable A20-Gate to use a little more memory
    pusha
    
    call wait_input
    mov al,0xAD
    out 0x64, al
    call wait_input

    mov al, 0xD0
    out 0x64, al
    call wait_output

    in al, 0x60
    push eax
    call wait_input

    mov al, 0xD1
    out 0x64, al
    call wait_input

    pop eax
    or al, 2
    out 0x60, al

    call wait_input
    mov al, 0xAE
    out 0x64, al

    call wait_input
    popa
    
    ret
    
wait_input:
    in al, 0x64
    test al, 2
    jnz wait_input
    ret
        
wait_output:
    in al, 0x64
    test al, 1
    jz wait_output
    ret
; ==========================================

    
msg         db 0x0D, 0x0A, "Executing SINIT.SYS...", 0x0D, 0x0A, 0x00
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

    mov word [0x0084], 0x1000
    mov word [0x0086], 0x0000

    sti
    
    mov cx, 0x01
    xor ax, ax
    mov es, ax
    mov ebx, 0x7C00
    call ReadSectors
    
    mov esi, 0x7DFB
    mov al, byte [es:esi+2]
    mov byte [0x1FFE], al   ; set kbSwitch
    
    mov al, byte [es:esi]
    mov byte [0x1FFF], al   ; set color
    mov dl, al
    call screen_setColor
    
    cmp byte [es:esi+1], 0 ; set highMem
    je 0x2009
    
    call enableA20
    jmp 0x2009 ; jump into cli (main.sys)

    cli
    hlt
