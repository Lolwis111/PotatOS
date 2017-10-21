; ================================================
clearScreen:
    pusha
    xor bx, bx
    mov cx, SCREEN_BUFFER_SIZE
.loop1:
    mov word [gs:bx], dx
    add bx, 2
    loop .loop1
    movecur 0, 0
    popa    
    ret
; ================================================


; ================================================
clearColor:
    pusha
    mov bx, 1
    mov cx, SCREEN_BUFFER_SIZE-1
.loop1:
    mov byte [gs:bx], TEXT_COLOR
    add bx, 2
    loop .loop1
    popa    
    ret
; ================================================


; ================================================
; AX Time
; ================================================
convertTime:
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
    call convertDate.toString   ; convert hours to string
    
    mov si, .timeString+3
    mov al, bl
    call convertDate.toString ; convert minutes to string
    
    mov si, .timeString+6
    mov al, dl
    call convertDate.toString ; convert seconds to string
    
    popa
    mov si, .timeString
    ret
.timeString db "00:00:00", 0x00
; ================================================


; ================================================
; AX date
; ================================================
convertDate:
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
   
    itostr .dateString+6, cx    ; convert year to string
    
    popa
    mov si, .dateString
    ret
.toString: ; si <= string, al <= int
    push ax ; converts to digit int to string (we know its 2 digits because dates and times work like this)
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


; ================================================
printString:
    pusha
    xor cx, cx
.loop:
    mov al, byte [si]
    inc si
    test al, al
    jz .return
    mov byte [gs:di], al
    inc di
    mov byte [gs:di], ah
    inc di
    inc cx
    jmp .loop
.return:
    popa
    ret
; ================================================