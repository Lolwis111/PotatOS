%include "defines.asm"

[BITS 16]
[ORG SOFTWARE_BASE]

jmp start

%include "functions.asm"
%include "language.asm"

; ===============================================
; ES:EDX <= String pointer
; EAX => 32 Bit float
; ===============================================
str_to_float:
    pusha

    mov edi, .intstr
.copy:
    mov al, byte [es:edx]   ; copy int part so up to the dot
    inc edx
    cmp al, 0x00
    je .done2
    cmp al, '.'
    je .done
    mov byte [edi], al
    inc edi
    jmp .copy
.done:
    mov edi, .floatstr
.copy2:                     ; copy the part after the dot (decimals)
    mov al, byte [es:edx]
    inc edx
    test al, al
    jz .done2
    mov byte [edi], al
    inc edi
    jmp .copy2
.done2:
    mov esi, .floatstr
    mov eax, 1 
    ; count how long decimal string is and calculate divisor on the go
    ; length 5 -> 10^5 divisor
.float_length:
    push eax
    mov al, byte [esi]
    inc esi
    test al, al
    jz .done3
    pop eax
    xor edx, edx
    mov ebx, 10
    mul ebx
    jmp .float_length
.done3:
    pop eax

    mov dword [.divisor], eax

    STRTOL .floatstr
    mov dword [.floatpart], ecx ; convert decimals

    STRTOL .intstr
    mov dword [.intpart], ecx ; convert int part

    ; float = int_part + (float_part / divisor)
    ; e.g. 3.1415 = 3 + (1415 / 10000)

    fild dword [.floatpart]
    fidiv dword [.divisor]
    fiadd dword [.intpart]

    fst dword [.the_float]
    mov eax, dword [.the_float]

    popa
    ret
.intstr times 10 db 0x00
.floatstr times 10 db 0x00
.intpart dd 0x00000000
.floatpart dd 0x00000000
.divisor dd 0x00000000
.the_float dd 0x00000000
; ===============================================


; ===============================================
; EAX <= 32 Bit float
; ES:EDX <= String Pointer
; ECX <= precision
; ===============================================
float_to_str:
    push eax
    push esi
    push ecx
    push edx

    push eax

    mov eax, 1
.multiLoop:
    xor edx, edx
    mov ebx, 10
    mul ebx
    loop .multiLoop

    mov dword [.multi], eax

    pop eax
    mov dword [.the_float], eax     ; load float
    fld dword [.the_float]  
    fist dword [.intpart]       ; round to int and store int_part
    fisub dword [.intpart]      ; decimals = (float - int_part)
    fimul dword [.multi]        ; multiply decimals by 100000
    fist dword [.floatpart]     ; round to int again to get decimals
    
    LTOSTR .floatString1, dword [.intpart]  ; convert integer part to string

    LTOSTR .floatString2, dword [.floatpart]  ; convert decimals to string

    pop edx
    push edx
    mov esi, .floatString1
.copy:
    mov al, byte [esi]  ; copy integer part into final string
    inc esi
    test al, al
    jz .done
    mov byte [es:edx], al
    inc edx
    jmp .copy
.done:
    mov byte [es:edx], '.'   ; add the dot
    inc edx
 mov esi, .floatString2
.copy2:
    mov al, byte [esi]  ; and copy decimals into final string
    inc esi
    test al, al
    jz .done2
    mov byte [es:edx], al
    inc edx
    jmp .copy2
.done2:

    pop edx
    pop ecx
    pop esi
    pop eax
    ret

.the_float dd 0x00000000
.floatpart dd 0x00000000
.intpart dd 0x00000000
.multi dd 0x00000000
.floatString1 times 20 db 0x0
.floatString2 times 20 db 0x0
; ===============================================


float1: dd 3.1415
float2: dd 0.0
the_string: times 50 db 0x00
the_string2: times 50 db 0x00
start:
    PRINT .str1

    ; set es to be sure
    xor ax, ax
    mov es, ax
    
    ; convert the float to a string
    mov eax, dword [float1]
    mov edx, the_string
    mov ecx, 4
    call float_to_str

    ; print result
    PRINT the_string
    PRINT NEWLINE

    PRINT .str2
    ; reconvert the string to a float
    mov edx, the_string
    call str_to_float

    mov dword [float2], eax
    PRINT .str3

    ; and rereconvert the float back to a string
    mov eax, dword [float2]
    mov edx, the_string2
    mov ecx, 2
    call float_to_str

    ; and print again
    PRINT the_string2
    PRINT NEWLINE

    EXIT EXIT_SUCCESS
.str1: db "Convert float to string (expected: 3.1415)\r\n", 0x00
.str2: db "Convert string to float\r\n", 0x00
.str3: db "Convert float to string again (expected: 3.1415)\r\n", 0x00
