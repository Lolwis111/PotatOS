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
%include "fat12/file.asm"

%include "include/command_datetime.asm"
%include "include/command_util.asm"
%include "include/command_screen.asm"
%include "include/command_file.asm"
%include "include/command_fileInfo.asm"
%include "include/command_viewDirectory.asm"
%include "include/command_cpuid.asm"
fileName times 13 db 0x00 ; filename, 'human' format (DUMMY.BIN)
rFileName times 11 db 0x20
                   db "\n\r"
                   db 0x00 ; filename, 'fat12' format (DUMMY    BIN)

%define BUFFER_LENGTH 64

ready db "CMD> ", 0x00

start:
    ; just PRINT a newline so old ready is 100% sure on its own line
    PRINT NEWLINE
    
main:
    cld
    call clearBuffer ; clear all the buffers
    
    PRINT ready ; print CMD>
    
    READLINE inputBuffer, BUFFER_LENGTH ; read user input
    
    mov si, inputBuffer ; convert it to all upper case letters
    call UpperCase
    
    cld
    call parseCommands ; parse the command (extract arguments)

    STRCMP command, cmdLS
    je viewDirectory ; command_file

    STRCMP command, cmdCD
    je change_directory ; command_file
    
    STRCMP command, cmdHELP
    je view_help ; command_util
    
    STRCMP command, cmdTIME
    je show_time ; command_datetime
    
    STRCMP command, cmdDATE
    je show_date ; command_datetime
    
    STRCMP command, cmdINFO
    je show_version ; command_util

    STRCMP command, cmdCOLOR
    je change_color ; command_screen
    
    STRCMP command, cmdCLEAR
    je clear_screen ; command_screen
    
    STRCMP command, cmdRENAME
    je rename_file ; command_file

    STRCMP command, cmdDEL
    je delete_file ; command_file
    
    STRCMP command, cmdPWD
    je print_working_directory ; command_file
    
    STRCMP command, cmdRETURN
    je PRINT_return_code ; command_util

    STRCMP command, cmdFILE
    je PRINT_file_info  ; command_fileInfo

    call look_extern

    jmp main
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
    mov di, argument      ; get everything after the first space
    mov ax, BUFFER_LENGTH ; and use that as argument (up to 64 characters)
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
    push di
    push cx
    cld

    xor ax, ax
    mov cx, BUFFER_LENGTH
    mov di, command
    rep stosb
    mov cx, BUFFER_LENGTH
    mov di, argument
    rep stosb
    mov cx, BUFFER_LENGTH
    mov di, inputBuffer
    rep stosb
    mov cx, 11
    mov di, rFileName
    rep stosb

    pop cx
    pop di
    ret
; ====================================================

inputBuffer   times BUFFER_LENGTH db 0x00
argument      times BUFFER_LENGTH db 0x00
command       times BUFFER_LENGTH db 0x00
commandLength dw 0x0000
