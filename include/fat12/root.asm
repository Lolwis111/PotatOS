; ==================================================
;LoadRoot()
; loads the root directory of a floppy
; to DIRECTORY_OFFSET
; ==================================================
LoadRoot:
    pusha
    push es
    
    ; calculate size in cx
    mov ax, 32
    xor cx, cx  
    xor dx, dx ; set to 0 for div
    mul word [RootEntries] ; RootSizeB = 32 * RootEntries
    div word [BytesPerSector] ; RootSizeS = RootSizeB / BytePerSector
    mov cx, ax

    mov bx, DIRECTORY_SEGMENT
    
    movzx ax, byte [NumberOfFATS]
    mul word [SectorsPerFAT] ; FatSizeS = NumberOfFATS * SectorsPerFAT 
    add ax, word [ReservedSectors] ; Root = FatSizeS + ReservedSectors
    
    ; after calculating size load root at 0xDIRECTORY_SEGMENT:0x0000
    mov es, bx
    xor bx, bx
    call ReadSectors
    
    pop es
    popa
    
    ret
; ==================================================
