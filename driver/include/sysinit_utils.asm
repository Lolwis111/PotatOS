; =======================================================
Print:
	lodsb
	or al, al
	jz .return
	mov ah, 0x0E
	int 0x10
	jmp Print
.return:
	ret
; =======================================================


; =======================================================
enableA20: ; enable A20-Gate to use a little more memory
    pusha
    
    call .wait_input
    mov al,0xAD
    out 0x64, al
    call .wait_input

    mov al, 0xD0
    out 0x64, al
    call .wait_output

    in al, 0x60
    push eax
    call .wait_input

    mov al, 0xD1
    out 0x64, al
    call .wait_input

    pop eax
    or al, 2
    out 0x60, al

    call .wait_input
    mov al, 0xAE
    out 0x64, al

    call .wait_input
    popa
    
    ret
    
.wait_input:
    in al, 0x64
    test al, 2
    jnz .wait_input
    ret
        
.wait_output:
    in al, 0x64
    test al, 1
    jz .wait_output
    ret
; =======================================================