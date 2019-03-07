%ifndef _KEYBOARD_ASM_
%define _KEYBOARD_ASM_

%include "defines.asm"
%define DATA_PORT    0x60
%define STATUS_PORT  0x64
%define COMMAND_PORT 0x64

%define LEFT_SHIFT_DOWN  0x2A
%define RIGHT_SHIFT_DOWN 0x36
%define LEFT_SHIFT_UP    0xAA
%define RIGHT_SHIFT_UP   0xB6

; ====================================================
; sends the command in BL
; to the keyboard controller
; ====================================================
sendCommand:
    in al, STATUS_PORT
    test al, 0x02
    jz sendCommand
    mov al, dl
    out DATA_PORT, al
    ret
; ====================================================

private_readNextKey:
.waitForData:
    xor ax, ax
    in al, STATUS_PORT
    test al, 0x01
    jz .waitForData

    in al, DATA_PORT
    ret
; ====================================================
; reads the next character from the keyboard
; AL -> ASCII Code
; AH -> Scancode
; ====================================================
readChar:
    call private_readChar
    iret

private_readChar:
    mov byte [.shift], 0x00
.nextKey:
    call private_readNextKey

    cmp al, LEFT_SHIFT_DOWN
    je .shiftDownL
    cmp al, RIGHT_SHIFT_DOWN
    je .shiftDownR

    cmp al, LEFT_SHIFT_UP
    je .shiftUpL
    cmp al, RIGHT_SHIFT_UP
    je .shiftUpR

    mov dh, al
    jmp .convert

.shiftDownL:
    or byte [.shift], 0x01
    jmp .nextKey
.shiftDownR:
    or byte [.shift], 0x02
    jmp .nextKey

.shiftUpL:
    test byte [.shift], 0x01
    jnz .shiftUpLOK
    jmp .nextKey
.shiftUpR:
    test byte [.shift], 0x02
    jnz .shiftUpROK
    jmp .nextKey
.shiftUpLOK:
    mov ah, LEFT_SHIFT_DOWN
    xor al, al
    ret
.shiftUpROK:
    mov ah, RIGHT_SHIFT_DOWN
    xor al, al
    ret
.convert:
    ; catch space right away
    cmp al, 0x39
    je .space
    
    ; check the status of the shift key
    cmp byte [.shift], 0x00
    jne .bigMap

    ; load the ascii map
    mov si, .asciiMap
    jmp .map
.bigMap:
    ; load the ascii map for upper case
    mov si, .asciiMapBig
.map:
    ; map the scancode to the ascii map
    add si, ax
    mov al, byte [si]
    mov ah, dh
    ret
.space:
    mov ah, dh
    mov al, 0x20
    ret
.shift db 0x00
; ====================================================


; ====================================================
; the ascii maps
; asciiMap: lower case characters
; asciiMapBig: upper case characters
; TODO: make it possible to load an ascii map
; ====================================================
.asciiMap:
    db 0x00, 0x00, "1234567890-=", 0x08, 0x09 ; 16
    db "qwertyuiop[]", 0x0A, 0x00, 'as' ; 15
    db "dfghjkl", 0x3B, 0x27, "`", 0x00, "\zxc" ; 15
    db "vbnm,./" ; 7
    times 203 db 0x00

.asciiMapBig:
    db 0x00, 0x00, "!@#$%^&*()_+", 0x08, 0x09
    db "QWERTYUIOP{}", 0x0A, 0x00, "AS"
    db "DFGHJKL:", 0x22, "~", 0x00, 0x7C, "ZXC"
    db "VBNM<>?"
    times 203 db 0x00
; ====================================================
%endif
