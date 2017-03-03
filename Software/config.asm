[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%include "strings.asm"

%define COLOR createColor(BLACK, MAGENTA)

fileName db "CONFIG  CFG", 0x00

systemColor db 0x00

colorByte   db 0x00
highMem     db 0x00
kbSwitch    db 0x00
cfgLength   dw 0x00
fileLenght  dw 0x00

configColor	db "COLOR=", 0x00
configHigh  db "HIGH=", 0x00
configKBXY  db "YZ_SWITCH=", 0x00
configEND   db "END", 0x00

cmdTrue   db "TRUE ", 0x00
cmdFalse  db "FALSE", 0x00

newLine db 0x0D, 0x0A, 0x00

%ifdef german
    lb_current_config db 0x0D, 0x0A, "aktuelle Konfiguration: ", 0x0D, 0x0A, 0x00
%elifdef english
    lb_current_config db 0x0D, 0x0A, "current configuration: ", 0x0D, 0x0A, 0x00
%endif

; ================================================
; CX < Bool
; DX > String
; ================================================
boolToString:
    cmp cx, TRUE
    je .true
    mov dx, cmdFalse
    ret
.true:
    mov dx, cmdTrue
    ret
; ================================================


; ===============================================
; den kompletten Bildschirm leeren
; ===============================================
clearScreen:
    pusha
    xor bx, bx
    mov cx, 2000
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    
    xor dx, dx
    mov ah, 0Eh
    int 21h
    
    popa
    
    ret
; ===============================================

start:
    mov al, byte [0x1FFF]
    mov byte [systemColor], al
    mov byte [0x1FFF], COLOR
    
    mov dh, COLOR
    mov dl, 0x20
    call clearScreen

    mov dx, fileName
	xor bx, bx
	mov bp, configFile
	mov ah, 0x05
	int 0x21            ; load config file
	mov word [fileLenght], cx
	cmp ax, -1
	je .loadError
    
    mov word [cfgLength], cx
	add word [cfgLength], configFile
    
    mov si, configFile
    
; ================================================
.scanLoop:
	push si
	mov di, configColor
	mov cx, 6
	rep cmpsb
	je .color
	pop si

	push si
	mov di, configHigh
	mov cx, 5
	rep cmpsb
	je .high
	pop si
	
	push si
	mov di, configKBXY
	mov cx, 10
	rep cmpsb
	je .kb_yz
	pop si
	
	inc si
	cmp si, word [cfgLength]
	je .cfg
	jmp .scanLoop
; ================================================

; ================================================
.color:
	mov dx, si
    mov ah, 0Dh
    int 21h
    
	cmp ax, 1
	je .noCfg
	mov byte [colorByte], cl
	
	pop si
	add si, 8
	
	jmp .scanLoop
; ================================================

; ================================================	
.kb_yz:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .kb_ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .kb_nok
	pop si

	pop si
	jmp .scanLoop
; ================================================
    
; ================================================
.kb_ok:
	pop si
	pop si
	mov byte [kbSwitch], TRUE
	add si, 14
	jmp .scanLoop
; ================================================
    
; ================================================
.kb_nok:
	pop si
	pop si
	mov byte [kbSwitch], FALSE
	add si, 15
	jmp .scanLoop
; ================================================
    
; ================================================
.high:
	push si
	mov di, cmdTrue
	mov cx, 4
	rep cmpsb
	je .ok
	pop si
	
	push si
	mov di, cmdFalse
	mov cx, 5
	rep cmpsb
	je .nok
	pop si

	pop si
	jmp .noCfg
; ================================================
    
; ================================================
.ok:
	pop si
	pop si
	mov byte [highMem], TRUE
	add si, 9
	jmp .scanLoop
; ================================================

; ================================================
.nok:
	pop si
	pop si
	mov byte [highMem], FALSE
	add si, 10
	jmp .scanLoop
; ================================================
	
; ================================================
.noCfg:
	pop si
	
	mov si, .msgLoadError
	mov ah, 0x01
    mov bl, byte [0x1FFF]
    int 0x21
	
	mov byte [colorByte], 0x07
	mov byte [highMem], 0x00
	mov byte [kbSwitch], 0x00
; ================================================
	
; ================================================
.cfg:
    jmp mainLoop
; ================================================

; ================================================
%ifdef german
.msgLoadError db 0x0D, 0x0A, "Die Konfigurationsdatei konnte nicht gelesen werden!"
              db 0x0D, 0x0A, "Setze Standartwerte!", 0x0D, 0x0A, 0x00
%elif english
.msgLoadError db 0x0D, 0x0A, "Unable to read config file!"
              db 0x0D, 0x0A, "Using defaults!", 0x0D, 0x0A, 0x00
%endif
.loadError:
    mov bl, createColor(BLACK, RED)
    mov ah, 0x01
    mov dx, .msgLoadError
    int 0x21

    mov bx, -1
; ================================================


; ================================================
mainLoop:
    mov di, inputBuffer
    mov cx, 64
    xor ax, ax
    rep stosw

    mov ah, 0x01
    mov dx, ready
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x04				; read command from keyboard
	mov dx, inputBuffer
	mov cx, 64
	int 0x21
    
    mov si, inputBuffer
    call UpperCase
    
    mov si, inputBuffer
    mov di, command
.charLoop:
    mov al, byte [si]
    inc si
    cmp al, 0x20
    je .args
    cmp al, 0x00
    je .done
    mov byte [di], al
    inc di
    jmp .charLoop
.args:
    mov di, argument
    .charLoop2:
        mov al, byte [si]
        inc si
        cmp al, 0x00
        je .done
        mov byte [di], al
        inc di
        jmp .charLoop2
.done:
    mov di, command			; EXIT-Command?
	mov si, cmdEXIT
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je exit
    
    mov di, command			; SHOW-Command?
	mov si, cmdSHOW
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je showConfig
    
    mov di, command			; SET-Command?
	mov si, cmdSET
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je setConfig
    
    mov di, command			; SAVE-Command?
	mov si, cmdSAVE
	mov ah, 0x02
	int 0x21
	cmp al, 0x00
	je saveConfigFile
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
    
    jmp mainLoop
    
cmdEXIT db "EXIT", 0x00
cmdSHOW db "SHOW", 0x00
cmdSET db "SET", 0x00
cmdSAVE db "SAVE", 0x00
ready db "> ", 0x00
inputBuffer times 64 db 0x00
command times 32 db 0x00
argument times 32 db 0x00
; ================================================


; ================================================
saveConfigFile:
    mov di, configFile
    xor ax, ax
    mov cx, 256
    rep stosw
    
    mov di, configFile
    mov si, configColor
    movsw
    movsw
    movsw
    
    push di
    
    mov ah, 0x15
    mov cl, byte [colorByte]
    mov dx, .hexColor
    int 0x21
    
    pop di
    
    mov si, .hexColor
    movsw
    mov si, newLine
    movsw
    
    mov si, configHigh
    movsw
    movsw
    movsb
    
    push di
    movzx cx, byte [highMem]
    call boolToString
    pop di
    mov si, dx
    movsw
    movsw
    movsb
    
    mov si, newLine
    movsw
    
    mov si, configKBXY
    movsw
    movsw
    movsb
    
    
    push di
    
    movzx cx, byte [kbSwitch]
    call boolToString
    pop di
    mov si, dx
    movsw
    movsw
    movsb
    
    mov si, newLine
    movsw
    
    mov si, configEND
    movsw
    movsb
    
    mov ah, 0x0A
    mov dx, fileName
    int 0x21
    
    mov dx, fileName
    mov cx, 44
    xor bx, bx
    mov bp, configFile
    mov ah, 0x14
    int 0x21
    
    jmp mainLoop
.hexColor db "00", 0x00
; ================================================


; ================================================
setConfig:
    mov si, argument
    .spaceSkipper:
        mov al, byte [si]
        inc si
        cmp al, 0x20
        je .spaceSkipper
    dec si
    
    push si
	mov di, configColor
	mov cx, 5
	rep cmpsb
	je .changeColor
	pop si

	push si
	mov di, configHigh
	mov cx, 4
	rep cmpsb
	je .changeHighMem
	pop si
	
	push si
	mov di, configKBXY
	mov cx, 9
	rep cmpsb
	je .changeKbSwitch
	pop si
    
    jmp mainLoop
.changeColor:
    .spaceSkipper1:
        mov al, byte [si]
        inc si
        cmp al, 0x20
        je .spaceSkipper1
    dec si
    
    mov dx, si
    mov ah, 0x0D
    int 0x21
    
    cmp ax, -1
    je .invalidColorChange
    
    mov byte [colorByte], cl
    
    pop si
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
    
    jmp mainLoop
    
    .invalidColorChange:
        mov dx, .invalidColorChangeError
        mov ah, 0x01
        mov bl, COLOR
        int 0x21
        
        pop si
        jmp mainLoop
    .invalidColorChangeError db 0x0D, 0x0A, "invalid color!", 0x0D, 0x0A, 0x00
    
.changeHighMem:
    .spaceSkipper2:
        mov al, byte [si]
        inc si
        cmp al, 0x20
        je .spaceSkipper2
    dec si
    
    mov di, cmdTrue
    mov cx, 4
    rep cmpsb
    je .setHighMemTrue
    mov byte [highMem], FALSE
    pop si
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
    
    jmp mainLoop
    
.setHighMemTrue:
    mov byte [highMem], TRUE
    pop si    
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
    
    jmp mainLoop
    
.changeKbSwitch:
    .spaceSkipper3:
        mov al, byte [si]
        inc si
        cmp al, 0x20
        je .spaceSkipper3
    dec si
    
    mov di, cmdTrue
    mov cx, 4
    rep cmpsb
    je .setKbTrue
    mov byte [kbSwitch], FALSE
    pop si
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
    
    jmp mainLoop
    
.setKbTrue:
    mov byte [kbSwitch], TRUE
    pop si  
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, newLine
    int 0x21
      
    jmp mainLoop
; ================================================


; ===============================================
showConfig:
    mov ah, 0x01
    mov dx, lb_current_config
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x01
    mov dx, configColor
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x15
    mov cl, byte [colorByte]
    mov dx, .hexColor
    int 0x21
    
    mov ah, 0x01
    mov bl, COLOR
    mov dx, .hexColor
    int 0x21
    
    mov ah, 0x01
    mov dx, newLine
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x01
    mov dx, configHigh
    mov bl, COLOR
    int 0x21
    
    cmp byte [highMem], TRUE
    jne .highMemFalse
    
    mov ah, 0x01
    mov dx, cmdTrue
    mov bl, COLOR
    int 0x21
    
    jmp .highMemDone
.highMemFalse:
    mov ah, 0x01
    mov dx, cmdFalse
    mov bl, COLOR
    int 0x21
.highMemDone:
    
    mov ah, 0x01
    mov dx, newLine
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x01
    mov dx, configKBXY
    mov bl, COLOR
    int 0x21
    
    cmp byte [kbSwitch], TRUE
    jne .kbSwitchFalse
    
    mov ah, 0x01
    mov dx, cmdTrue
    mov bl, COLOR
    int 0x21
    
    jmp .kbSwitchDone
.kbSwitchFalse:
    mov ah, 0x01
    mov dx, cmdFalse
    mov bl, COLOR
    int 0x21
.kbSwitchDone:
    mov ah, 0x01
    mov dx, newLine
    mov bl, COLOR
    int 0x21
    
    mov ah, 0x01
    mov dx, newLine
    mov bl, COLOR
    int 0x21
    
    jmp mainLoop
.hexColor db "00", 0x00
; ===============================================

    
; ===============================================
; beendet das Programm
; ===============================================
exit:
    mov al, byte [systemColor]
    mov byte [0x1FFF], al

    mov dh, byte [0x1FFF]
    mov dl, 0x20
    call clearScreen
    
    xor bx, bx
    xor ax, ax
    int 0x21
    
    cli
    hlt
; ===============================================

configFile db 0x00
