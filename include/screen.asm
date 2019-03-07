; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt Methoden zum Lesen auf Schreiben auf  %
; % Disketten zur verfügung (LOW_LEVEL_IO)       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _SCREEN_INC_
%define _SCREEN_INC_

[BITS 16]

%include "defines.asm"

;==========================================
; overrides the color attribute with value
; of dl
;==========================================
screen_setColor:
    push ax
    push bx
    push cx
    push gs
    cli
    mov ax, VIDEO_MEMORY_SEGMENT
    mov gs, ax
    sti
    mov bx, 0x01
    mov cx, 2000
.clearLoop:
    mov byte [gs:bx], dl
    add bx, 0x02
    loop .clearLoop
    pop gs
    pop cx
    pop bx
    pop ax
    ret
;==========================================

%endif ; _SCREEN16_INC_
