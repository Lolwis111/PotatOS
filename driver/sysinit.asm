; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Initalize the system by reading config       %
; % from the bootloader                          %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

; ==========================================
%include "common.asm"
%ifdef A20
    %include "sysinit_a20.asm"
%endif
%include "screen.asm"
%include "print16.asm"
; ==========================================
msg         db 0x0D, 0x0A
            db "Executing SYSINIT.SYS..."
            db 0x0D, 0x0A
            db 0x00
;colorByte   db 0x00
;highMem     db 0x00
;kb_switch   db 0x00

start:
    mov si, msg
    call Print

    cli
    
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov fs, ax
    mov gs, ax

    mov word [0x0084], SYSTEM_SYS ; set interrupt 0x21 to point to our system.sys
    mov word [0x0086], 0x0000     ; so we have our OS-API ready to use

    ; initialise serial port for debbuging
    mov dx, SERIAL_PORT_1+1
    mov al, 0x00
    out dx, al
    
    mov dx, SERIAL_PORT_1+3
    mov al, byte 0x80
    out dx, al
    
    mov dx, SERIAL_PORT_1+0
    mov al, 0x03
    out dx, al

    mov dx, SERIAL_PORT_1+1
    mov al, 0x00
    out dx, al

    mov dx, SERIAL_PORT_1+3
    mov al, 0x03
    out dx, al

    mov dx, SERIAL_PORT_1+2
    mov al, 0xC7
    out dx, al

    mov dx, SERIAL_PORT_1+4
    mov al, 0x0B
    out dx, al

    sti
  
    mov ah, 0x18
    int 0x21

    mov byte [SYSTEM_COLOR], 0x07   ; set color to light grey on black
    mov dl, 0x07
    call screen_setColor

%ifdef A20
    call enableA20
%endif
    
startTerminal:
    ; exit this 'program' and start the terminal
    xor ax, ax
    xor bx, bx
    int 0x21
    
    cli
    hlt
