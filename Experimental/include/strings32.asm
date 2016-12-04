[BITS 32]
%ifndef _STRINGS32_H_
%define _STRINGS32_H_

str_compare:
.L1:
    push edi
    lodsb
    scasb
    jne .NotEqual
    test al, al
    jnz .L1

    xor eax, eax
    pop edi
    ret
.NotEqual:
    mov eax, 1
    ret

%endif
