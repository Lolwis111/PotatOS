; ===============================================
; EBX <= 32 Bit float
; DS:EDX <= String Pointer
; ECX <= precision
; ===============================================
floatToString:
    pushad
    push es

    xor ax, ax
    mov bp, dx
    mov es, ax

    fnstcw word [es:.fpuControl]        ; load control

    mov ax, word [es:.fpuControl]      ; 
    or ax, 0x0C00                   ; enable trunc rounding mode
    mov word [es:.fpuControl+2], ax    ; save copy

    ; check if ecx is bigger than 8 if yes clamp it to 8
    ; because internal memory restrictions and also why
    ; would you ever need more we talking single precision here
    test ecx, ecx
    jns .positive
    neg ecx
.positive:
    cmp ecx, 7
    jbe .noClamp
    mov ecx, 7
.noClamp:
    ; save the register paramters
    mov byte [es:.sign], 0x00
    mov dword [es:.precision], ecx
    mov dword [es:.the_float], ebx 

    ; test msb  -> 1 means negative
    test dword [es:.the_float], 0x80000000
    setnz byte [es:.sign]

    ; force most significant bit to 0 (force sign to be positive)
    and dword [es:.the_float], 0x7FFFFFFF
    mov eax, 1
.multiLoop:
    ; eax * 10 = (eax * 5) * 2
    lea eax, [eax + eax * 4] ; eax = eax*4 + eax = eax*5
    shl eax, 1 ; eax = eax * 2
    loop .multiLoop

    mov dword [es:.multi], eax

    call .x87trunc              ; enable truncate mode
    fld dword [es:.the_float]      ; load float
    frndint                     ; round to integer
    fistp dword [es:.intpart]      ; save integer part
    call .x87default            ; return to normal rounding

    fld dword [es:.the_float]      ; load float again
    fisub dword [es:.intpart]      ; decimals = (float - int_part)
    fimul dword [es:.multi]        ; multiply decimals by 100000
    frndint                     ; round to int again to get decimals
    fistp dword [es:.floatpart]     

    mov dx, .floatString1
    mov ecx, dword [es:.intpart]   ; convert integer part to string
    call private_intToString32

    mov dx, .floatString2
    mov ecx, dword [es:.floatpart]   ; convert decimals to string
    call private_intToString32

    xor ecx, ecx
    mov si, .floatString2
.countDigits:                   ; count how many decimals there are
    cmp byte [es:si], 0x00
    je .counted
    inc si
    inc ecx
    jmp .countDigits
.counted:
    sub dword [es:.precision], ecx     ; number of decimals is maximal precision 
                                    ; so (precision - #decimals) = leading zeros do insert

    mov di, .paddedDecimals

    cmp dword [es:.precision], 0       ; if ecx==.precsion we need no leading zeros
    je .noLeadingZeros

    mov ecx, dword [es:.precision] 
.padWith0:
    mov byte [es:di], '0'
    inc di
    loop .padWith0
    
    mov ecx, dword [es:.precision] 
.noLeadingZeros:
    mov si, .floatString2  ; only copy .floatString2 into .paddedDecimal
    rep movsb
.dbg:
    mov di, bp
    mov si, .floatString1

    cmp byte [es:.sign], 0x01  ; if sign
    jne .copy
    mov byte [ds:di], '-'     ; put a - at the beginning
    inc di
.copy:
    mov al, byte [es:si]  ; copy integer part into final string
    inc si
    test al, al
    jz .done
    mov byte [ds:di], al
    inc edi
    jmp .copy
.done:
    mov byte [ds:di], '.'   ; add the dot
    inc di
    mov si, .paddedDecimals

.copy2:
    mov al, byte [es:si]  ; and copy decimals into final string
    inc si
    test al, al
    jz .done2
    mov byte [ds:di], al
    inc di
    jmp .copy2
.done2:
    mov byte[ds:di], 0x00

    pop es
    popad
    iret

.x87trunc:
    fldcw word [es:.fpuControl+2]
    ret
.x87default:
    fldcw word [es:.fpuControl]
    ret

.the_float dd 0x00000000
.floatpart dd 0x00000000
.intpart dd 0x00000000
.multi dd 0x00000000
.precision dd 0x00000000
.floatString1 times 20 db 0x0
.floatString2 times 10 db 0x0
.paddedDecimals times 10 db 0x0
.fpuControl dw 0x0000, 0x0000
.sign db 0x00
; ===============================================