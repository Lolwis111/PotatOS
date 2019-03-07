%ifndef _A20_ASM_
%define _A20_ASM_

[BITS 32]

; ========================================
; enable the a20 gate to increase 
; available memory
; ========================================
enableA20:
    cli

    call .a20wait
    mov al, 0xAD
    out 0x64, al

    call .a20wait
    mov al, 0xD0
    out 0x64, al

    call .a20wait2
    in al, 0x60
    push eax

    call .a20wait
    mov al, 0xD1
    out 0x64, al

    call .a20wait
    pop eax
    or al, 2
    out 0x60, al

    call .a20wait
    mov al, 0xAE
    out 0x64, al

    call .a20wait

    sti
    ret
.a20wait:
    in al, 0x64
    test al, 2
    jnz .a20wait
    ret
.a20wait2:
    in al, 0x64
    test al, 1
    jz .a20wait2
    ret
; ========================================

%endif
