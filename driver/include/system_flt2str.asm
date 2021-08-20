; ===============================================
; EBX <= 32 Bit float
; ES:EDX <= String Pointer
; ECX <= precision
; ===============================================
floatToString:
    pushad

    fnstcw word [.fpuControl]        ; load control
    fwait

    mov ax, word [.fpuControl]      ; 
    or ax, 0x0C00                   ; enable trunc rounding mode
    mov word [.fpuControl+2], ax    ; save copy

    ; check if ecx is bigger than 15 if yes clamp it to 15
    ; because internal memory restrictions and also why
    ; would you ever need more we talking single precision here
    mov ebp, 8
    cmp ecx, ebp
    cmova ecx, ebp

    ; if ecx is below 0 then just assume the user likes having 3 decimals
    mov ebp, 3
    cmp ecx, 0
    cmovb ecx, ebp

    mov ebp, edx

    mov byte [.sign], 0x00
    mov dword [.precision], ecx
    mov dword [.the_float], ebx 

    test dword [.the_float], 0x80000000
    jz .noSign

    mov byte [.sign], 0x01

.noSign:
    ; force most significant bit to 0 (force sign to be positive)
    and dword [.the_float], 0x7FFFFFFF

    mov eax, 1
.multiLoop:
    xor edx, edx
    mov ebx, 10
    mul ebx
    loop .multiLoop

    mov dword [.multi], eax

    call .x87trunc              ; enable truncate mode
    fld dword [.the_float]      ; load float
    frndint                     ; round to integer
    fistp dword [.intpart]      ; save integer part
    call .x87default            ; return to normal rounding

    fld dword [.the_float]      ; load float again
    fisub dword [.intpart]      ; decimals = (float - int_part)
    fimul dword [.multi]        ; multiply decimals by 100000
    frndint                     ; round to int again to get decimals
    fistp dword [.floatpart]     

    mov edx, .floatString1
    mov ecx, dword [.intpart]   ; convert integer part to string
    call private_intToString32

    mov edx, .floatString2
    mov ecx, dword [.floatpart]   ; convert decimals to string
    call private_intToString32

    xor ecx, ecx
    mov esi, .floatString2
.countDigits:                   ; count how many decimals there are
    cmp byte [esi], 0x00
    je .counted
    inc esi
    inc ecx
    jmp .countDigits
.counted:
    sub dword [.precision], ecx     ; number of decimals is maximal precision 
                                    ; so (precision - #decimals) = leading zeros do insert

    mov edi, .paddedDecimals

    cmp dword [.precision], 0       ; if ecx==.precsion we need no leading zeros
    je .noLeadingZeros

    push ecx
    
    mov ecx, dword [.precision] 
.padWith0:
    mov byte [edi], '0'
    inc edi
    loop .padWith0
    
    pop ecx

.noLeadingZeros:
    mov esi, .floatString2  ; only copy .floatString2 into .paddedDecimal
    rep movsb
.dbg:
    mov edi, ebp
    mov esi, .floatString1

    cmp byte [.sign], 0x01  ; if sign
    jne .copy
    mov byte [edi], '-'     ; put a - at the beginning
    inc edi
.copy:
    mov al, byte [esi]  ; copy integer part into final string
    inc esi
    test al, al
    jz .done
    mov byte [edi], al
    inc edi
    jmp .copy
.done:
    mov byte [edi], '.'   ; add the dot
    inc edi
    mov esi, .paddedDecimals

.copy2:
    mov al, byte [esi]  ; and copy decimals into final string
    inc esi
    test al, al
    jz .done2
    mov byte [edi], al
    inc edi
    jmp .copy2
.done2:
    mov byte[edi], 0x00

    popad
    iret

.x87trunc:
    fldcw word [.fpuControl+2]
    fwait
    ret
.x87default:
    fldcw word [.fpuControl]
    fwait
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