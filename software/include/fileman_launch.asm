
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
    call clearScreen

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


