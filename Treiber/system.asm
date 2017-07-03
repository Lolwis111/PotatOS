; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Contains basic os features that can be       %
; % accessed using the int 0x21                  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[ORG 0x1000]
[BITS 16]

main:
    cmp ah, 0x00        ; exit program, jump to cli
    je exitProgram
    
    cmp ah, 0x01        ; print \0 terminated string
    je printString
    
    cmp ah, 0x02        ; compare two strings
    je compareString
    
    cmp ah, 0x03        ; convert int to string
    je intToStr
    
    cmp ah, 0x04        ; read string from keyboard
    je readLine 
    
    cmp ah, 0x05        ; load file
    je loadFile
    
    cmp ah, 0x06        ; get time as string
    je getTimeString
    
    cmp ah, 0x07        ; get date as string
    je getDateString
    
    cmp ah, 0x08        ; system version
    je getSystemVersion

    cmp ah, 0x09        ; convert string to int
    je stringToInt

    cmp ah, 0x0A        ; delete file
    je deleteFile    

    cmp ah, 0x0B        ; random number generator
    je random           

    cmp ah, 0x0C        ; get cpu info
    je hardwareInfo

    cmp ah, 0x0D        ; string hex-byte to decimal
    je hexToDec

    cmp ah, 0x0E        ; set cursor position
    je setCursorPosition
   
    cmp ah, 0x0F        ; get cursor positon
    je getCursorPosition
   
    cmp ah, 0x10        ; print a single character
    je printCharC
   
    cmp ah, 0x11        ; save root dir
    je getRootDir
    
    cmp ah, 0x12        ; load root dir
    je setRootDir
    
    cmp ah, 0x13        ; look for a file
    je findFile
    
    cmp ah, 0x14        ; write a file
    je writeFile
    
    cmp ah, 0x15        ; convert byte to hex-string
    je decToHex

    cmp ah, 0x16        ; convert bcd-byte to int-byte
    je bcdToInt
    
    ; all new 32-bit ready string-int operation
    
    cmp ah, 0xAA
    je intToString32
    
    iret

%include "fat12.asm"
%include "common.asm"
%include "defines.asm"
%include "language.asm"
    
col db 0x00
row db 0x09
    
; ======================================================
; exits the current program and jumps back to cli
; ======================================================
exitProgram:    
    test bx, bx         ; check for error code
    jnz .rError         ; zero is good, everything else is errorcode
.r:
    mov dh, byte [row]  ; move cursor to the left
    mov dl, 0x00        
    call private_setCursorPosition

    jmp MAIN_SYS+9      ; cli is at 0x2000, main loop is at 0x2009

.rError:
    mov bl, byte [ds:SYSTEM_COLOR] ; in case of error code a message is printed
    mov dx, SOFTWARE_ERROR         
    call private_printString
    
    jmp .r
; ======================================================


; ======================================================
; DX -> String
; BL -> Color
; ======================================================
printString: ; public wrapper
    call private_printString
    iret

;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
private_printString:
    mov si, dx  ; copy string to source register
    mov dl, bl  ; copy color
    push bx    
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.charLoop: ; read the string char by char and only stop when \0 appears
    lodsb       
    test al, al 
    jz .end
    mov dh, al
    call printChar ; each char is printed seperatly
    
    jmp .charLoop
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.end:
    pop bx ; adjust cursor position at the end
    mov dh, byte [row]
    mov dl, byte [col]
    call private_setCursorPosition
    ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
printCharC: ; public wrapper
    call printChar
    iret
    
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
printChar:
    push dx
    mov ax, VIDEO_MEMORY_SEGMENT ; calculate address in memory that belongs to cursor positon
    mov gs, ax                
    movzx bx, byte [col]   ; forumla: (x * 2) + (y * SCREEN_WIDTH)
    movzx ax, byte [row]
    shl bx, 1
    mov cx, SCREEN_WIDTH*2
    mul cx
    add bx, ax
    pop dx
    
    cmp dh, 0x0D ; \n and \r are handled differenz
    je .cr
    cmp dh, 0x0A
    je .lf
    
    mov byte [gs:bx], dh    ; write the char and the color to vga memory
    mov byte [gs:bx+1], dl
    add bx, 2
    
    inc byte [col]
    
    cmp byte [col], 160 ; when we reach the right end of the screen we goto to the next line
                        ; 
    je .newLine 
    ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.newLine:
    mov byte [col], 0x00 ; move cursor to the left border
    inc byte [row]      ; increment linenumber
    
    cmp byte [row], 23
    jae .moveBuffer     ; when we are at the very bottom we move the whole buffer one row up
    
    ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.cr:
    mov byte [col], 0x00 ; \r just jumps to the left border
    ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.lf:
    inc byte [row]      ; move cursor one row down
    cmp byte [row], 23
    jae .moveBuffer     ; we reach the bottom -> we scroll
    ret
;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
.moveBuffer:
    push si
    mov byte [row], 22  ; copy the whole vga memory (beginning at line 2)
    mov ax, es          ; one line up
    
    push ax             ; the very bottom row is filled with spaces
    mov ax, ds
    push ax
    
    mov ax, VIDEO_MEMORY_SEGMENT
    mov es, ax
    mov ds, ax
    mov si, 160
    mov di, 0x00
    mov cx, (SCREEN_BUFFER_SIZE - SCREEN_WIDTH)
    rep movsw
    
    pop ax
    mov ds, ax
    pop ax
    mov es, ax
    pop si
    ret
; ======================================================    


; ======================================================
; DH -> Row
; DL -> Column
; ======================================================
private_setCursorPosition:

    cmp dh, 0
    jb .clampY0
    cmp dh, 24
    ja .clampY24
    
    cmp dl, 0
    jb .clampX0
    cmp dl, 79
    ja .clampX79
    
.clampOK:

    movzx ax, dh
    movzx bx, dl

    mov byte [row], dh ; save the cursor for ourselfs
    mov byte [col], dl
    shl ax, 4          ; set the hardware cursor using vga registers
    add bx, ax
    shl ax, 2
    add bx, ax

    mov al, 0x0F
    mov dx, 0x3D4
    out dx, al
    
    mov ax, bx
    mov dx, 0x3D5
    out dx, al
    
    mov al, 0x0E
    mov dx, 0x3D4
    out dx, al
    
    mov ax, bx
    shr ax, 8
    mov dx, 0x3D5
    out dx, al
    
    ret
.clampY0:
    mov dh, 0x00
    jmp .clampOK
.clampY24:
    mov dh, 24
    jmp .clampOK
.clampX0:
    mov dl, 0x00
    jmp .clampOK
.clampX79:
    mov dl, 79
    jmp .clampOK
    
setCursorPosition: ; public wrapper
    call private_setCursorPosition
    iret
; ======================================================


; ======================================================
getCursorPosition:
    mov dh, byte [row] ; return the cursor positon
    mov dl, byte [col] ; 
    iret
; ======================================================


; ======================================================
; loads a file into memory
;
; buffer   => BX:BP
; filename => DX
; AX <= result, 0 = OK, -1 = ERROR
; CX <= Size 
; ======================================================
loadFile: ; basically a wrapper for fat12.asm
    push bp
    push bx
    push dx
    
    call LoadRoot
    
    pop dx
    pop bx
    pop bp
    
    xor ax, ax
    mov si, dx
    call LoadFile
    iret
; ======================================================


; ======================================================
; DX <= file
; CX <= size in byte
; BX:BP <= buffer
; ======================================================
writeFile:
    mov si, dx
    call WriteFile
.return:
    iret
; ======================================================


; ======================================================
; AX -> load root dir
; ======================================================
getRootDir:
    call LoadRoot
    mov bp, ROOT_OFFSET
    mov cx, word [RootEntries]
    iret
; ======================================================


; ======================================================
; AX -> save root dir
; ======================================================
setRootDir:
    call WriteRoot
    iret
; ======================================================


; ======================================================
; deletes a file
;
; DX <= Dateiname
; ======================================================
deleteFile:
    mov si, dx
    call DeleteFile
    
    iret
; ======================================================


; ======================================================
; searches for a file in the root directory
;
; DX => filename
; AX <= -1 not found, else: index in root dir
; ======================================================
findFile:
    mov si, dx
    call FindFile
    
    iret
; ======================================================


; ======================================================
; reads a string from the keyboard
; DX => dest string
; CX => max chars
; CX <= actual amount of chars read
; ======================================================
readLine:
    mov di, dx
    mov word [.counter], 0x00 ; counts how many chars were read
.kbLoop:
    xor ax, ax              ; wait for key press
    int 0x16  
    
    test al, al             ; al=0 => special key
    jz .kbLoop

    cmp al, 0x0D            ; Enter?
    je .return              ; yes, return
    
    cmp al, 0x08            ; Backspace?    
    je .back                ; yes, delete last char
    
    inc word [.counter]     ; increment counter
    cmp word [.counter], cx ; if max_chars is reached, do not accept more chars
    jg .kbLoop
    
    cmp byte [SYSTEM_KB_STATUS], 0 ; check if y and z should be switched
    je .store
    
    cmp al, 'z' ; if yes => switch
    je .y
    cmp al, 'y'
    je .z
    cmp al, 'Z'
    je .Y
    cmp al, 'Y'
    je .Z
    
    jmp .store ; save the char in the dest string
    
.y:
    mov al, 'y'
    jmp .store
.Y:
    mov al, 'Y'
    jmp .store
.z:
    mov al, 'z'
    jmp .store
.Z:
    mov al, 'Z'
.store: ; saves the char in dest string and prints it on the screen
        ; also refreshes all relevant addresses
    stosb               ; save char
    
    pusha
    
    mov dh, al
    mov dl, byte [ds:SYSTEM_COLOR]
    call printChar
    mov dl, byte [col]
    mov dh, byte [row]
    call private_setCursorPosition
    
    popa
    
    jmp .kbLoop         ; read the next char
    
.back:
    cmp word [.counter], 0x00; decrement counter, but only delete the chars that were entered
    jbe .kbLoop
    dec word [.counter]
    
    pusha
    
    dec byte [col]      ; move on char back
    
    mov dh, 0x00
    mov dl, byte [ds:SYSTEM_COLOR] 
    call printChar
    
    dec byte [col] ; move cursor back
    mov dh, byte [row]
    mov dl, byte [col]
    call private_setCursorPosition
    
    popa
    
    ; Variable
    dec di              ; move on char back
    mov al, 0x00            
    stosb               ; override with zero
    dec di              
    
    jmp .kbLoop
    
.return:
    xor al, al
    stosb               ; strings are \0 terminated
    mov cx, word [.counter]
    iret                ; return
    
.counter dw 0x00

; ======================================================
; compares two strings
; DI => string 1
; SI => string 2
; AL <= 0 equal, 1 not equal
; ======================================================
compareString:
    pusha
    xor al, al
.Loop:
    lodsb
    scasb
    jne .NotEqual
    test al, al
    jnz .Loop

    popa
    xor al, al
    iret
.NotEqual:
    popa
    mov al, 0x01
    iret
; ======================================================


; ======================================================
; intToStr (16 bit)
; dx => String
; cx => number
; ======================================================
intToStr:
    pusha
    mov ax, cx
    mov di, dx
    xor cx, cx
    xor bp, bp
    
    cmp ax, 0x00
    jns .digit1
    
    neg ax
    mov byte [di], '-'
    inc di
    
.digit1:        
    xor dx, dx
    mov bx, 10000
    div bx              ; 0 0000
    
    cmp al, 0x00
    jz .zero1
    
    add al, 48
    stosb
    jmp .digit2
    
.zero1:
    mov bp, 0x01
    
.digit2:
    mov ax, dx
    mov bx, 1000
    xor dx, dx
    div bx              ; 0 000
    
    cmp al, 0x00
    jz .ok2
.nok2:
    add al, 48
    stosb
    xor bp, bp
    jmp .digit3
.ok2:
    cmp bp, 0x01
    jnz .nok2
.zero2:
    mov bp, 0x01
    
    
.digit3:
    mov ax, dx
    mov bx, 100
    xor dx, dx
    div bx              ; 0 00

    cmp al, 0x00
    jz .ok3
.nok3:
    add al, 48
    stosb
    xor bp, bp
    jmp .digit4
.ok3:   
    cmp bp, 0x01
    jnz .nok3
.zero3:
    mov bp, 0x01

    
.digit4:
    mov ax, dx
    mov bx, 10
    xor dx, dx
    div bx              ; 0 0
    
    cmp al, 00h
    jz .ok4
.nok4:
    add al, 48
    stosb
    jmp .digit5
    
.ok4:
    ; cmp byte [.status], 01h
    cmp bp, 0x01
    jnz .nok4

.digit5:
    xchg ax, dx
    add al, 48
    stosb

.end:
    xor al, al
    stosb
    popa
    iret
; ======================================================


; ======================================================
intToString32:
    mov si, dx
    mov eax, ecx

    test eax, eax
    jz .zero

    cmp eax, 0x00
    jns .start

    not eax
    inc eax
    mov byte [si], '-'
    inc si

.start:
    mov byte [.leadingZero], 0x01
    mov dword [.divisor], 1000000000
.loop1:
    xor edx, edx
    mov ebx, dword [.divisor]
    div ebx

    cmp al, 0x00
    jne .else
    cmp byte [.leadingZero], 0x01
    jne .else

    mov eax, edx
    jmp .div10
.else:
    mov byte [si], al
    add byte [si], 48
    inc si
    mov byte [.leadingZero], 0x00
    mov eax, edx
.div10:
    push eax

    xor edx, edx
    mov eax, dword [.divisor]
    mov ebx, 10
    div ebx
    mov dword [.divisor], eax
    cmp eax, 0
    je .return
    pop eax
    jmp .loop1
.return:
    mov byte [si], 0x00
    pop eax
    iret
.zero:
    mov byte [si], '0'
    inc si
    mov byte [si], 0x00
    iret
.leadingZero db 0x01
.divisor dd 1000000000
; ======================================================


; ======================================================
; get time as string
; DX <= String
; ======================================================
getTimeString:
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
    
    mov dx, .timeStr

    iret

.timeStr db "00:00 Uhr", 0x00
; ======================================================


; ======================================================
; get date as string
; DX <= Stringoffset
; ======================================================
getDateString:
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
    
    mov dx, .dateStr

    iret
    
.dateStr db "00.00.0000", 0x00
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

getSystemVersion:
    mov ah, 0
    mov al, 7
    iret
; ======================================================


; ======================================================
; convert string to int
; DX => String
; ECX <= Number
; EAX <= -1 Error
; ======================================================
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
    iret
.done:
    test bl, bl
    je .ret
    neg ecx
.ret:
    xor eax, eax
    iret
; ======================================================


; ======================================================
; CL -> byte
; DX <- Hexstring
; ======================================================
decToHex:
    pusha
    pushf
    
    mov ax, cx
    mov si, dx
    xor ah, ah

    mov bl, 16
    div bl
    mov bx, .hexChar
    add bl, al
    mov al, byte [bx]
    mov byte [ds:si], al
    inc si
    mov bx, .hexChar
    add bl, ah
    mov al, byte [bx]
    mov byte [ds:si], al
    inc si
    mov byte [ds:si], 0x00
    
    popf
    popa
    
    iret
.hexChar db "0123456789ABCDEF"
; ======================================================


; ======================================================
; Converts a hexadecimal digit in al to
; a base10 value in cl
; al <= hex digit
; cl => base10 number
; ======================================================
private_hexToDec:
    mov si, dx
    xor cx, cx
    mov cl, al
    cmp cl, '0'         ; anything below 0 is invalid (check ascii map)
    jb .invalidDigit
    
    cmp cl, '9'         ; anything from 0-9 is a valid digit
    ja .checkAtoF       ; chars greater than 9 are letters (which can be valid)
    
    sub cl, '0'         ; get the decimal value from the ascii char
    xor ax, ax          ; no error
    ret                 ; return
.checkAtoF:             ; check uppercase letters
    cmp cl, 'A'         ; everyting below A is invalid
    jb .invalidDigit    
    cmp cl, 'F'         ; everything above F may be lowercase letter
    ja .checkatof
    
    sub cl, 'A'         ; get decimal value from ascii char
    xor ax, ax          ; no error
    ret                 ; return
.checkatof:             ; check lowercase letters
    cmp cl, 'a'         ; now only a-f remain as valid digits
    jb .invalidDigit    ; everything else is invalid
    cmp cl, 'f'
    ja .invalidDigit
    
    sub cl, 'a'         ; get decimal value
    clc                 ; no error
    ret                 ; return
.invalidDigit:
    xor cx, cx          ; zero the output value
    stc                 ; an error occured
    ret                 ; return
; ======================================================
    

; ======================================================
; converts the first two characters of the string into
; decimal, assuming they represent a hexadecimal value
; ======================================================
hexToDec:
;    mov si, dx          ; copy the given string
;    xor bx, bx          ; this will be our working register
;    xor cx, cx          ; this is the result
;    mov al, byte [ds:si]   ; get the first char
;    inc si              ; move to the next char
    
;    call private_hexToDec   ; try to convert the first char
;    cmp ax, -1              ; occured an error?
;    je .invalidDigit        ; if yes error out
    
;    add bx, cx              ; else add the value
    
;    shl bx, 4               ; multiply the result by 16 (since hexadecimal is base 16)
    
;    mov al, byte [ds:si]       ; get the next char
;    call private_hexToDec   ; try to convert the second char
;    cmp ax, -1              ; occured an error?
;    je .invalidDigit        ; if yes error out
    
;    add bx, cx              ; else add the value
;    mov cx, bx              ; copy the value to result register
;    xor ax, ax              ; no error
    
;    iret                    ; return
;.invalidDigit:
;    xor cx, cx              ; clear the result
;    mov ax, -1              ; indicate error
;    iret                    ; return
; ======================================================
    mov si, dx
    xor ax, ax
    xor bx, bx
   mov al, byte [ds:si]
   inc si
    
   cmp al, 48  ; digits 0-9
   je .num16
   cmp al, 49
   je .num16
   cmp al, 50
   je .num16
   cmp al, 51
   je .num16
   cmp al, 52
   je .num16
   cmp al, 53
   je .num16
   cmp al, 54
   je .num16
   cmp al, 55
   je .num16
   cmp al, 56
   je .num16
   cmp al, 57
   je .num16
.chars:            ; digits A-F
   cmp al, 65
   je .char16
   cmp al, 66
   je .char16
   cmp al, 67
   je .char16
   cmp al, 68
   je .char16
   cmp al, 69
   je .char16
   cmp al, 70
   je .char16

   cmp cx, 1
   je .noc
   mov cx, 1
   sub al, 32
   jmp .chars
.noc:
   mov ax, -1
   iret
    
.num16:
   sub ax, 48
   shl ax, 4
   jmp .hex2
.char16:
   sub ax, 55
   shl ax, 4
.hex2:
   mov bx, ax
   mov al, byte [ds:si]
   inc si
   cmp al, 48
   je .num161
   cmp al, 49
   je .num161
   cmp al, 50
   je .num161
   cmp al, 51
   je .num161
   cmp al, 52
   je .num161
   cmp al, 53
   je .num161
   cmp al, 54
   je .num161
   cmp al, 55
   je .num161
   cmp al, 56
   je .num161
   cmp al, 57
   je .num161
.chars2:
   cmp al, 65
   je .char161
   cmp al, 66
   je .char161
   cmp al, 67
   je .char161
   cmp al, 68
   je .char161
   cmp al, 69
   je .char161
   cmp al, 70
   je .char161
    
   cmp cx, 2
   je .noc2
   mov cx, 2
   sub al, 32
   jmp .chars2
.noc2:
   mov ax, -1
   xor cx, cx
   iret
.num161:
   sub ax, 48
   add bx, ax
   jmp .end
.char161:
   sub ax, 55
   add bx, ax
.end:
    xor ax, ax
   mov cx, bx
   iret
; ======================================================

; ======================================================
random:
    xor edx, edx
    mov eax, 24298
    mov ebx, dword [.lastX]
    mul ebx
    mov ebx, 199017
    div ebx
    mov dword [.lastX], edx
    mov ecx, edx
    ret
.lastX dd 125
; ======================================================


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

%ifdef DEBUG
    db "SYSTEM_END"
%endif
