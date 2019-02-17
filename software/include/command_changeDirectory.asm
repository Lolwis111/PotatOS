; ====================================================
change_directory:
    pusha
    push es
    push ds
    
    xor ax, ax
    mov es, ax
    mov ds, ax
    
    mov cx, 6
    mov di, .directoryName
    mov ax, 0x2020
    rep stosw
    mov byte [.directoryName+11], 0x00
    
    mov si, argument
    
    mov byte [.directoryDoubleDot], 0x00
    
.argumentPassed:
    cmp byte [ds:si], '/' ; the command cd / changes to the root directory
    je .loadRootDirectory
    
    cmp byte [ds:si], '.'       ; ignore directory . here
    jne .notSingleDot           ; as it points to the current directory
    cmp byte [ds:si+1], 0x00
    jne .notSingleDot
    
    print NEWLINE
    
    jmp .return
    
.notSingleDot:
    cmp byte [ds:si], '.'       ; handle directory .. a little different
    jne .normalDir
    cmp byte [ds:si+1], '.'
    jne .normalDir
    
    mov byte [.directoryDoubleDot], 0x01
    
.normalDir:
    mov di, .directoryName
.copyLoop:
    cmp byte [ds:si], 0x00 ; copy the name from the argument to .directoryName
    je .done            ; (.directoryName is filled with spaces so we basically
                        ; do padding)
    movsb
    jmp .copyLoop
.done:
    mov si, .directoryName
    call ReadDirectory ; try to read a directory with given name
    jc .error
    
    cmp byte [.directoryDoubleDot], 0x00 ; when .. is entered we have to 
    je .addToPath ; remove chars from the path
    
    mov si, CURRENT_PATH
    add si, word [CURRENT_PATH_LENGTH]
    dec si
    mov byte [ds:si], 0x00
    dec word [CURRENT_PATH_LENGTH]
.removeLoop:
    cmp byte [ds:si], '/' ; delte the trailing directory (/TEST/ABC/ -> /TEST/)
    je .removeDone
    mov byte [ds:si], 0x00
    dec si
    dec word [CURRENT_PATH_LENGTH]
    jmp .removeLoop
.removeDone:
    jmp .okay
 
.addToPath:
    mov si, .directoryName ; trim trailing spaces
    call TrimRight
    
    mov si, .directoryName ; calculate length
    call StringLength2
    
    mov si, .directoryName ; append /
    add si, cx
    mov byte [ds:si], '/'
    mov byte [ds:si+1], 0x00
    inc cx
    
    add word [CURRENT_PATH_LENGTH], cx ; update length
    
    mov di, CURRENT_PATH
    mov si, .directoryName
    call AppendString ; append the directory name to the path

.okay:
    print NEWLINE
    
    jmp .return
.loadRootDirectory:
    call LoadRoot ; load the root directory
    jc .error
    
    mov di, CURRENT_PATH ; override the path with zeroes
    mov cx, 256
    xor ax, ax
    rep stosw
    
    mov word [CURRENT_PATH_LENGTH], 0x01 ; root is just pwd /
    mov byte [CURRENT_PATH], '/'
    
    print NEWLINE
    
    jmp .return
.error:
    cmp ax, FILE_NOT_FOUND
    je .fileNotFound
    cmp ax, NOT_A_DIRECTORY
    je .notADirectory
    jmp .return
.fileNotFound:
    print DIRECTORY_NOT_FOUND_ERROR
    jmp .return
.notADirectory:
    print NOT_A_DIRECTORY_ERROR
    jmp .return
.return:
    pop ds
    pop es
    popa
    jmp main
.directoryName times 11 db 0x20
                        db 0x00, 0x00
.directoryDoubleDot db 0x00
; ====================================================
