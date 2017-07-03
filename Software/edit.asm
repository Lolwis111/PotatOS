[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%include "strings.asm"
%include "language.asm"
%include "keys.asm"
%include "functions.asm"

%define COLOR createColor(BLACK, WHITE)
%define FILE_OFFSET 0x9500

; ===============================================
start:
    push ax
    mov dh, COLOR
    mov dl, 0x20
    call clearScreen
    pop ax
    
    cmp ax, -1          ; Prüfen ob Argument vorhanden ist
    je .noArgument      ; Nein?

    mov si, ax          ; Wenn ja dann Datei aus dem Argument laden
    mov di, fileName
    call AdjustFileName
    
    loadfile fileName, FILE_OFFSET ; Datei laden
    
    mov word [fileLenght], cx
    cmp ax, -1
    je .error
    
    jmp init
    
.noArgument:
    print msgFile, COLOR ; Dateiname von Eingabe holen
    
    readline input, 11
    
    mov si, input ; In Großbuchstaben wandeln
    call UpperCase
    
    mov si, input ; Dateiname an FAT12 anpassen
    mov di, fileName
    call AdjustFileName
    cmp ax, -1
    je .error
    
    loadfile fileName, FILE_OFFSET ; Datei laden
    mov word [fileLenght], cx
    cmp ax, -1
    je .error

    jmp init
    
.error:
    print newLine, COLOR
    
    print FILE_NOT_FOUND_ERROR, COLOR ; Fehlermeldung anzeigen
    
    mov bx, 1
    jmp exit
; ===============================================


; ===============================================
; Datensektion
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
    msgFile     db 0x0D, 0x0A, "Datei:", 0x00
%elif english
    msgFile     db 0x0D, 0x0A, "File:", 0x00
%endif

newLine     db 0x0D, 0x0A, 0x00
input       times 12 db 0
fileName    times 12 db 0
; ===============================================


; ===============================================
; die Titel bzw. Statusleiste ausgeben
; ===============================================
setUpScreen:
    movecur 0, 0
    
    print lblTop, COLOR
    
    movecur 0, 23
    
    print lblBottom, COLOR
    
    ret
; ===============================================


; ===============================================
; ein einzelnes Zeichen ausgeben (ohne Veränderung
; der Cursorposition)
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
; den kompletten Bildschirm leeren
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
; die Position im Dokument in der Statusleiste
; ausgeben.
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
.positionString db "00000", 00h
; ===============================================


; ===============================================
; Das Textfeld leeren
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
; Den Inhalt der Datei im Textfeld ausgeben
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
    cmp bh, 21
    je .done

    jmp .charLoop
    
.done:
    ret
; ===============================================


; ===============================================
; Den Editor initalisieren
; ===============================================
init:
    mov word [linesToSkip], 00h

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
    
    mov bx, 1
    jmp exit
; ===============================================


; ===============================================
; Hauptschleife des Programms
; ===============================================
main:
    call renderPosition
    call renderText
    
    mov ah, 0x00
    int 0x16

    cmp ah, KEY_UP  ; Pfeil-Hoch
    je .scrollUp
    
    cmp ah, KEY_DOWN
    je .scrollDown  ; Pfeil-Runter
    
    cmp ah, KEY_F5  ; F5 Taste
    je init
    
    cmp ah, KEY_ESCAPE  ; Escape-Taste
    je regularExit
    
    jmp main
    
.scrollDown:

    inc word [linesToSkip]

    jmp main

.scrollUp:

    cmp word [linesToSkip], 00h
    je main
    
    dec word [linesToSkip]

    jmp main
; ===============================================
    
    
; ===============================================
; Programm beenden
; ===============================================
regularExit:
    xor bx, bx
exit:
    ; Programm beenden
    mov dh, byte [SYSTEM_COLOR]
    mov dl, 0x20
    call clearScreen
    
    EXIT bx
; ===============================================
