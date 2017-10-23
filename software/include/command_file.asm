; ====================================================
; lists all the files in the root directory
; (including sizes)
; ====================================================
view_dir:
    pusha
    push es
    push ds
    
    mov dword [.fileSize], 0x00  ; init size to zero
    print NEWLINE
    
    print LS_LABEL_1 ; print Label1 (see language.asm)
    print .spacer
    
    mov si, DIRECTORY_OFFSET
    xor ax, ax
    mov es, ax
    mov ds, ax
    cld
.fileLoop:
    push cx

    mov di, fileName            ; the first 11 bytes of each entry are the file name
    mov cx, 11                  ; so we copy that
    rep movsb
    
    mov al, byte [es:si]           ; after that are the attributes
    mov byte [.attributes], al
    
    cmp byte [argument], 0x00 ; check if only certain extensions should be printed
    je .noFilter
    
    push si
    
    mov si, fileName            ; if yes, check the extension on each filename
    mov di, rFileName
    call AdjustFileName         ; convert file name
    
    mov cx, 3
    mov si, rFileName+8         ; check last 3 bytes (8.3 file names in fat12)
    mov di, argument
    rep cmpsb
    jne .skip                   ; if the extension does not match we skip this file
    
    pop si
.noFilter:
    add si, 17
    mov ecx, dword [si]         ; get the filesize from the entry
    add dword [.fileSize], ecx    ; add it to the size of the directory
    push si
    
    cmp byte [fileName], 0xE5 ; check if this is an invalid entry
    je .del
    cmp byte [fileName], 0x00 ; check if this is the last entry
    je .eod

    test byte [.attributes], 00010000b
    jnz .dir ; check if it is a directory
    
    ltostr .number, ecx         ; convert file size to string

    mov si, fileName            ; make filename more readable
    call ReadjustFileName

    print ReadjustFileName.newFileName ; print that "readjusted" filename
    
    mov ah, 0x0F  ; move cursor to X=19 in current row
    int 0x21
    mov dl, 19
    mov ah, 0x0E
    int 0x21

    print .number ; print size in the next column print file size
    jmp .ok
    
.dir:
    print fileName
    print .ldir ; directorys get marked by "<dir>"
    
.ok:
    print NEWLINE ; new line after each entry
    pop si
    jmp .next             ; goto to the next entry
.skip:                    ; this is were we jump if we want to skip an entry
    pop si              
    add si, 17 ; calculate address of next entry (32 bytes per entry)
    jmp .next
.del:
    pop si
.next:
    pop cx
    add si, 4

    dec cx
    jnz .fileLoop
    jmp .end
.eod:
    pop si
    pop cx
.end:
    print LS_LABEL_2 ; print the label about the filesize

    ltostr .number, dword [.fileSize] ; convert directory size to string
    
    print .number ; print directory size
    
    print NEWLINE
    
    pop ds
    pop es
    popa
    jmp main
.number times 11 db 0x00
.spacer times 30 db 205
                 db "\r\n", 0x00
.fileSize dd 0x00000000
.attributes db 0x00
.ldir db "   <DIR>", 0x00
; ====================================================


%include "bpb.asm"
%include "floppy/readsectors.asm"
%include "floppy/lba.asm"
%include "fat12/fat.asm"
%include "fat12/readdirectory.asm"
%include "fat12/root.asm"

; ====================================================
change_directory:
    pusha
    
    mov cx, 6
    mov di, .directoryName
    mov ax, 0x2020
    rep stosw
    mov byte [.directoryName+11], 0x00
    
    mov si, argument
    
    cmp byte [si], '/' ; the command cd / changes to the root directory
    je .loadRootDirectory
    
    mov di, .directoryName
.copyLoop:
    cmp byte [si], 0x00
    je .done
    
    mov al, byte [si]
    mov byte [di], al
    inc si
    inc di
    jmp .copyLoop
.done:
    mov si, .directoryName
    call ReadDirectory
    jc .error
    
    print NEWLINE
    
    popa
    jmp main
.loadRootDirectory:
    call LoadRoot
    jc .error
    
    print NEWLINE
    popa
    jmp main
.error:
    cmp ax, FILE_NOT_FOUND
    je .fileNotFound
    cmp ax, NOT_A_DIRECTORY
    je .notADirectory
    jmp main
.fileNotFound:
    print FILE_NOT_FOUND_ERROR
    jmp main
.notADirectory:
    print NOT_A_DIRECTORY_ERROR
    jmp main
.directoryName times 11 db 0x20
                        db 0x00
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
    
    mov ah, 0x13
    mov dx, rFileName
    int 0x21
    cmp ax, -1
    je .notFound
    
    mov ah, 0x0A
    mov dx, rFileName
    int 0x21
    
.return:
    print NEWLINE
    jmp main
.invalidFileName:
    print WRITE_PROTECTION_ERROR
    jmp .return
.notFound:
    print FILE_NOT_FOUND_ERROR
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
    
    mov ah, 0x13
    mov dx, .rArgument
    int 0x21
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
    print FILE_NOT_FOUND_ERROR
    jmp .return
    
.badFileName:
    print FILE_ALREADY_EXISTS_ERROR
    jmp .return
    
.invalidFileName:
    print WRITE_PROTECTION_ERROR
    jmp .return
    
.Found:
    pop cx
    mov si, .rArgument
    mov cx, 11
    rep movsb
    mov ah, 0x12
    int 0x21
.return:
    print NEWLINE
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
    print NEWLINE

    mov al, '.'
    mov si, command
    call StringLength

    cmp cx, 0x00
    je .noExt
    
    mov si, command
    add si, cx
    mov di, .programExt
    mov cx, 4
    rep cmpsb
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

    mov di, argument
    mov dx, rFileName
    mov ah, 0x17
    int 0x21
    
    cmp ax, 0x01
    je .eError
    jmp .error
db "#ERROR"
.error: ; generell error
    print LOAD_ERROR
    jmp main
db "#EERROR"    
.eError: ; not a bin file error
    print NO_PROGRAM
    jmp main
; ====================================================
