; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Contains basic os features that can be       %
; % accessed using the int 0x21                  %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"
%include "keys.asm"

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
    
    cmp ah, 0x05        ; loads a file form the current directory
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
    
    cmp ah, 0x18        ; reinitialize the timer
    je sleepInit

    cmp ah, 0x19        ; sleep for ebx*10 milliseconds
    je sleep

    cmp ah, 0x1A        ; read a directory
    je loadDirectory

    cmp ah, 0x1B        ; loads a file given the entry in any directory
    je loadFileEntry

    cmp ah, 0x1C
    je floatToString

    cmp ah, 0x1D
    je stringToFloat

    ;cmp ah, 0x1C
    ;je startProgramEntry ; start a process based on file entry

    cmp ah, 0xAA        ; all new 32-bit ready string-int operation
    je intToString32

    cmp ah, 0xAB
    je intToHexString32

    cmp ah, 0xAC        ; read a character using the 8042 keyboard controller
    je readChar         ; this functions does not use interrupts and is therefor
                        ; protected mode ready

    cmp ah, 0xE1
    je com1_sendByte

    cmp ah, 0xE2
    je com1_sendMessage

    cmp ah, 0xF0        ; initalize the memory for the allocator
    je initMemory

    cmp ah, 0xF1        ; allocate a 1kb memory page
    je allocPage

    cmp ah, 0xF2        ; free a 1kb memory page
    je freePage

    cmp ah, 0xFF        ; debug function, just prints the values of registers eax, ebx, ecx and edx
    je addressDebug
    
    iret

%include "fat12.asm"
%include "common.asm"
%include "language.asm"
%include "strings.asm"

%include "system_int2str.asm"
%include "system_str2int.asm"
%include "system_flt2str.asm"
%include "system_str2flt.asm"
%include "system_print.asm"
%include "system_hexstr.asm"
%include "system_diskIO.asm"
%include "system_cursor.asm"
%include "system_datetime.asm"
%include "system_userIO.asm"
%include "system_environment.asm"
%include "system_sleep.asm"
%include "system_memory.asm"
%include "system_keyboard.asm"
%include "system_serial.asm"

col db 0x00
row db 0x06

addressDebug:
%ifdef DEBUG
    pushf
    pushad
    
    ; ==================================
    ; print edx
    mov ecx, edx
    mov edx, .string
    call private_intToString32
    
    mov bl, 0x07
    mov edx, .string
    call private_printString
    
    ; newline
    mov bl, 0x07
    mov edx, NEWLINE
    call private_printString
    ; ==================================
    
    popad
    popf
%endif
    iret
%ifdef DEBUG
.string: times 20 db 0x00
%endif

; ======================================================
; exits the current program and jumps back to cli
; ======================================================
exitProgram:
    mov word [ERROR_CODE], bx
    
    mov dh, byte [row]  ; move cursor to the left
    mov dl, 0x00        
    call private_setCursorPosition

    ; load /SYSTEM/
    call private_getRootDir
    mov dx, .systemDir
    call private_loadDirectory

    ; load /SYSTEM/COMMAND.BIN
    xor bp, bp
    mov ebx, SOFTWARE_BASE
    mov dx, .fileName
    call private_loadFile
 
    or ax, ax
    jnz .error
    
    cli
    
    xor bx, bx
    mov ax, -1
    mov es, bx
    mov ds, bx
    mov gs, bx
    mov fs, bx
    
    sti
    
    jmp 0x0000:SOFTWARE_BASE
.error:
    cli
    hlt
.fileName  db "COMMAND BIN", 0x00
.systemDir db "SYSTEM", 0x00
; ======================================================


; ======================================================
; DX <= filename
; ES:DI <= argument string to pass
; ======================================================
startProgram:
    ; if the first byte of the argument is \0
    ; there is not argument to be passed
    cmp word [es:di], 0x00
    je .hasNoArgument
    
    mov si, di
    mov di, .argumentTemp

    mov cx, 64
    rep movsb
    mov byte [.hasArgument], TRUE
    jmp .copyDone
.hasNoArgument:
    mov byte [.hasArgument], FALSE
.copyDone:
    mov byte [edi], 0x00
    mov si, dx              ; check that filename has .BIN extension
    cmp byte [esi+8], 'B'
    jne .noExecutableError
    cmp byte [esi+9], 'I'
    jne .noExecutableError
    cmp byte [esi+10], 'N'
    jne .noExecutableError
    
    mov bx, SOFTWARE_BASE ; load the program into memory
    xor bp, bp
    call private_loadFile
    
    cmp ax, 0   ; if the file can not be load its an error
    jne .error
    
    add esp, 6  ; remove stack pointers created by interrupt instruction, we do not need this

    sti

    xor bx, bx
    mov es, bx
    mov ds, bx
    mov fs, bx
    mov gs, bx

    cli

    cmp byte [.hasArgument], TRUE
    je .setArgument
    mov ax, -1
    jmp .argumentOK
.setArgument:
    mov ax, .argumentTemp
.argumentOK:
    jmp 0x0000:SOFTWARE_BASE   ; start programm
    
.noExecutableError:
    mov ax, 0x01
    stc

    iret
    
.error:
    stc
    mov ax, 0x02
    iret
.hasArgument db FALSE
.argumentTemp times 65 db 0x00
; ======================================================


; ======================================================
; compares two strings
; ES:DI => string 1
; DS:SI => string 2
; AL <= 0 equal, 1 not equal
; ======================================================
compareString:
    xor al, al
.Loop:
    lodsb
    scasb
    jne .NotEqual
    test al, al
    jnz .Loop
.Equal:
    mov al, TRUE
    iret
.NotEqual:
    mov al, FALSE
    iret
; ======================================================


; ======================================================
; generate a pseudo random number based on a 
; linear congruential generator. Do NOT use this
; for security relevant stuff, but for graphical
; demos its fine
; ======================================================
random:
    push eax
    push ebx
    push edx
    xor edx, edx
    mov eax, 24298
    mov ebx, dword [.lastX]
    mul ebx
    mov ebx, 199017
    div ebx
    mov dword [.lastX], edx
    mov ecx, edx
    pop edx
    pop ebx
    pop eax
    iret
.lastX dd 125
; ======================================================
