; ======================================================
; get time as string
; DX <= String
; ======================================================
getTimeString:
    pusha
    mov ah, 0x02
    int 0x1A
    mov di, .timeStr
    ;CH hours
    ;CL minutes
    push cx
    mov al, ch
    call private_bcdToInt
    
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    inc di
    pop cx
    
    mov al, cl
    call private_bcdToInt
    
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    popa
    mov dx, .timeStr
    iret

.timeStr db "00:00 Uhr", 0x00
; ======================================================


; ======================================================
; get date as string
; DX <= Stringoffset
; ======================================================
getDateString:
    pusha
    mov ah, 0x04
    int 0x1A
    mov di, .dateStr
    ; CH century
    ; CL year
    ; DH month
    ; DL day
    
    push cx
    push dx
    mov al, dl
    call private_bcdToInt
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    inc di
    
    pop dx
    mov al, dh
    call private_bcdToInt
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    inc di
    
    pop cx
    push cx
    mov al, ch
    call private_bcdToInt
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    pop cx
    mov al, cl
    call private_bcdToInt
    mov bl, 10
    div bl
    add al, 48
    stosb
    mov al, ah
    add al, 48
    stosb
    
    popa
    mov dx, .dateStr

    iret
    
.dateStr db "00.00.0000", 0x00
; ======================================================


; ======================================================
; al => BCD Byte
; ax <= Integer
private_bcdToInt:
    mov bl, al          
    and ax, 0x0F
    mov cx, ax          
    shr bl, 4           
    mov al, 10
    mul bl              
    add ax, cx          
    ret
bcdToInt:
    call private_bcdToInt
    mov cx, ax
    iret
; ======================================================