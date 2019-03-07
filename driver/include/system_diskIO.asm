%define __CHAR_BACKSLASH 0x2F
; ======================================================
; loads a file into memory
; BP:EBX <= target buffer
; DX <= filename
; AX => error code (0 = OK, -1 = ERROR)
; ECX => size
; ======================================================
private_loadFile: ; basically a wrapper for fat12.asm
    xor ax, ax
    mov si, dx
    call ReadFile
    ret
    
loadFile:
    call private_loadFile
    iret
private_loadFileEntry:
    xor ax, ax
    mov si, dx
    call ReadFile.customDirectory
    ret
loadFileEntry:
    call private_loadFileEntry
    iret
; ======================================================


; ======================================================
private_loadDirectory:
    mov si, dx

    push si

    mov di, .directoryName
    mov cx, 11
    mov al, 0x20
    rep stosb
    
    call StringLength2
    mov word [.directoryNameLength], cx
    cmp cx, 0
    je .done

    pop si

    mov di, .directoryName
    rep movsb
    
    mov si, .directoryName
    call ReadDirectory
    jc .error

    ; special directories get handled here
    ; .  - points to current directory
    ; .. - points to parent directory
    cmp byte [ds:si], '.'
    je .checkNextDot

    cmp byte [ds:si], __CHAR_BACKSLASH
    je .loadRoot
    
    jmp .appendPath
.checkNextDot: ; check if '..' was given
    cmp byte [ds:si+1], '.'
    je .checkNextDot2 ; chek the second dot
    cmp byte [ds:si+1], 0x00 ; check if '.' was given
    je .done              ; no adjustment needed if yes
.checkNextDot2:
    cmp byte [ds:si+2], 0x00   ; check if '..' was given
    je .goToParentDirectory ; remove the trailing directory from WD
    cmp byte [ds:si+2], 0x20
    je .goToParentDirectory
.appendPath:
    mov cx, word [.directoryNameLength]
    add word [CURRENT_PATH_LENGTH], cx ; add the length
    mov di, CURRENT_PATH ; append the directory to the path
    call AppendString

    mov di , CURRENT_PATH ; set the trailing /
    add di, word [CURRENT_PATH_LENGTH]
    mov byte [di-1], __CHAR_BACKSLASH
    mov byte [di], 0x00
    inc word [CURRENT_PATH_LENGTH]

    jmp .done
.loadRoot:
    cmp byte [ds:si+1], 0x00
    jne .done
    call private_getRootDir
    jmp .done
; delete trailing directory from path
; /test/abc/ -> /test/
.goToParentDirectory:
    cmp word [CURRENT_PATH_LENGTH], 2
    jbe .done
    mov si, CURRENT_PATH
    add si, word [CURRENT_PATH_LENGTH]
    dec si
    mov byte [ds:si], 0x00 ; remove last /
.removeLoop:
    ; go backwards until we encounter / again
    cmp byte [ds:si], __CHAR_BACKSLASH
    je .done
    mov byte [ds:si], 0x00 ; put a \0 byte into the old positions
    dec si
    dec word [CURRENT_PATH_LENGTH] ; adjust length
    jmp .removeLoop
.done:
    clc
    ret
.error:
    stc
    ret
.directoryNameLength dw 0x0000
.directoryName times 11 db 0x20
                        db 0x00
loadDirectory:
    call private_loadDirectory
    iret
; ======================================================



; ======================================================
; DX <= file
; CX <= size in byte
; BX:BP <= buffer
; ======================================================
writeFile:
    ; TODO: WriteFile rewrite
    ;mov si, dx
    ;call WriteFile
;.return:
    iret
; ======================================================


; ======================================================
; AX -> load root dir
; ======================================================
private_getRootDir:
    push ds
    push ax
    xor ax, ax
    mov ds, ax

    call LoadRoot
    mov cx, word [RootEntries]

    mov word [ds:CURRENT_PATH_LENGTH], 2
    mov byte [ds:CURRENT_PATH], __CHAR_BACKSLASH
    mov byte [ds:CURRENT_PATH+1], 0x00

    pop ax
    pop ds

    ret
getRootDir:
    call private_getRootDir
    iret
; ======================================================


; ======================================================
; AX -> save root dir
; ======================================================
setRootDir:
    ; TODO: WriteRoot/WriteDir
    ; call WriteRoot
    iret
; ======================================================


; ======================================================
; deletes a file
;
; DX <= Dateiname
; ======================================================
deleteFile:
    ; TODO: rework delete file
    
    ; mov si, dx
    ; call DeleteFile
    
    iret
; ======================================================


; ======================================================
; searches for a file in the root directory
;
; DX => filename
; AX <= -1 not found, else: index in root dir
; ======================================================
findFile:
    mov si, dx
    call FindFile
    
    iret
; ======================================================
