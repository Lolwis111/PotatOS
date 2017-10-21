%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start   ; goto start

%include "language.asm"
%include "functions.asm"

%include "commands.asm"

%include "strings.asm"
%include "common.asm"
%include "screen.asm"

%include "include/command_datetime.asm"
%include "include/command_util.asm"
%include "include/command_screen.asm"
%include "include/command_file.asm"

fileName times 13 db 0x00 ; filename, 'human' format (DUMMY.BIN)
rFileName times 11 db 0x20
                   db "\n\r"
                   db 0x00 ; filename, 'fat12' format (DUMMY    BIN)

ready db "CMD> ", 0x00

start:  ; just print a newline so old ready is 100% sure on its own line
    print NEWLINE
    
main:
    call clearBuffer ; clear all the buffers
    
    print ready ; print CMD>
    
    readline inputBuffer, 64 ; read user input
    
    mov si, inputBuffer ; convert it to all upper case letters
    call UpperCase
    
    call parseCommands ; parse the command (extract arguments)

    strcmp command, cmdLS
    je view_dir ; command_file

    strcmp command, cmdCD
    je change_directory ; command_file
    
    strcmp command, cmdHELP
    je view_help ; command_util
    
    strcmp command, cmdTIME
    je show_time ; command_datetime
    
    strcmp command, cmdDATE
    je show_date ; command_datetime
    
    strcmp command, cmdINFO
    je show_version ; command_util

    strcmp command, cmdCOLOR
    je change_color ; command_screen
    
    strcmp command, cmdCLEAR
    je clear_screen ; command_screen
    
    strcmp command, cmdRENAME
    je rename_file ; command_file

    strcmp command, cmdDEL
    je delete_file ; command_file
    
    strcmp command, cmdRETURN
    je print_return_code ; command_util
    
    jmp look_extern
    
    ; jmp main
; ====================================================


; ====================================================
; reads up to the first space and puts that into command
; puts everything after the space into argument
; ====================================================
parseCommands:
    cld
    mov si, command
    call UpperCase
    
    mov si, inputBuffer
    mov di, command
    xor cx, cx
.skipLoop:
    lodsb
    inc cx
    cmp al, 0x20    ; spaces
    je .copy
    cmp al, 0x00
    je .return
    mov byte [di], al
    inc di
    jmp .skipLoop
.copy:
    mov di, argument ; get everything after the first space
    mov ax, 64          ; and use that as argument (up to 64 characters)
    sub ax, cx
    mov cx, ax
    rep movsb   
.return:
    ret
; ====================================================


; ====================================================
; clears all the input buffers
; ====================================================
clearBuffer:
    push si
    push di
    push bp

    mov cx, 64
    mov di, command     ; clear command
    mov si, argument ; args to command
    mov bp, inputBuffer ; and buffer
.Loop1:
    mov byte [di], 0x00 ; just set everything to zeros
    mov byte [bp], 0x00
    mov byte [si], 0x00
    inc di
    inc si
    inc bp

    dec cx
    jnz .Loop1

    mov cx, 11          ; clear the filename too
    mov di, rFileName
.Loop2 :
    mov byte [di], 0x00
    inc di
    dec cx
    jnz .Loop2

    pop bp
    pop di
    pop si

    ret
; ====================================================

inputBuffer   times 64 db 0x00
argument      times 64 db 0x00
command       times 64 db 0x00
commandLength dw 0x0000