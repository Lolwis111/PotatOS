[BITS 32]

%define VIDEO_MEMORY 0xB8000
%define WHITE_ON_BLACK 0x0F

print32:
    pusha
    mov edx, VIDEO_MEMORY
.charLoop:
    mov al, byte [ebx]
    mov ah, WHITE_ON_BLACK

    cmp al, 0x00
    je .done

    mov word [edx], ax
    add ebx, 1
    add edx, 2

    jmp .charLoop
.done:
    popa
    ret
