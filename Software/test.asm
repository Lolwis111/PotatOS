[BITS 16]
[ORG 0x9000]

%include "defines.asm"
%include "functions.asm"

start:
    mov dx, str3
    call stringToInt
    cmp eax, -1
    je .error
    push ecx
    print nl
    pop ecx
    mov dx, res1
    mov ah, 0xAA
    int 0x21
    
    print res1
    
    print nl
    
    EXIT 0
.error:
    EXIT 1
    
str1 db "123456789", 0x00
str2 db "987654", 0x00
str3 db "-78965", 0x00
nl db 0x0D, 0x0A, 0x00
res1 db 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

stringToInt:
    xor ecx, ecx ; result
    mov si, dx
    
    xor bl, bl ; sign
    
    cmp byte [si], '-'
    jne .loop1
    
    inc si
    inc bl
    
.loop1:
    cmp byte [ds:si], 0x00
    je .done

    cmp byte [ds:si], 0x0D
    je .done
    
    cmp byte [ds:si], 0x0A
    je .done
    
    cmp byte [ds:si], '0'
    jb .error
    cmp byte [ds:si], '9'
    ja .error
    
    shl ecx, 1
    mov eax, ecx
    shl ecx, 2
    add ecx, eax
    
    movzx eax, byte [ds:si]
    sub eax, 48
    
    add ecx, eax
    
    inc si
    jmp .loop1
    
.error:
    mov eax, -1
    xor ecx, ecx
    ret
.done:
    test bl, bl
    je .ret
    neg ecx
.ret:
    xor eax, eax
    ret