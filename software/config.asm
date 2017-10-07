%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "strings.asm"
%include "functions.asm"
%include "floppy16.asm"
%include "screen.asm"

%define COLOR createColor(BLACK, MAGENTA)

systemColor db 0x00

colorByte   db 0x00
highMem     db 0x00
kbSwitch    db 0x00

lb_current_config db "\r\n"
%ifdef german
    db "aktuelle Konfiguration: "
%elifdef english
    db "current configuration: "
%endif
newLine db "\r\n", 0x00

configColor	db "COLOR=", 0x00
configHigh  db "HIGH=", 0x00
configKBXY  db "YZ_SWITCH=", 0x00
cmdTrue   db "TRUE ", 0x00
cmdFalse  db "FALSE", 0x00


; ===============================================
; clears the screen
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
    mov ah, 0x0E
    int 0x21
    
    popa
    
    ret
; ===============================================

start:
    mov al, byte [SYSTEM_COLOR]
    mov byte [systemColor], al
    mov byte [SYSTEM_COLOR], COLOR
    
    mov dh, COLOR
    mov dl, 0x20
    call clearScreen

    ; load sector 0 (config is saved in bootloader)
    mov cx, 0x01
    xor ax, ax
    mov es, ax
    mov ebx, buffer
    call ReadSectors
    
    mov esi, buffer+507 ; address color
    mov al, byte [es:esi]
    mov byte [colorByte], al
    mov al, byte [es:esi+1]
    mov byte [highMem], al
    mov al, byte [es:esi+2]
    mov byte [kbSwitch], al

; ================================================
mainLoop:
    mov di, inputBuffer
    mov cx, 64
    xor ax, ax
    rep stosw

    print ready
    
    readline inputBuffer, 64 ; read command from keyboard
    
    mov si, inputBuffer
    call UpperCase
    
    mov si, inputBuffer
    mov di, command
.charLoop:
    mov al, byte [si]
    inc si
    cmp al, 0x20
    je .args
    test al, al ; al==0?
    je .done
    mov byte [di], al
    inc di
    jmp .charLoop
.args:
    mov di, argument
    .charLoop2:
        mov al, byte [si]
        inc si
        test al, al ; al==0?
        je .done
        mov byte [di], al
        inc di
        jmp .charLoop2
.done:
    strcmp command, cmdHELP ; HELP-Command?
    je help

    strcmp command, cmdEXIT ; EXIT-Command?
	je exit
    
    strcmp command, cmdSHOW ; SHOW-Command?
	je showConfig
    
    strcmp command, cmdSET  ; SET-Command?
	je setConfig
    
    strcmp command, cmdSAVE ; SAVE-Command?
    je saveConfigFile
    
    print newLine
    
    jmp mainLoop
    
cmdEXIT db "EXIT", 0x00
cmdSHOW db "SHOW", 0x00
cmdSET db "SET", 0x00
cmdSAVE db "SAVE", 0x00
cmdHELP db "HELP", 0x00
ready db "> ", 0x00
inputBuffer times 64 db 0x00
command times 32 db 0x00
argument times 32 db 0x00
; ================================================


; ================================================
saveConfigFile:
    mov esi, buffer+507
    mov al, byte [colorByte]
    mov byte [es:esi], al
    mov al, byte [highMem]
    mov byte [es:esi+1], al
    mov al, byte [kbSwitch]
    mov byte [es:esi+2], al
    
    mov cx, 0x01
    xor ax, ax
    mov es, ax
    mov ebx, buffer
    call WriteSectors
    
    print newLine
    
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

    print newLine
    
    jmp mainLoop
    
    .invalidColorChange:
        print .invalidColorChangeError
        
        pop si
        jmp mainLoop
    .invalidColorChangeError db "\r\ninvalid color!\r\n", 0x00
    
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
    
    print newLine
    
    jmp mainLoop
    
.setHighMemTrue:
    mov byte [highMem], TRUE
    pop si    
    
    print newLine
    
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
    
    print newLine
    
    jmp mainLoop
    
.setKbTrue:
    mov byte [kbSwitch], TRUE
    pop si  
    
    print newLine
      
    jmp mainLoop
; ================================================


; ===============================================
showConfig:
    print lb_current_config
    
    print configColor
    
    mov ah, 0x15
    mov cl, byte [colorByte]
    mov dx, .hexColor
    int 0x21
    
    print .hexColor
    
    print newLine
    
    print configHigh
    
    cmp byte [highMem], TRUE
    jne .highMemFalse
    
    print cmdTrue
    
    jmp .highMemDone
    
.highMemFalse:
    print cmdFalse
    
.highMemDone:
    
    print newLine
    
    print configKBXY
    
    cmp byte [kbSwitch], TRUE
    jne .kbSwitchFalse
    
    print cmdTrue
    
    jmp .kbSwitchDone
.kbSwitchFalse:
    print cmdFalse
    
.kbSwitchDone:
    print newLine
    
    print newLine
    
    jmp mainLoop
.hexColor db "00", 0x00
; ===============================================


; ===============================================
; prints all the commands
; ===============================================
help:

    print .helpStr
    
    jmp mainLoop
.helpStr db "\r\nCommands\r\n"
         db "HELP - shows this help\r\n"
         db "SHOW - shows current configuration\r\n"
         db "SET  - sets a certain option\r\n"
         db "SAVE - saves the current configuration\r\n"
         db "EXIT - closes this program\r\n"
         db 0x00
; ===============================================

    
; ===============================================
; beendet das Programm
; ===============================================
exit:
    mov al, byte [systemColor]
    mov byte [SYSTEM_COLOR], al

    mov dh, byte [SYSTEM_COLOR]
    mov dl, 0x20
    call clearScreen
    
    EXIT EXIT_SUCCESS
    
    cli
    hlt
; ===============================================

buffer db 0x00
