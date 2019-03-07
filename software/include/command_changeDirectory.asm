; ====================================================
change_directory:
    pusha
    
    LOADDIRECTORY argument
    jc .error

    jmp .return
.error:
    cmp ax, FILE_NOT_FOUND_ERROR
    je .fileNotFound
    cmp ax, NOT_A_DIRECTORY_ERROR
    je .notADirectory
    jmp .return
.fileNotFound:
    PRINT DIRECTORY_NOT_FOUND_ERROR
    jmp .return
.notADirectory:
    PRINT NOT_A_DIRECTORY_ERROR
    jmp .return
.return:
    popa

    PRINT NEWLINE
    
    jmp main
; ====================================================
