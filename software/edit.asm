%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "strings.asm"
%include "language.asm"
%include "keys.asm"
%include "functions.asm"
%include "chars.asm"

%define COLOR createColor(WHITE, BLACK)
%define FILE_SEGMENT 0x1000
%include "include/edit_render.asm"
%include "include/edit_gui.asm"

; ===============================================
start:
    push ax
    
    mov ax, VIDEO_TEXT_SEGMENT ; set GS to point to video memory
    mov gs, ax

    mov dh, COLOR
    mov dl, CHAR_SPACE
    call clearScreen
    
    pop ax
    
    cmp ax, -1   ; check for an argument
    je .noArgument      ; no argument

    mov si, ax          ; Wenn ja dann Datei aus dem Argument laden
    mov di, fileName
    call AdjustFileName
    
    LOADFILE fileName, 0, FILE_SEGMENT ; load file
    
    mov word [fileLenght], cx
    cmp ax, -1
    je .error
    
    jmp init
    
.noArgument:
    PRINT FILE_PROMPT, COLOR ; get filename from the user
    
    READLINE input, 11
    
    mov si, input ; make filename uppercase
    call UpperCase
    
    mov si, input ; adjust file name to match fat12
    mov di, fileName
    call AdjustFileName
    cmp ax, -1
    je .error
    
    LOADFILE fileName, 0, FILE_SEGMENT ; try loading the file
    mov word [fileLenght], cx
    cmp ax, -1
    je .error

    jmp init
    
.error:
    PRINT newLine, COLOR
    
    PRINT FILE_NOT_FOUND_ERROR, COLOR ; print an error
    
    mov bx, EXIT_FAILURE
    jmp exit
; ===============================================


; ===============================================
; data
; ===============================================   
linesToSkip dw 0x00
fileLenght  dw 0x00

newLine     db "\r\n", 0x00
input       times 12 db 0
fileName    times 12 db 0
; ===============================================


; ===============================================
; PRINT titlebar and statusbar
; ===============================================
setUpScreen:
    MOVECUR 0, 0
    
    PRINT lblTop, COLOR
    
    MOVECUR 0, 23
    
    PRINT lblBottom, COLOR
    
    ret
; ===============================================

    
; ===============================================
; clear the whole screen
; ===============================================
clearScreen:
    pusha

    xor ebx, ebx
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:ebx], dx
    add ebx, 2
    loop .loop1
    
    MOVECUR 0, 0
    
    popa
    
    ret
; ===============================================


; ===============================================
; clear the text area
; ===============================================
clearTextArea:
    push ebx
    push cx
    push dx

    mov ebx, 320
    mov cx, 1680
    mov dl, CHAR_SPACE
    mov dh, COLOR
.l1:
    mov word [gs:ebx], dx
    add ebx, 2
    loop .l1
    
    pop dx
    pop cx
    pop ebx
    ret
; ===============================================



; ===============================================
; initalize viewer
; ===============================================
init:
    mov word [linesToSkip], 0x00

    call clearScreen
    call setUpScreen
    
    MOVECUR 1, 0
    
    PRINT fileName, COLOR
    
    MOVECUR 2, 0
    
    call renderText
    call renderPosition
    
    jmp main
    
.error:
    PRINT FILE_NOT_FOUND_ERROR
    
    mov bx, EXIT_FAILURE
    jmp exit
; ===============================================


; ===============================================
; mainloop
; ===============================================
main:
    call renderPosition
    call renderText
    
    READCHAR

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
    mov dl, CHAR_SPACE
    call clearScreen
    
    EXIT bx
; ===============================================

fileBuffer db 0x00
