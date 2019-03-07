%include "keys.asm"

; ======================================================
; reads a string from the keyboard
; DS:DX => dest string
; CX => max chars
; CX <= actual amount of chars read
; ======================================================
readLine:
    mov di, dx
    mov word [.counter], 0x00 ; counts how many chars were read
.kbLoop:
    call private_readChar   ; read the next character
    
    cmp ah, KEY_ENTER       ; confirm input, exit routine
    je .return

    cmp ah, KEY_BACKSPACE   ; delete last character
    je .back

    test al, al             ; AL = 0 => not a printable character, 
    jz .kbLoop              ; we wont need it
    
    inc word [.counter]     ; increment counter
    cmp word [.counter], cx ; if max_chars is reached, do not accept more chars
    jg .kbLoop

.store: ; saves the char in dest string and prints it on the screen
        ; also refreshes all relevant addresses
    stosb               ; save char
    
    pusha

    mov dh, al
    mov dl, byte [SYSTEM_COLOR]
    call private_printChar
    mov dl, byte [col]
    mov dh, byte [row]
    call private_setCursorPosition
    
    popa
    
    jmp .kbLoop         ; read the next char
    
.back:
    cmp word [.counter], 0x00; decrement counter, but only delete the chars that were entered
    jbe .kbLoop
    dec word [.counter]
    
    pusha
    
    dec byte [col]      ; move on char back
    
    mov dh, 0x00
    mov dl, byte [SYSTEM_COLOR] 
    call private_printChar
    
    dec byte [col] ; move cursor back
    mov dh, byte [row]
    mov dl, byte [col]
    call private_setCursorPosition
    
    popa
    
    dec di              ; move on char back
    mov al, 0x00            
    stosb               ; override with zero
    dec di              
    
    jmp .kbLoop
    
.return:
    xor al, al
    stosb               ; strings are \0 terminated
    mov cx, word [.counter]
    iret                ; return
.counter dw 0x00
; ======================================================
