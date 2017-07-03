[BITS 16]
[ORG 0x9000]

%include "defines.asm"
%include "functions.asm"

start:
    strtol str1
    cmp eax, -1
    je .error
    
    push ecx
    
    print nl
    
    pop ecx
    
    ltostr res1, ecx
    
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