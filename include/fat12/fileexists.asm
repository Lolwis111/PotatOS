; ======================================
; Checks if a file with that name exists
; SI <= filename
;
; AX => True/False
; ======================================
FileExists:
    call FindFile

    cmp ax, -1
    je .no

    mov ax, TRUE
    ret
.no:
    mov ax, FALSE
    ret
; ======================================
