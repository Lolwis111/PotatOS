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
msgOverflow     db "\r\nOverflow\r\n", 0x00

lblA            db "A = ", 0x00
lblB            db "\r\nB = ", 0x00
lblResult       db "0000000000", 0x00, 0x00, 0x00
inputString     times 16 db 0x00

cmdANS          db "ANS", 0x00
cmdMEM          db "MEM "
cmdADD          db "ADD", 0x00
cmdSUB          db "SUB", 0x00
cmdDIV          db "DIV", 0x00
cmdMUL          db "MUL", 0x00
cmdTOBIN        db "TOBIN", 0x00
cmdTOHEX        db "TOHEX", 0x00
cmdTOOCT        db "TOOCT", 0x00
cmdSTORE        db "STORE  "
cmdVIEW         db "VIEW", 0x00

cmdEXIT         db "EXIT", 0x00

color db 0x00

numberA         dd 0x00000000
numberB         dd 0x00000000
result          dd 0x00000000

resultMemory dd 0x00000000
             dd 0x00000000
             dd 0x00000000
             dd 0x00000000
             dd 0x00000000
             dd 0x00000000

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
    
    movecur 0, 0
    
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
    print lblOptions, NUM_COLOR
    
    print msgReady, NUM_COLOR ; >
    
    readline command, 7 ; read command from keyboard
    
    mov si, command         ; make command upper case
    call UpperCase
    
    print newLine, NUM_COLOR
    
    strcmp command, cmdEXIT ; EXIT-Command?
    je exit
    
    strcmp command, cmdADD ; ADD-Command?
    je add_numbers
    
    strcmp command, cmdSUB ; SUB-Command?
    je sub_numbers
    
    strcmp command, cmdDIV ; DIV-Command?
    je div_numbers
    
    strcmp command, cmdMUL ; MUL-Command?
    je mul_numbers
    
    strcmp command, cmdTOBIN ; toBin-Command?
    je dec_to_bin

    strcmp command, cmdTOHEX ; toHex-Command?
    je dec_to_hex

    strcmp command, cmdTOOCT ; toOct-Command?
    je dec_to_oct
    
    strcmp command, cmdSTORE
    je store
    
    strcmp command, cmdVIEW
    je viewMemory
    
    jmp main
; ===============================================


%include "include/calc_input.asm"


; ===============================================
add_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov eax, dword [numberA]
    add eax, dword [numberB]
    push eax
    jnc .noOverflow
    
    print msgOverflow, createColor(BLACK, RED)

.noOverflow:
    pop ecx ; convert result to string
    mov dword [result], ecx
    ltostr lblResult, ecx
    
    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result
    
    jmp main
; ===============================================
    
    
; ===============================================
sub_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    mov ecx, dword [numberA]
    sub ecx, dword [numberB]
    push ecx
    jno .noOverflow

    print msgOverflow, createColor(BLACK, RED)

.noOverflow:  
    pop ecx
    mov dword [result], ecx
    ltostr lblResult, ecx ; convert result to string

    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result

    jmp main
; ===============================================
    
    
; ===============================================
div_numbers:
    call readNumbers
    cmp ax, -1
    je main
    
    cmp dword [numberB], 0x00
    je .div0
    
    xor edx, edx
    mov eax, dword [numberA]
    mov ecx, dword [numberB]
    idiv ecx ; divide
    
    ; AX => Ergebnis
    ; DX => Rest
    
    push edx
    
    mov dword [result], eax
    ltostr lblResult, eax ; convert result to string
    
    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result
    
    print newLine, NUM_COLOR
    
    pop ecx
    ltostr lblResult, ecx ; this is basically modulo, convert that to string too
    
    print .lblRest, NUM_COLOR

    print lblResult, STD_COLOR ; print modulo
    
    jmp main
.div0:
    print DIV_NULL_ERROR, createColor(RED, BLACK)
    jmp main
.lblRest        db "Rest    : ", 0x00
; ===============================================

    
; ===============================================
mul_numbers:
    call readNumbers
    
    mov eax, dword [numberA]
    imul dword [numberB]

    mov dword [result], eax

    ltostr lblResult, eax
    
    print msgResult, NUM_COLOR    
    print lblResult, STD_COLOR

    jmp main
; ===============================================   


%include "include/calc_converter.asm"


; ===============================================
store:
    xor ebx, ebx
    mov bl, byte [command+6] ; command: STORE [A-F]
    
    cmp ebx, 'A'
    jb .invalid
    cmp ebx, 'F'
    ja .invalid
    
    sub ebx, 'A'
    
    mov eax, dword [result]
    mov dword [resultMemory+ebx*4], eax ; the letters A-F get mapped to the memory addresses
.invalid:

    print msgInvalidStorage

    jmp main
; ===============================================


; ===============================================
viewMemory:
    
    ltostr lblResult, dword [resultMemory]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    ltostr lblResult, dword [resultMemory+4]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    ltostr lblResult, dword [resultMemory+8]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    ltostr lblResult, dword [resultMemory+12]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    ltostr lblResult, dword [resultMemory+16]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    ltostr lblResult, dword [resultMemory+20]
    print lblResult, STD_COLOR
    print newLine, NUM_COLOR
    
    jmp main
; ===============================================


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
