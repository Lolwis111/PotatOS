%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "strings.asm"
%include "language.asm"
%include "keys.asm"
%include "functions.asm"

%define COLOR createColor(WHITE, BLACK)
%define FILE_OFFSET fileBuffer

; ===============================================
start:
    push ax
    mov dh, COLOR
    mov dl, 0x20
    call clearScreen
    pop ax
    
    mov bx, ax
    cmp byte [bx], -1   ; check for an argument
    je .noArgument      ; no argument

    mov si, ax          ; Wenn ja dann Datei aus dem Argument laden
    mov di, fileName
    call AdjustFileName
    
    loadfile fileName, FILE_OFFSET ; load file
    
    mov word [fileLenght], cx
    cmp ax, -1
    je .error
    
    jmp init
    
.noArgument:
    print msgFile, COLOR ; get filename from the user
    
    readline input, 11
    
    mov si, input ; make filename uppercase
    call UpperCase
    
    mov si, input ; adjust file name to match fat12
    mov di, fileName
    call AdjustFileName
    cmp ax, -1
    je .error
    
    loadfile fileName, FILE_OFFSET ; try loading the file
    mov word [fileLenght], cx
    cmp ax, -1
    je .error

    jmp init
    
.error:
    print newLine, COLOR
    
    print FILE_NOT_FOUND_ERROR, COLOR ; print an error
    
    mov bx, EXIT_FAILURE
    jmp exit
; ===============================================


; ===============================================
; data
; ===============================================
lblTop      db 177
            times 11 db 20h
            times 148 db 177
            db 0x00

%ifdef german
    lblBottom   times 81 db 177
                db 24, " Hochscrollen", 177, 25, " Runterscrollen", 177, "ESC Beenden", 177, "F5 Neu laden"
                times 22 db 177
                db 0x00
%elif english
    lblBottom   times 81 db 177
                db 24, " scroll up", 177, 25, " scroll down", 177, "ESC quit", 177, "F5 reload"
                times 34 db 177
                db 0x00
%endif
            
linesToSkip dw 0x00
fileLenght  dw 0x00

%ifdef german
    msgFile     db "\r\nDatei:", 0x00
%elif english
    msgFile     db "\r\nFile:", 0x00
%endif

newLine     db "\r\n", 0x00
input       times 12 db 0
fileName    times 12 db 0
; ===============================================


; ===============================================
; print titlebar and statusbar
; ===============================================
setUpScreen:
    movecur 0, 0
    
    print lblTop, COLOR
    
    movecur 0, 23
    
    print lblBottom, COLOR
    
    ret
; ===============================================


; ===============================================
; print a single char without advancing the
; cursor position
; >DL X
; >DH Y
; ===============================================
printChar:

    pusha
    
    push ax
    mov ax, dx
    movzx bx, dl
    movzx ax, dh
    shl bx, 1
    mov cx, 160
    mul cx
    add bx, ax
    pop ax
    mov word [gs:bx], ax
    
    popa
    
    ret
; ===============================================

    
; ===============================================
; clear the whole screen
; ===============================================
clearScreen:
    pusha
    xor bx, bx
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    
    movecur 0, 0
    
    popa
    
    ret
; ===============================================

    
; ===============================================
; print the position in the statusbar
; ===============================================
renderPosition:
    movecur 73, 23
    
    mov ah, 0x03
    mov dx, .positionString
    mov cx, word [linesToSkip]
    int 0x21
    
    print .positionString, COLOR
    
    movecur 0, 2
    
    ret
.positionString db "00000", 0x00
; ===============================================


; ===============================================
; clear the text area
; ===============================================
clearTextArea:
    pusha
    mov bx, 320
    mov cx, 1680
    mov dl, 0x20
    mov dh, COLOR
.l1:
    mov word [gs:bx], dx
    add bx, 2
    loop .l1
    popa

    ret
; ===============================================


; ===============================================
; print content of file
; ===============================================
renderText:    
    call clearTextArea

    xor ax, ax
    mov es, ax
    mov esi, FILE_OFFSET
    cmp word [linesToSkip], 0x00
    je .ok    
    
    xor dx, dx    
    xor cx, cx
.skipLoop:
    mov al, byte [es:esi]
    inc si
    inc cx
    
    cmp al, 0x0A
    je .skipNewLine
    
    cmp cx, 79
    je .skipNewLine
    
    jmp .skipLoop
    
.skipNewLine:
    inc dx
    xor cx, cx
    
    cmp dx, word [linesToSkip]
    je .ok
    
    jmp .skipLoop
    
.ok:
    ; ---------------
    ; |  BH  |  BL  |
    ; ---------------
    ; |  Y   |  X   |
    ; ---------------
    mov bx, 0x0200
.charLoop:
    mov al, byte [es:esi]
    
    inc esi
    
    cmp al, 0x00
    je .done
    cmp al, 0x0A
    je .newLine
    
    cmp al, 0x0D
    je .charLoop

    mov dx, bx
    mov ah, COLOR
    call printChar
    inc bl
    
    cmp bl, 79
    je .newLine
    
    jmp .charLoop

.newLine:
    xor bl, bl
    inc bh
    cmp bh, 23
    je .done

    jmp .charLoop
    
.done:
    ret
; ===============================================


; ===============================================
; initalize viewer
; ===============================================
init:
    mov word [linesToSkip], 0x00

    call clearScreen
    call setUpScreen
    
    movecur 1, 0
    
    print fileName, COLOR
    
    movecur 2, 0
    
    call renderText
    call renderPosition
    
    jmp main
    
.error:
    print FILE_NOT_FOUND_ERROR
    
    mov bx, EXIT_FAILURE
    jmp exit
; ===============================================


; ===============================================
; mainloop
; ===============================================
main:
    call renderPosition
    call renderText
    
    mov ah, 0x00
    int 0x16

    cmp ah, KEY_UP  ; arrow-up
    je .scrollUp
    
    cmp ah, KEY_DOWN
    je .scrollDown  ; arrow-down
    
    cmp ah, KEY_F5  ; F5 key
    je init
    
    cmp ah, KEY_ESCAPE  ; Escape key
    je regularExit
    
    jmp main
    
.scrollDown:

    inc word [linesToSkip]

    jmp main

.scrollUp:

    cmp word [linesToSkip], 0x00
    je main
    
    dec word [linesToSkip]

    jmp main
; ===============================================
    
    
; ===============================================
; exit
; ===============================================
regularExit:
    mov bx, EXIT_SUCCESS
exit:
    ; exit program
    mov dh, byte [SYSTEM_COLOR]
    mov dl, 0x20
    call clearScreen
    
    EXIT bx
; ===============================================

fileBuffer db 0x00
