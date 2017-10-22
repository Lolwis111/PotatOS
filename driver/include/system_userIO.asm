; ======================================================
; reads a string from the keyboard
; DX => dest string
; CX => max chars
; CX <= actual amount of chars read
; ======================================================
readLine:
    mov di, dx
    mov word [.counter], 0x00 ; counts how many chars were read
.kbLoop:
    xor ax, ax              ; wait for key press
    int 0x16  
    
    test al, al             ; al=0 => special key
    jz .kbLoop

    cmp al, 0x0D            ; Enter?
    je .return              ; yes, return
    
    cmp al, 0x08            ; Backspace?    
    je .back                ; yes, delete last char
    
    inc word [.counter]     ; increment counter
    cmp word [.counter], cx ; if max_chars is reached, do not accept more chars
    jg .kbLoop
    
    cmp byte [SYSTEM_KB_STATUS], 0 ; check if y and z should be switched
    je .store
    
    cmp al, 'z' ; if yes => switch
    je .y
    cmp al, 'y'
    je .z
    cmp al, 'Z'
    je .Y
    cmp al, 'Y'
    je .Z
    
    jmp .store ; save the char in the dest string
    
.y:
    mov al, 'y'
    jmp .store
.Y:
    mov al, 'Y'
    jmp .store
.z:
    mov al, 'z'
    jmp .store
.Z:
    mov al, 'Z'
.store: ; saves the char in dest string and prints it on the screen
        ; also refreshes all relevant addresses
    stosb               ; save char
    
    pusha
    
    mov dh, al
    mov dl, byte [ds:SYSTEM_COLOR]
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
    mov dl, byte [ds:SYSTEM_COLOR] 
    call private_printChar
    
    dec byte [col] ; move cursor back
    mov dh, byte [row]
    mov dl, byte [col]
    call private_setCursorPosition
    
    popa
    
    ; Variable
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