; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % small calculator                             %
; % can do +, -, *, / and mod                    %
; % capable of base10 to base2, base8 and base16 %
; % numbers can be 32-bit                        %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "language.asm"
%include "functions.asm"

%define STD_COLOR createColor(BRIGHT_BLUE, BLACK)
%define NUM_COLOR createColor(BRIGHT_YELLOW, BLACK)

lblOptions  db "\r\n\n"
%ifdef german
    db "Befehle:" 
%elifdef english
    db "Commands:"
%endif
    db "add, sub, div, mul, toBin, toHex, toOct, help, exit\r\n", 0x00
    
msgInvalidStorage db "\n\r"
%ifdef german
    db "Ungueltige Speicherzelle!"
%elifdef english
    db "invalid storage place!"
%endif
    db "\r\n", 0x00
    
msgResult   db "\r\n"
%ifdef german    
    db "Ergebnis: "
%elifdef english
    db "Result: "
%endif
    db 0x00

newLine      db "\r\n", 0x00
msgReady        db "> ", 0x00

lblA            db "A = ", 0x00
lblB            db "\r\nB = ", 0x00
lblResult       times 20 db 0x00
inputString     times 17 db 0x00

cmdADD          db "ADD", 0x00
cmdSUB          db "SUB", 0x00
cmdDIV          db "DIV", 0x00
cmdMUL          db "MUL", 0x00
cmdTOBIN        db "TOBIN", 0x00
cmdTOHEX        db "TOHEX", 0x00
cmdTOOCT        db "TOOCT", 0x00
cmdEXIT         db "EXIT", 0x00

color db 0x00

numberA         dd 0x00000000
numberB         dd 0x00000000
result          dd 0x00000000

; ==========================================
; ClearScreen
; ==========================================
cls:
    pusha
    push gs
    mov ax, 0xB800
    xor bx, bx
    mov gs, ax
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    pop gs
    popa
    
    MOVECUR 0, 0
    
    ret
; ==========================================
    

; ==========================================
start:
    mov al, byte [SYSTEM_COLOR]
    mov byte [color], al
    mov byte [SYSTEM_COLOR], NUM_COLOR

    mov dh, createColor(WHITE, BLACK)
    mov dl, 0x20
    call cls

    jmp main
; ==========================================
    
    
; ==========================================
main:
    PRINT lblOptions, NUM_COLOR
    
    PRINT msgReady, NUM_COLOR ; >
    
    READLINE command, 7 ; read command from keyboard
    
    mov si, command         ; make command upper case
    call UpperCase
    
    PRINT newLine, NUM_COLOR
    
    STRCMP command, cmdEXIT ; EXIT-Command?
    je exit
    
    STRCMP command, cmdADD ; ADD-Command?
    je add_numbers
    
    STRCMP command, cmdSUB ; SUB-Command?
    je sub_numbers
    
    STRCMP command, cmdDIV ; DIV-Command?
    je div_numbers
    
    STRCMP command, cmdMUL ; MUL-Command?
    je mul_numbers
    
    STRCMP command, cmdTOBIN ; toBin-Command?
    je dec_to_bin

    STRCMP command, cmdTOHEX ; toHex-Command?
    je dec_to_hex

    STRCMP command, cmdTOOCT ; toOct-Command?
    je dec_to_oct
    
    jmp main
; ===============================================


%include "include/calc_input.asm"
%include "include/calc_add.asm"
%include "include/calc_sub.asm"
%include "include/calc_div.asm"
%include "include/calc_mul.asm"
%include "include/calc_converter.asm"


; ===============================================
exit:
    mov dh, byte [color]
    mov dl, 0x20
    mov byte [SYSTEM_COLOR], dh
    call cls

    EXIT 0
; ===============================================


; ===============================================
UpperCase:
    push si
.loop1:
    cmp byte [si], 0x00
    je .return
    
    cmp byte [si], 'a'
    jb .noatoz
    cmp byte [si], 'z'
    ja .noatoz
    
    sub byte [si], 0x20
    inc si
    
    jmp .loop1
.return:
    pop si
    ret
.noatoz:
    inc si
    jmp .loop1
; ===============================================

command db 0x00
