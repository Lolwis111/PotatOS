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
    
    ; we only read in the first fat as the second is just a copy
    ; so we dont have to calculate how big the fat section actually is
	mov cx, word [SectorsPerFAT] 
    mov ax, word [ReservedSectors]

    mov bx, FAT_SEGMENT
	mov es, bx
    xor bx, bx
	call ReadSectors
	
    pop ds
	pop es
	popa
	ret
; ==================================================