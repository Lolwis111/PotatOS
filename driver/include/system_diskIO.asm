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
    xor ax, ax
    mov si, dx
    call ReadDirectory
    ret
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
getRootDir:
    call LoadRoot
    mov cx, word [RootEntries]
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
