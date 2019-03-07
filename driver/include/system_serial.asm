com1_sendByte:
    call com1_privateSendByte
    ret

com1_privateSendByte:
    push dx
    push ax
    ; wait till the cable is clear
.wait:
    xor al, al
    mov dx, SERIAL_PORT_1+5
    in al, dx
    test al, 1
    jnz .wait

    pop ax
    mov dx, SERIAL_PORT_1
    ; send the byte
    out dx, al

    pop dx
    ret

com1_readChar:
    ret

com1_sendMessage:
    mov si, dx
    call com1_privateSendMessage
    iret

com1_privateSendMessage:
    mov si, dx
.byteLoop:
    lodsb
    cmp al, 0xFF
    je .done
    call com1_sendByte
    jmp .byteLoop
.done:
    ret

com1_readMessage:   
    iret
