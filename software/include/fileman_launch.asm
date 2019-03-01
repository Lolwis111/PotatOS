
; ================================================
launch_file:
    ; calculate which file we want to load from the selectedIndex
    ; ADDR = (selectedIndex + entriesToSkip) * 32
    movzx ax, byte [selectedIndex]
    movzx bx, byte [entriesToSkip]
    xor dx, dx
    add ax, bx
    ; mov bx, 32
    mov si, DIRECTORY_OFFSET
    ; mul bx
    shl ax, 5 ; multiply by 32=2^5
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
    PRINT .err1, TEXT_COLOR
    jmp main
.err1 db "!", 0x00

; txt files should be given as argument to edit.bin
.noBin:
    cmp byte [.fileName+8], 'T'
    jne .noTXT
    cmp byte [.fileName+9], 'X'
    jne .noTXT
    cmp byte [.fileName+10], 'T'
    jne .noTXT
    
    ; convert the dot file name back
    ; to raw fat12 filename
    mov si, .fileName
    call ReadjustFileName
    
    mov dx, .editBIN
    jmp .launch

; llp files should be given to viewer.bin 
.noTXT:
    cmp byte [.fileName+8], 'L'
    jne .nonExecutable
    cmp byte [.fileName+9], 'L'
    jne .nonExecutable
    cmp byte [.fileName+10], 'P'
    jne .nonExecutable
    
    ; convert the dot file name back
    ; to raw fat12 filename
    mov si, .fileName
    call ReadjustFileName
    
    mov dx, .viewerBIN
    
.launch:
    call clearScreen
    call restoreDir
    call restoreSegments

    mov ah, 0x17
    int 0x21
   
    ; we should never get here,
    ; 0x17 should start a new process
    ; but you never know
    cmp ax, 0x00
    jne .error
    jmp main

.nonExecutable:
    ; display an error message when the
    ; file cant be executed in this context
    mov si, NO_PROGRAM 
    call drawBox
    jmp main.scrollOK

.loadDirectory:
    ; load the directory
    LOADDIRECTORY .fileName
    cmp ax, NO_ERROR
    jne .error

    ; reset the gui
    mov byte [entriesToSkip], 0x00
    mov byte [selectedIndex], 0x00
    
    ; count the files of the new directory
    call countFiles

    jmp main.scrollOK
    
.fileName times 12 db 0x00
.editBIN   db "EDIT    BIN", 0x00
.viewerBIN db "VIEWER  BIN", 0x00
; ================================================


