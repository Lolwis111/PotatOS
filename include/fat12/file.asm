%ifndef _FAT12_FILE_H_
%define _FAT12_FILE_H_

%include "functions.asm"

; ================================================
; BL <= bits with attributes
; ================================================
fat12_parseAttributes:
    pusha
    pushf
    push ds
    push es
    cld
    mov di, .attributeString
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov byte [.attr], bl
.R:
    test byte [.attr], 00000001b
    jnz .readonly
.H:
    test byte [.attr], 00000010b
    jnz .hidden
.S:
    test byte [.attr], 00000100b
    jnz .system
.L:
    test byte [.attr], 00001000b
    jnz .label
.N:
    test byte [.attr], 00001111b
    jnz .lfn
.D:
    test byte [.attr], 00010000b
    jnz .directory
.A:
    test byte [.attr], 00100000b
    jnz .archive
    jmp .exit
.readonly:
    mov al, 'r'
    stosb
    jmp .H
.hidden:
    mov al, 'h'
    stosb
    jmp .S
.system:
    mov al, 's'
    stosb
    jmp .L
.label:
    mov al, 'n'
    stosb
    jmp .N
.lfn:
    mov al, 'l'
    stosb
    jmp .D
.directory:
    mov al, 'd'
    stosb
    jmp .A
.archive:
    mov al, 'a'
    stosb
.exit:
    xor al, al
    stosb
    pop es
    pop ds
    popf
    popa
    mov si, .attributeString
    ret
.attributeString times 9 db 0x00
.attr db 0x00
; ================================================


; ================================================
; AX <= time stamp in fat12 entry format
; SI => pointer to time in string
; ================================================
fat12_convertTime:
    pusha
    
    mov dx, ax
    and dx, 0x001F
    shl dx, 1    ; dx seconds
    
    mov bx, ax
    shr bx, 5
    and bx, 0x003F ; bx minutes
    
    mov cx, ax
    shr cx, 11    ; cx hours
    and cx, 0x001F
    
    mov si, .timeString
    mov al, cl
    call fat12_convertDate.toString   ; convert hours to string
    
    mov si, .timeString+3
    mov al, bl
    call fat12_convertDate.toString ; convert minutes to string
    
    mov si, .timeString+6
    mov al, dl
    call fat12_convertDate.toString ; convert seconds to string
    
    popa
    mov si, .timeString
    ret
.timeString db "00:00:00", 0x00
; ================================================


; ================================================
; AX <= date in fat12 format
; SI => pointer to date in string 
; ================================================
fat12_convertDate:
    pusha
    
    mov dx, ax
    and dx, 0x001F    ; dx day
    
    mov bx, ax
    shr bx, 5
    and bx, 0x000F    ; bx month
    
    xor cx, cx
    mov cl, ah
    shr cx, 1       ; cx year
   
    add cx, 1980d   ; year is relative to 1980 so we add this
    
    mov ax, dx
    mov si, .dateString
    call .toString          ; convert day to string
    
    mov ax, bx
    mov si, .dateString+3   ; convert month to string
    call .toString
   
    ITOSTR .dateString+6, cx    ; convert year to string
    
    popa
    mov si, .dateString
    ret
.toString: ; si <= string, al <= int
    push ax ; converts to digit int to string 
            ; (we know its 2 digits because
            ; dates and times work like this)
    push bx
    xor ah, ah
    mov bl, 10
    div bl
    mov byte [si], al
    add byte [si], 48   ; convert to ascii
    mov byte [si+1], ah
    add byte [si+1], 48
    pop bx
    pop ax
    ret
.dateString db "00/00/0000", 0x00
; ================================================

%endif
