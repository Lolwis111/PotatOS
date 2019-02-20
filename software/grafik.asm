; Testprogramm für Grafikanwendungen
; Benutzt Modus 0x13 (320x200 Pixel, 256 Farben)

%include "defines.asm"
%include "functions.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

; Breite und Höhe
%define SCREEN_WIDTH 320
%define SCREEN_HEIGHT 200

jmp init

; =================================
init:
    mov ah, 0x00 ; Grafikmodus aktivieren
    mov al, 0x13
    int 0x10
    
    mov ax, VIDEO_GRAPHICS_SEGMENT ; Segment auf Grafikspeicher zeigen
    mov gs, ax

; =================================
mainLoop:
    mov al, 0xFF        ; Bildschirm auf Schwarz setzen
    call clearScreen
    
    mov ecx, 10
    .rectLoop:
        push ecx

        ; get random number
        RANDOM
        mov eax, ecx
        xor edx, edx
        mov bx, 320 ; divide by 320
        div bx
    
        push dx ; dx contains rest
    
        ; get another random number
        RANDOM
        mov eax, ecx
        xor edx, edx
        mov bx, 200 ; divide by 200
        div bx

        mov dx, ax   ; save rest

        pop cx       ; get first numver back
    
        ; draw a square at random position
        mov ax, 5
        mov bx, 5   
        mov bp, 0x0040
        call drawRect
   
        pop ecx
        loop .rectLoop
    
    SLEEP 20

    jmp mainLoop
; =================================


; =================================
exit:
    mov ah, 0x00
    mov al, 0x03
    int 0x10

    
    EXIT EXIT_SUCCESS
    
    cli
    hlt
; =================================
    

; =================================
; Überschreibt das komplette Bild
; mit der Farbe in al
; =================================
clearScreen:
    pusha
    mov ecx, (SCREEN_WIDTH*SCREEN_HEIGHT)
    xor bx, bx
    .cLoop:
        mov byte [gs:bx], al
        inc bx
        dec ecx
        jnz .cLoop
    popa
    ret
; =================================

; =================================
; AX <= Breite
; BX <= Höhe
; CX <= X
; DX <= Y
; BP <= Farbe
; =================================
drawRect:   
    pusha
    mov word [.w], ax
    mov word [.h], bx
    mov word [.x], cx
    mov word [.y], dx
    mov ax, word [.y]
    xor dx, dx
    mov bx, SCREEN_WIDTH
    mul bx
    add ax, word [.x]
    mov bx, ax
    
    mov ax, bp
    
    mov dx, word [.h]
.loopY:
    mov cx, word [.w]
    .loopX:
        mov byte [gs:bx], al
        inc bx
        dec cx
        jnz .loopX
    sub bx, word [.w]
    add bx, SCREEN_WIDTH
    
    dec dx
    jnz .loopY
    
    popa
    ret
.x dw 0x0000
.y dw 0x0000
.w dw 0x0000
.h dw 0x0000
; =================================


; =================================
; ax x0
; bx x1
; cx y0
; dx y1
; bp color
; =================================
;drawLine:
;    mov word [.x0], ax
;    mov word [.y0], cx
;    mov word [.x1], bx
;    mov word [.y1], dx
;   
;    mov word [.sx], 1
;    mov word [.sy], 1
;    
;    mov ax, word [.x1]
;    sub ax, word [.x0]
;    jns .abs
;    neg ax
;    mov word [.sx], -1
;.abs:    
;    mov word [.dx], ax
;    
;    mov bx, word [.y1]
;    sub bx, word [.y0]
;    jns .abs2
;    neg bx
;    mov word [.sy], -1
;.abs2:
;    mov word [.dy], bx
;    add bx, word [.dx]
;    mov word [.err], bx
;    
;    .loop1:
;        mov ax, word [.x0]
;        mov dx, word [.y0]
;        mov cx, bp
;        call .setPixel
;        
;        cmp ax, word [.x1]
;        jne .notEqual
;        cmp dx, word [.y1]
;        jne .notEqual
;        jmp .end
 ;   .notEqual:
 ;       mov ax, word [.err]
;        shl ax, 1
 ;       mov word [.e2], ax
;        cmp ax, word [.dy]
;        jng .notGreater
;        mov bx, word [.dy]
;        add word [.err], bx
;        mov bx, word [.sx]
;        add word [.x0], bx
;    .notGreater:
;        cmp ax, word [.dx]
;        jnb .loop1
;        mov ax, word [.dx]
;        add word [.err], ax
;        mov ax, word [.sy]
;        add word [.y0], ax
;        jmp .loop1
;.end:
;    ret
;.x0 dw 0x0000
;.y0 dw 0x0000
;.x1 dw 0x0000
;.y1 dw 0x0000
;.dx dw 0x0000
;.dy dw 0x0000
;.sx dw 0x0000
;.sy dw 0x0000
;.err dw 0x0000
;.e2 dw 0x0000
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; ax X
    ; dx Y
    ; cl color
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;    .setPixel:
;        push bx
;        push dx
;        push ax
;        shl dx, 3  ; * 8
;        mov bx, dx 
;        shl dx, 3  ; * 8 => * 64
;        add bx, dx ; Y*8 + Y*64
;        shl dx, 1  ; * 8 * 8 * 2 => * 128
;        add bx, dx ; Y*8 + Y*64 + Y*128
;        add bx, ax
;        mov byte [gs:bx], cl
;        pop ax
;        pop dx
;        pop bx
;        ret
;    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
;; =================================

;RAM db 0x0000
