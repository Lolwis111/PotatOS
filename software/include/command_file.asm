%include "bpb.asm"
%include "floppy/readsectors.asm"
%include "floppy/lba.asm"
%include "fat12/fat.asm"
%include "fat12/readdirectory.asm"
%include "fat12/root.asm"

%include "command_changeDirectory.asm"

; ====================================================
; print the current working directory
; ====================================================
print_working_directory:
    PRINT NEWLINE

    PRINT CURRENT_PATH
    
    PRINT NEWLINE
    
    PRINT NEWLINE
    
    jmp main
; ====================================================

; ====================================================
; deletes a file
; ====================================================
delete_file:
    mov si, argument
    mov di, rFileName
    call AdjustFileName
    cmp ax, -1
    je .notFound
    
    mov si, rFileName
    call check_invalid_filename
    jc .invalidFileName
    
    FINDFILE rFileName

    ;mov ah, 0x13
    ;mov dx, rFileName
    ;int 0x21
    cmp ax, -1
    je .notFound
    
    mov ah, 0x0A
    mov dx, rFileName
    int 0x21
    
.return:
    PRINT NEWLINE
    jmp main
.invalidFileName:
    PRINT WRITE_PROTECTION_ERROR
    jmp .return
.notFound:
    PRINT FILE_NOT_FOUND_ERROR
    jmp .return
; ====================================================
    

; ====================================================
; Benennt eine Datei um 
; ====================================================
rename_file:
    mov di, .rArgument
    xor ax, ax
    mov cx, 12
    rep stosw

    mov si, argument
    call fileNameLength
    push cx
    mov si, argument
    mov di, fileName
    rep movsb
    
    mov si, fileName
    mov di, rFileName
    call AdjustFileName
    cmp ax, -1
    je .notFound
    
    call check_invalid_filename
    jc .invalidFileName
    
    pop cx
    mov si, argument
    add si, cx
    mov di, fileName
    inc si
.copyLoop:
    cmp byte [si], 0x00
    je .done
    movsb
    jmp .copyLoop
    
.done:
    mov si, fileName
    mov di, .rArgument
    call AdjustFileName
    cmp ax, -1
    je .notFound
   
    FINDFILE .rArgument
    ;mov ah, 0x13
    ;mov dx, .rArgument
    ;int 0x21
    cmp ax, -1
    jne .badFileName
    
    mov ah, 0x11
    int 0x21
    mov di, bp
.fileLoop:
    push cx
    mov si, rFileName
    mov cx, 11
    push di
    rep cmpsb
    pop di
    je .Found
    pop cx
    add di, 32
    loop .fileLoop
    
.notFound:
    PRINT FILE_NOT_FOUND_ERROR
    jmp .return
    
.badFileName:
    PRINT FILE_ALREADY_EXISTS_ERROR
    jmp .return
    
.invalidFileName:
    PRINT WRITE_PROTECTION_ERROR
    jmp .return
    
.Found:
    pop cx
    mov si, .rArgument
    mov cx, 11
    rep movsb
    mov ah, 0x12
    int 0x21
.return:
    PRINT NEWLINE
    jmp main
.rArgument times 13 db 0x00
; ====================================================


; ====================================================
; si <= filename to check
; Carry flag =0 ok, =1 error
; ====================================================
check_invalid_filename:
    pusha
    
    mov bp, si
    mov di, .invalidFiles
    mov cx, 11
    rep cmpsb
    je .invalid
    
    mov si, bp
    mov di, .invalidFiles+11
    mov cx, 11
    rep cmpsb
    je .invalid

    mov si, bp
    mov di, .invalidFiles+22
    mov cx, 11
    rep cmpsb
    je .invalid
    
    mov si, bp
    mov di, .invalidFiles+33
    mov cx, 11
    rep cmpsb
    je .invalid
    
    popa
    clc
    ret
.invalid:
    popa
    stc
    ret
; this are the most important files that are hardcoded not 
; delete- or renameable
.invalidFiles db "MAIN    SYSIRQ     SYSSYSTEM  SYSLOADER  SYS"
; ====================================================


; ====================================================
; tries to launch the command as a file
; ====================================================
look_extern:
    PRINT NEWLINE

    mov al, '.'
    mov si, command
    call StringLength

    cmp cx, 0x00
    je .noExt
    
    mov si, command
    add si, cx
    mov di, .programExt
    mov cx, 4
    repe cmpsb
    jne .eError
    jmp .extOk
    
.programExt db ".BIN"
    
.noExt: ; if there is no extension add .bin and try loading that
    xor al, al
    mov si, command
    call StringLength
    
    mov si, command
    add si, cx
    mov byte [si], '.'
    mov byte [si+1], 'B'
    mov byte [si+2], 'I'
    mov byte [si+3], 'N'
    
.extOk:
    mov si, command
    mov di, rFileName
    call AdjustFileName
    cmp ax, -1
    je .error

    EXECUTE rFileName, argument

    cmp ax, 0x01
    je .eError
    jmp .error
.error: ; generell error
    PRINT LOAD_ERROR
    ret
.eError: ; not a bin file error
    PRINT NO_PROGRAM
    ret
; ====================================================
