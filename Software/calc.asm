; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % small calculator                             %
; % can do +, -, *, / and mod                    %
; % capable of base10 to base2, base8 and base16 %
; % numbers can be 32-bit                        %
; % (this has bugs for some reason)              %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x9000]
[BITS 16]

jmp start

%include "defines.asm"
%include "language.asm"
%include "functions.asm"

%define STD_COLOR createColor(BLACK, BRIGHT_BLUE)
%define NUM_COLOR createColor(BLACK, BRIGHT_YELLOW)

lblOptions  db 0x0D, 0x0A
%ifdef german
    db 0x0D, 0x0A, "Befehle: add, sub, div, mul, toBin, toHex, toOct, help, exit"
%elifdef english
    db 0x0D, 0x0A, "Commands: add, sub, div, mul, toBin, toHex, toOct, help, exit"
%endif
    db 0x0D, 0x0A, 0x00
    
msgResult   db 0x0D, 0x0A
%ifdef german    
    db "Ergebnis: "
%elifdef english
    db "Result: "
%endif
    db 0x00

msgNewLine      db 0x0D, 0x0A, 0x00
msgReady        db "> ", 0x00
msgOverflow     db 0x0D, 0x0A, "Overflow", 0x0D, 0x0A, 0x00

lblA            db "A = ", 0x00
lblB            db 0x0D, 0x0A, "B = ", 0x00
lblResult       db "0000000000", 0x00, 0x00, 0x00
inputString     db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

cmdANS          db "ANS", 0x00
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
    xor bx, bx
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    popa
    
    movecur 0, 0
    
    ret
; ==========================================
    

; ==========================================
start:
    mov al, byte [SYSTEM_COLOR]
    mov byte [color], al
    mov byte [SYSTEM_COLOR], NUM_COLOR

    mov dh, createColor(BLACK, WHITE)
    mov dl, 0x20
    call cls

    jmp main
; ==========================================
    
    
; ==========================================
main:
    print lblOptions, NUM_COLOR
    
    print msgReady, NUM_COLOR ; >
    
    readline command, 5 ; read command from keyboard
    
    mov si, command         ; make command upper case
    call UpperCase
    
    print msgNewLine, NUM_COLOR
    
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
    
    jmp main
; ===============================================


; ==============================================
readA:
    print lblA, NUM_COLOR

    readline inputString, 9

    mov si, inputString
    call UpperCase
    strcmp inputString, cmdANS
    je .ans

    strtol inputString    
    cmp eax, -1
    je .ret
    ret
.ans:
    mov ecx, dword [result]
    xor eax, eax
    ret
.ret:
    xor ecx, ecx
    mov eax, -1
    ret
; ==============================================


; ===============================================
readNumbers:
    call readA
    cmp eax, -1
    je .ret
    
    mov dword [numberA], ecx
    
    print lblB, NUM_COLOR
    
    readline inputString, 9

    mov si, inputString
    call UpperCase
    strcmp inputString, cmdANS
    je .ans

    strtol inputString
    cmp eax, -1 
    je .ret
.ok:
    mov dword [numberB], ecx
    ret
.ans:
    mov ecx, dword [result]
    jmp .ok
.ret:
    xor ecx, ecx
    mov eax, -1
    ret
; ===============================================


; ===============================================
add_numbers:
    call readNumbers
    cmp eax, -1
    je main
    
    ltostr .str, dword [numberA]
    
    print msgNewLine
    print .str
    print msgNewLine
    
    ltostr .str, dword [numberB]
    
    print msgNewLine
    print .str
    print msgNewLine
    
    jmp main
.str db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    
    mov eax, dword [numberA]
    add eax, dword [numberB]
    push eax
    jnc .noOverflow
    
    print msgOverflow, createColor(RED, BLACK)

.noOverflow:
    pop ecx ; convert result to string
    mov dword [result], ecx
    mov ah, 0xAA
    mov dx, lblResult 
    int 0x21
    
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

    print msgOverflow, createColor(RED, BLACK)

.noOverflow:  
    pop ecx
    mov dword [result], ecx
    mov ah, 0xAA       ; convert result to string
    mov dx, lblResult 
    int 0x21

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
    mov ecx, eax
    mov ah, 0xAA ; convert result to string
    mov dx, lblResult 
    int 0x21
    
    print msgResult, NUM_COLOR
    
    print lblResult, STD_COLOR ; print result
    
    print msgNewLine, NUM_COLOR
    
    pop ecx
    mov ah, 0xAA ; this is basically modulo, convert that to string too
    mov dx, lblResult 
    int 0x21
    
    print .lblRest, NUM_COLOR

    print lblResult, STD_COLOR ; print modulo
    
    jmp main
.div0:
    print DIV_NULL_ERROR, createColor(BLACK, RED)
    jmp main
.lblRest        db "Rest    : ", 00h
; ===============================================

    
; ===============================================
mul_numbers:
    call readNumbers
    
    mov eax, dword [numberA]
    imul dword [numberB]

    mov dword [result], eax

    mov ecx, eax
    mov ah, 0xAA                
    mov dx, lblResult 
    int 0x21
    
    print msgResult, NUM_COLOR    
    print lblResult, STD_COLOR

    jmp main
; ===============================================   


; ===============================================
dec_to_bin:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 32
    mov edi, .bitString+33
.bitLoop:
    push cx
    xor edx, edx
    mov ebx, 2
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec di

    pop eax
    pop cx
    loop .bitLoop

    print .bitString, NUM_COLOR

    jmp main
.bitString db 0x0D, 0x0A, "00000000000000000000000000000000", 0x00
; ===============================================


; ===============================================
dec_to_hex:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 8
    mov di, .hexString+9
.charLoop:
    push cx
    
    xor edx, edx
    mov ebx, 16
    div ebx
    push eax

    mov si, .hexChars
    add si, dx
    mov al, byte [si]
    mov byte [di], al
    dec di

    pop eax
    
    pop cx
    loop .charLoop

    print .hexString, NUM_COLOR

    jmp main
.hexString db 0x0D, 0x0A, "00000000", 0x00
.hexChars db "0123456789ABCDEF"
; ===============================================


; ===============================================
dec_to_oct:
    call readA
    cmp ax, -1
    je main

    mov eax, ecx
    mov cx, 12
    mov di, .octString+13
.charLoop:
    push cx
    xor edx, edx
    mov ebx, 8
    div ebx
    push eax

    add dx, 48
    mov byte [di], dl
    dec di

    pop eax
    pop cx
    loop .charLoop

    print .octString, NUM_COLOR

    jmp main
.octString db 0x0D, 0x0A, "000000000000", 0x00
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
