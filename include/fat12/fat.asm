; ==================================================
;LoadFAT()
;   load the fat
; ==================================================
LoadFAT:
	pusha
	push es
    push ds
	
    xor ax, ax
    mov ds, ax
    mov es, ax
    
	movzx ax, byte [NumberOfFATS]
	
	mul word [SectorsPerFAT]
	mov cx, ax
	
    mov ax, word [ReservedSectors]

    mov bx, DIRECTORY_SEGMENT
	mov es, bx
    xor bx, bx
	call ReadSectors
	
    pop ds
	pop es
	popa
	ret
; ==================================================