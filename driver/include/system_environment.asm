; ======================================================
; Hardwareinfo
; gives cpuid infos
; AX => CPU vendor
; BX => CPU model
; ======================================================
hardwareInfo:
    call .getCpuInfo

    mov ax, .vendorString
    mov bx, .modelString

    iret

.getCpuInfo:
    xor eax, eax
    cpuid
    mov [.vendorString], ebx
    mov [.vendorString+4], edx
    mov [.vendorString+8], ecx
    
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000004
    jnge .return
    
    mov eax, 0x80000002
    cpuid
    mov [.modelString], eax
    mov [.modelString+4], ebx
    mov [.modelString+8], ecx
    mov [.modelString+12], edx
    
    mov eax, 0x80000003
    cpuid
    mov [.modelString+16], eax
    mov [.modelString+20], ebx
    mov [.modelString+24], ecx
    mov [.modelString+28], edx
    
    mov eax, 0x80000004
    cpuid
    mov [.modelString+32], eax
    mov [.modelString+36], ebx
    mov [.modelString+40], ecx
    mov [.modelString+44], edx
.return:
    ret
.vendorString times 13 db 0x00
.modelString times 49 db 0x00
; ======================================================


; ======================================================
getSystemVersion:
    mov ah, byte [MAJOR_VERSION]
    mov al, byte [MINOR_VERSION]
    iret
; ======================================================