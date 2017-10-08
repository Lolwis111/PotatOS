; ======================================================================
; ReadSectors()
;	CX <= sector count
;	AX <= start sector
;	ES:EBX <= target buffer
; ======================================================================
ReadSectors:
    push esi
    push edi
    push ebp
    push edx
    pushf
    
.sectorLoop:
	mov di, 0x0005 ; 5 tries per sector
    .triesLoop:
        push ax
        push ebx
        push cx
	
        call LBA2CHS ; calculate parameters from sector
	
        ; cl = absolute sector
        mov ch, al ; absolute track
        mov dh, dl ; absolute head
        mov dl, byte [DriveNumber]
	
        mov ax, 0x0201 ; read sector
    
        int 0x13 ; read
        jnc .success
	
        xor ax, ax ; reset floppy on error
        int 0x13
	
        dec di ; decrement try counter
	
        pop cx
        pop ebx
        pop ax
	
        cmp di, 0x00 ; and try again
        jnz .triesLoop
	
        int 0x18 ; reboot after 5 fails
    .success:
        pop cx
        pop ebx
        
        movzx eax, word [BytesPerSector] ; advance pointer
        add ebx, eax
        
        pop ax 
    
        inc ax ; go to next sector
	
        loop .sectorLoop ; read CX sectors
        
    popf
    pop edx
    pop ebp
    pop edi
    pop esi
	ret
; ======================================================================