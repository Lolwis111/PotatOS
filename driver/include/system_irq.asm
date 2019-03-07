%ifndef _SYSTEM_IRQ_ASM_
%define _SYSTEM_IRQ_ASM_

; ================================================
; installs the specified handler 
; for a specified IRQ number
; BP:BX <= function handler
; CX <= IRQ Number
; ================================================
install_irq:
    
    cli ; disable interrupts

    mov ax, bx  ; save address
    mov bx, cx  ; save number
    lea bx, [.irqTableOffset+bx*2] ; load offset from lookup table
    mov word [bx], ax   ; save the offset
    mov bx, cx
    lea bx, [.irqTableSegment+bx*2] ; load segment from lookup table
    mov word [bx], bp   ; save the segment
    
    sti ; reenable interrupts

    iret

.irqTableOffset dw
    0x0020, 0x0024, 0x0028, 0x002C, ; MASTER PIC 
    0x0030, 0x0034, 0x0038, 0x003C,
    0x01C0, 0x01C4, 0x01C8, 0x01CC, ; SLAVE PIC
    0x01D0, 0x01D4, 0x01D8, 0x01DC
.irqTableSegment dw
    0x0022, 0x0026, 0x002A, 0x002E, ; MASTER PIC
    0x0032, 0x0036, 0x003A, 0x003E,
    0x01C2, 0x01C6, 0x01CA, 0x01CE, ; SLAVE PIC
    0x01D2, 0x01D6, 0x01DA, 0x01DE
; ================================================

%endif ; _SYSTEM_IRQ_ASM_
