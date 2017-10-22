; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Contains basic os features that can be       %
; % accessed using the int 0x21                  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SYSTEM_SYS]
[BITS 16]

main:
    cmp ah, 0x00        ; exit program and start terminal
    je exitProgram
    
    cmp ah, 0x01        ; print \0 terminated string
    je printString
    
    cmp ah, 0x02        ; compare two strings
    je compareString
    
    cmp ah, 0x03        ; convert int to string
    je intToString16
    
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
    
    cmp ah, 0x17        ; start a process
    je startProgram
    
    ; all new 32-bit ready string-int operation
    cmp ah, 0xAA
    je intToString32
    
    iret

%include "fat12.asm"
%include "common.asm"
%include "language.asm"
%include "strings.asm"

%include "system_int2str.asm"
%include "system_str2int.asm"
%include "system_print.asm"
%include "system_hexstr.asm"
%include "system_diskIO.asm"
%include "system_cursor.asm"
%include "system_datetime.asm"
%include "system_userIO.asm"
%include "system_environment.asm"

col db 0x00
row db 0x06
    
; ======================================================
; exits the current program and jumps back to cli
; ======================================================
exitProgram:
    mov word [ERROR_CODE], bx
    
    mov dh, byte [row]  ; move cursor to the left
    mov dl, 0x00        
    call private_setCursorPosition
    
    push ds ; save the segments
    push es
    
    ; mov ax, 0x8000 ; we loaded command.bin at 0x8000:0x0000
    ; mov ds, ax
    ; xor si, si
    ; mov es, si
    ; mov di, 0x9000 ; so just copy it down into the program memory
    ; mov cx, 2048
    ; rep movsw
    
    ; pop es ; restore the segments
    ; pop ds
    ; mov ax, -1
    ; jmp SOFTWARE_BASE
    
    mov dx, .fileName   ; just start command.bin and go back to the terminal
    mov di, -1
    jmp startProgram
    
.fileName db "COMMAND BIN", 0x00
; ======================================================


; ======================================================
; DX <= filename
; ES:DI <= argument string to pass
; ======================================================
startProgram:
    cmp di, -1
    je .noArgs

    pusha
    mov dh, '0'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    
    mov si, di
    mov di, .argumentTemp

    mov cx, 64
.copyArgs:                  ; copy argument to a location that wont be overriden by the new program
    mov al, byte [si]
    test al, al
    jz .copyDone
    mov byte [di], al
    inc si
    inc di
    dec cx
    jz .copyDone
    jmp .copyArgs
.noArgs:
    mov byte [.argumentTemp], -1
.copyDone:
    pusha
    mov dh, '1'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    mov byte [di], 0x00
    mov si, dx              ; check that filename has .BIN extension
    cmp byte [si+8], 'B'
    jne .noExecutableError
    cmp byte [si+9], 'I'
    jne .noExecutableError
    cmp byte [si+10], 'N'
    jne .noExecutableError
    
    pusha
    mov dh, '2'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    
    push si
    
    mov bx, SOFTWARE_BASE ; load the program into memory
    xor bp, bp
    call private_loadFile
    
    pop si
    
    pusha
    mov dh, '3'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    
    cmp ax, 0               ; check if that worked    
    jne .trySystemDir 
    
    add esp, 6  ; remove stack pointers created by interrupt instruction, we do not need this
    
    mov ax, .argumentTemp
    jmp SOFTWARE_BASE   ; start programm
    
.noExecutableError:
    mov ax, 0x01
    stc
    iret
    
.trySystemDir:
    pusha
    mov dh, 'A'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    ; if load file fails we try to load the file from the system/ directory
    mov di, si
    push ds
    mov ax, 0x8000
    mov ds, ax
    xor si, si
.fileLoop:
    cmp byte [ds:si], 0x00
    je .error
    
    push si
    push di
    mov cx, 11
    rep cmpsb
    je .fileFound
    pop di
    pop si
    
    add si, 32
    jmp .fileLoop
.fileFound:
    pop di
    pop si
    pop ds
    
    pusha
    mov dh, 'B'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    
    mov bx, SOFTWARE_BASE ; load the program into memory
    xor bp, bp
    call ReadFile.customDirectory
    jc .error
    
    pusha
    mov dh, 'C'
    mov dl, byte [0x1FFF]
    call private_printChar
    popa
    
    add esp, 6  ; remove stack pointers created by interrupt instruction, we do not need this
    
    mov ax, .argumentTemp
    jmp SOFTWARE_BASE   ; start programm
    
.error:
    stc
    mov ax, 0x02
    iret
.argumentTemp times 65 db 0x00
; ======================================================


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
; generate a pseudo random number based on a 
; linear congruential generator. Do NOT use this
; for security relevant stuff, but for graphical
; demos its fine
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