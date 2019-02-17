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
        push bx
        push cx
	
        call LBA2CHS ; calculate parameters from sector
	
        ; cl = absolute sector
        mov ch, al ; absolute track
        mov dh, dl ; absolute head
        mov dl, byte [DriveNumber]
        mov ah, 0x02 ; read sector
        mov al, 0x01 ; only one sector
        int 0x13 ; read
        jnc .success
	
        xor ax, ax ; reset floppy on error
        int 0x13
	
        pop cx
        pop bx
        pop ax
	
        dec di ; decrement try counter and try again
        jnz .triesLoop
	
        int 0x18 ; reboot after 5 fails
    .success:
        pop cx
        pop bx
        
        add bx, word [BytesPerSector]
        
        pop ax 
    
        inc ax ; go to next sector

        dec cx
        cmp cx, 0x00
        jnbe .sectorLoop ; read CX sectors
        
    popf
    pop edx
    pop ebp
    pop edi
    pop esi
	ret
; ======================================================================