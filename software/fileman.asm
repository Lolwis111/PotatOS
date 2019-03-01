%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

; ================================================
%include "functions.asm"
%include "strings.asm"
%include "keys.asm"
%include "chars.asm"
%include "language.asm"
%include "bpb.asm"

%define BORDER_COLOR createColor(BLUE, BLACK)
%define TEXT_COLOR createColor(MAGENTA, BLACK)
%define SELECTION_COLOR createColor(BLACK, WHITE)

titleString db "FILEMAN", 0x00

%include "include/fileman_util.asm"
%include "include/fileman_gui.asm"
%include "include/fileman_launch.asm"
%include "include/fileman_printFiles.asm"

fileName times 13 db 0x00
fileSizeString times 11 db 0x00
selectedIndex db 0x00
fileCount db 0x00
entriesToSkip db 0x00
fileEntryViewer times 32 db 0x00
fileEntryEdit   times 32 db 0x00
; ================================================


; ================================================
; Counts how many files there are in the
; currently loaded directory
; ================================================
countFiles:
    xor ax, ax
    mov si, DIRECTORY_OFFSET
    mov es, ax
    mov byte [fileCount], 0x00
.loop:
    cmp byte [es:si], 0x00
    je .end
    cmp byte [es:si], 0xE5
    je .skip
    inc byte [fileCount]
.skip:
    add si, 32
    jmp .loop
.end:
    ret
; ================================================


; ================================================
; set up environment
; ================================================
initalize:
    ; load the root directory
    mov ah, 0x11
    int 0x21

    LOADDIRECTORY .systemDir

    FINDFILE .viewer

    mov si, DIRECTORY_OFFSET
    shl ax, 5
    add si, ax
    mov di, fileEntryViewer
    mov cx, 16
    rep movsw

    FINDFILE .edit

    mov si, DIRECTORY_OFFSET
    shl ax, 5
    add si, ax
    mov di, fileEntryEdit
    mov cx, 16
    rep movsw

    ret

.systemDir  db "SYSTEM     ", 0x00
.viewer     db "VIEWER  BIN", 0x00
.edit       db "EDIT    BIN", 0x00
; ================================================


; ================================================
start:
    ; save segments and original directory
    call backupSegments
    call backupDir

    call initalize

    call restoreDir
    
    mov ax, VIDEO_TEXT_SEGMENT   ; set gs to point to the video memory
    mov gs, ax

    ; clear the screen
    mov dl, CHAR_SPACE
    mov dh, BORDER_COLOR
    call clearScreen
    
    ; draw the gui
    call drawBorder
    
    ; count the files
    call countFiles
    
    ; render the content
    call clearContentBox
    call printFiles
    
    call drawCursor
    
    jmp main
; ================================================
    
    
; ================================================
main:
    ; read char
    xor ax, ax
    int 0x16
    
    ; scroll up and down
    cmp ah, KEY_UP
    je .scrollUp
    
    cmp ah, KEY_DOWN
    je .scrollDown
    
    ; exit
    cmp ah, KEY_ESCAPE
    je exit
    
    ; try to launch the file
    cmp ah, KEY_ENTER
    je launch_file
    
.scrollOK:
    call clearContentBox
    call printFiles
    
    call drawCursor
    
    jmp main
    
.scrollUp:
    cmp byte [selectedIndex], 0x00
    je .moveUp
    
    dec byte [selectedIndex]
    jmp .scrollOK
.moveUp:
    cmp byte [entriesToSkip], 0x00
    je main
    
    dec byte [entriesToSkip]
    
    jmp .scrollOK
    
.scrollDown:
    mov al, byte [entriesToSkip]
    add al, byte [selectedIndex]

    inc al
    
    cmp al, byte [fileCount]
    je main

    cmp byte [selectedIndex], 22
    je .moveDown
    
    inc byte [selectedIndex]
    jmp .scrollOK
.moveDown:
    inc byte [entriesToSkip]
    jmp .scrollOK
; ================================================


; ================================================
exit:
    mov dl, CHAR_SPACE
    mov dh, byte [SYSTEM_COLOR]
    call clearScreen
    call restoreDir
    call restoreSegments

    EXIT EXIT_SUCCESS
; ================================================

backup db 0x00
