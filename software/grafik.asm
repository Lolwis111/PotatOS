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

; snake_l dw 0x0001

; =================================
init:
    mov ah, 0x00 ; Grafikmodus aktivieren
    mov al, 0x13
    int 0x10

    mov ah, 0x00 ; Uhrzeitlesen
    int 0x1A
    
    movzx eax, dx ; Startwert für getRandom auf Zeit setzen
    ror eax, 16
    mov ax, cx
    rol eax, 16
    mov dword [getRandom.lastX], eax

    mov ax, VIDEO_GRAPHICS_SEGMENT ; Segment auf Grafikspeicher zeigen
    mov gs, ax
    xor bx, bx
    
    mov al, 0xFF        ; Bildschirm auf Schwarz setzen
    call clearScreen
    
    xor ax, ax ; (0|0)
    xor cx, cx 
    mov dx, 199
    mov bx, 319
    call drawLine
    
    xor ax, ax
    int 0x16
    
; =================================


; =================================
mainLoop:
    mov al, 0xFF        ; Bildschirm auf Schwarz setzen
    call clearScreen
    
    ;call getRandom  ; Zufällige X-Position bestimmen
    ;xor eax, edx
    ;xor edx, edx
    ;mov ebx, 320 ; MOD 320 rechnen
    ;div bx
    
    ;push dx
    
    ;call getRandom ; Zufällige Y-Position bestimmen
    ;xor eax, edx
    ;xor edx, edx
    ;mov ebx, 200 ; MOD 200 rechnen
    ;div bx
    ;pop cx
    
    ;mov ax, 5       ; Ein Quadrat malen    
    ;mov bx, 5   
    ;mov bp, 0x0040
    ;call drawRect
    
    ;call waitS      ; Warten
    
    ;jmp mainLoop    ; nächster Durchlauf
    
    pusha
    
    mov ax, 5
    mov bx, 5
    mov cx, word [.x]
    mov dx, word [.y]
    mov bp, 0x0040
    call drawRect
    
    popa
    
    mov ax, word [.vx]
    add word [.x], ax
    mov ax, word [.vy]
    add word [.y], ax
   
    call waitS
    
    mov ah, 0x01
    int 0x16
    jz mainLoop
    
    xor ax, ax
    int 0x16
    
    cmp ah, 0x01
    je exit
    
    cmp ah, 0x4B
    je .left
    cmp ah, 0x4D
    je .right
    cmp ah, 0x50
    je .down
    cmp ah, 0x48
    je .up
    
    jmp mainLoop
    
.left:
   ;sub word [.x], 5
    mov word [.vx], -1
    mov word [.vy], 0
    jmp mainLoop
.right:
   ;add word [.x], 5
    mov word [.vx], 1
    mov word [.vy], 0
    jmp mainLoop
.down:
   ;add word [.y], 5
    mov word [.vx], 0
    mov word [.vy], 1
    jmp mainLoop
.up:
    ;sub word [.y], 5
    mov word [.vx], 0
    mov word [.vy], -1
    jmp mainLoop

.x dw 20
.y dw 30
.vx dw 0
.vy dw 0
    
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
; SUPERDUPERWAIT MEGA GENAU
; =================================
waitS:
    push ecx
    mov ecx, 0x00FFFFFF
    .loop1:
        dec ecx
        jnz .loop1
    pop ecx
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
drawLine:
    mov word [.x0], ax
    mov word [.y0], cx
    mov word [.x1], bx
    mov word [.y1], dx
   
    mov word [.sx], 1
    mov word [.sy], 1
    
    mov ax, word [.x1]
    sub ax, word [.x0]
    jns .abs
    neg ax
    mov word [.sx], -1
.abs:    
    mov word [.dx], ax
    
    mov bx, word [.y1]
    sub bx, word [.y0]
    jns .abs2
    neg bx
    mov word [.sy], -1
.abs2:
    mov word [.dy], bx
    add bx, word [.dx]
    mov word [.err], bx
    
    .loop1:
        mov ax, word [.x0]
        mov dx, word [.y0]
        mov cx, bp
        call .setPixel
        
        cmp ax, word [.x1]
        jne .notEqual
        cmp dx, word [.y1]
        jne .notEqual
        jmp .end
    .notEqual:
        mov ax, word [.err]
        shl ax, 1
        mov word [.e2], ax
        cmp ax, word [.dy]
        jng .notGreater
        mov bx, word [.dy]
        add word [.err], bx
        mov bx, word [.sx]
        add word [.x0], bx
    .notGreater:
        cmp ax, word [.dx]
        jnb .loop1
        mov ax, word [.dx]
        add word [.err], ax
        mov ax, word [.sy]
        add word [.y0], ax
        jmp .loop1
.end:
    ret
.x0 dw 0x0000
.y0 dw 0x0000
.x1 dw 0x0000
.y1 dw 0x0000
.dx dw 0x0000
.dy dw 0x0000
.sx dw 0x0000
.sy dw 0x0000
.err dw 0x0000
.e2 dw 0x0000
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    ; ax X
    ; dx Y
    ; cl color
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    .setPixel:
        push bx
        push dx
        push ax
        shl dx, 3  ; * 8
        mov bx, dx 
        shl dx, 3  ; * 8 => * 64
        add bx, dx ; Y*8 + Y*64
        shl dx, 1  ; * 8 * 8 * 2 => * 128
        add bx, dx ; Y*8 + Y*64 + Y*128
        add bx, ax
        mov byte [gs:bx], cl
        pop ax
        pop dx
        pop bx
        ret
    ;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; =================================


; =================================
; RANDOM
; edx => Zufallszahl
; =================================
getRandom:
    push eax
    push ebx
    xor edx, edx
    mov eax, 24298
    mov ebx, dword [.lastX]
    mul ebx
    mov ebx, 199017
    div ebx
    mov dword [.lastX], edx
    pop ebx
    pop eax
    ret
.lastX dd 125
; =================================

RAM db 0x0000
