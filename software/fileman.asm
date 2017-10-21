%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start


; ================================================
%include "functions.asm"
%include "strings.asm"
%include "keys.asm"
%include "language.asm"

%include "bpb.asm"

%define BORDER_COLOR createColor(BLUE, BLACK)
%define TEXT_COLOR createColor(MAGENTA, BLACK)
%define SELECTION_COLOR createColor(BLACK, WHITE)

titleString      db "FILEMAN", 0x00

%include "include/fileman_util.asm"
%include "include/fileman_gui.asm"

fileName times 13 db 0x00
fileSizeString times 11 db 0x00
fileEntryLine times 60 db 0x20
                       db 0x00
selectedIndex db 0x00
fileCount db 0x00
entriesToSkip db 0x00
; ================================================


; ================================================
clearContentBox:
    mov di, cursorPos(1, 1)
    mov cx, SCREEN_HEIGHT-2
.loopY:
    push cx
    mov cx, SCREEN_WIDTH-2
    .loopX:
        mov byte [gs:di], 0x20
        mov byte [gs:di+1], TEXT_COLOR
        add di, 2
        loop .loopX
    add di, 4
    pop cx
    loop .loopY
    ret
; ================================================


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
start:
    mov ax, VIDEO_TEXT_SEGMENT   ; set gs to point to the video memory
    mov gs, ax

    mov dl, 0x20
    mov dh, BORDER_COLOR
    call clearScreen
    
    call drawBorder
    
    call countFiles
    
    call clearContentBox
    call printFiles
    
    call drawCursor
    
    jmp main
; ================================================
    
    
; ================================================
printFiles:
    pusha
    push es
    push ds
    
    xor ax, ax
    mov es, ax
    mov ds, ax
    mov si, DIRECTORY_OFFSET
    
    xor dx, dx
    movzx ax, byte [entriesToSkip]
    mov bx, 32
    mul bx
    add si, ax
    
    mov di, cursorPos(5, 1)
    
    xor cx, cx
.fileLoop:
    cmp byte [es:si], 0x00
    je .endOfDir
    
    cmp byte [es:si], 0xE5
    je .skip
    
    push si
    push cx
    push di
    
    mov cx, 30
    mov ax, 0x2020 ; override fileEntryLine with spaces
    mov di, fileEntryLine
    rep stosw
    
    mov al, byte [es:si+11]     ; copy attributes
    mov byte [.attributes], al
    
    call ReadjustFileName
    add si, 11
    
    test byte [.attributes], 00010000b ; check if it is a directory
    jz .nameOK

.directoryName:
    push di
    mov cx, 11
    mov al, '.'
    repnz scasb     ; try to find the dot
    jcxz .nameOKpop ; if no dot is found its ok
    
    cmp byte [di], 0x20 ; if there are chars after dot its ok too
    jne .nameOKpop
    
    mov byte [di-1], 0x20 ; but else we delete the dot
    
.nameOKpop:
    pop di
.nameOK:
    push si
    
    mov si, di
    mov di, fileEntryLine
.copyLoop1:
    lodsb
    or al, al
    jz .copy1ok
    stosb
    jmp .copyLoop1
    
.copy1ok:
    pop si
    
    pop di    
    
    mov al, byte [es:si] ; copy the attributes
    mov byte [.attributes], al
    
    ltostr fileSizeString, dword [es:si+17]
    
    push si
    push di
    
    mov ax, word [es:si+13]
    push word [es:si+11]
    
    call convertDate
    mov di, fileEntryLine+33
    mov cx, 10
    rep movsb
    
    pop ax
    call convertTime
    mov di, fileEntryLine+44
    mov cx, 8
    rep movsb
    
    test byte [.attributes], 00010000b ; check if it is a directory
    jnz .directory 
    
    mov di, fileEntryLine+20
    mov si, fileSizeString
.copyLoop:
    lodsb
    cmp al, 0x00
    je .ok
    stosb
    jmp .copyLoop
    
.directory:
    mov dword [fileEntryLine+20], '<DIR'
    mov byte [fileEntryLine+24], '>'
    
.ok:
        
    pop di
        
    mov ah, TEXT_COLOR
    mov si, fileEntryLine
    call printString
    
    pop si
    
    pop cx
    inc cx
    
    add di, (SCREEN_WIDTH*2)
    
    pop si
    
    cmp cx, 23
    je .endOfDir
    
.skip:
    add si, 32
    
    jmp .fileLoop
.endOfDir:
    pop ds
    pop es
    popa
    ret
.attributes db 0x00
; ================================================
    
    
; ================================================
; cl Color
; bx Index
; ================================================
drawCursor:
    push di
    
    mov di, cursorPos(1, 1)
    
    xor dx, dx
    mov ax, (SCREEN_WIDTH*2)
    movzx bx, byte [selectedIndex]
    mul bx
    add di, ax
    
    inc di
    
    mov cx, 60
.loop:
    mov byte [gs:di], SELECTION_COLOR
    add di, 2
    dec cx
    jnz .loop
    
    pop di
    ret
; ================================================
    
    
; ================================================
main:
    xor ax, ax
    int 0x16
    
    cmp ah, KEY_UP
    je .scrollUp
    
    cmp ah, KEY_DOWN
    je .scrollDown
    
    cmp ah, KEY_ESCAPE
    je exit
    
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
launch_file:
    movzx ax, byte [selectedIndex]  ; calculate which file we want to load from the selectedIndex
    movzx bx, byte [entriesToSkip]
    xor dx, dx
    add ax, bx
    mov bx, 32
    mov si, DIRECTORY_OFFSET
    mul bx
    add si, ax
    
    mov cx, 11 ; copy the file name
    mov di, .fileName
    rep movsb
    
    test byte [si], 00010000b ; check if the entry is an directory
    jnz .loadDirectory
    
    cmp byte [.fileName+8], 'B'
    jne .noBin
    cmp byte [.fileName+9], 'I'
    jne .noBin
    cmp byte [.fileName+10], 'N'
    jne .noBin
    
    mov dx, .fileName
    mov di, -1
    jmp .launch

.error:
    ; TODO: print an error message
    print .err1, TEXT_COLOR
    jmp main
.err1 db "!", 0x00
.noBin:
    cmp byte [.fileName+8], 'T'
    jne .noTXT
    cmp byte [.fileName+9], 'X'
    jne .noTXT
    cmp byte [.fileName+10], 'T'
    jne .noTXT
    
    mov si, .fileName
    call ReadjustFileName
    
    mov dx, .editBIN
    jmp .launch
    
.noTXT:
    cmp byte [.fileName+8], 'L'
    jne main
    cmp byte [.fileName+9], 'L'
    jne main
    cmp byte [.fileName+10], 'P'
    jne main
    
    mov si, .fileName
    call ReadjustFileName
    
    mov dx, .viewerBIN
    
.launch:
    mov ah, 0x17
    int 0x21
    
    cmp ax, 0x00
    jne .error
    jmp main
    
.loadDirectory:
    
    loadfile .fileName, DIRECTORY_OFFSET
    cmp ax, -1
    je .error
    
    mov byte [entriesToSkip], 0x00
    mov byte [selectedIndex], 0x00
    
    jmp main.scrollOK
    
.fileName times 12 db 0x00
.editBIN   db "EDIT    BIN", 0x00
.viewerBIN db "VIEWER  BIN", 0x00
; ================================================


; ================================================
exit:
    mov dl, 0x20
    mov dh, byte [SYSTEM_COLOR]
    call clearScreen
    
    EXIT EXIT_SUCCESS
; ================================================