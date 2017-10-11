; ===========================================================
; ReadFile()
;       reads a file from the current directory
;       into the memory
;       SI <= directory name
;       carry flag for error indication
; ===========================================================
ReadDirectory:
    pusha
    push es
    
    mov word [.targetBuffer], 0x0000
    mov word [.targetBuffer+2], DIRECTORY_OFFSET
    
    mov di, si
    mov si, DIRECTORY_OFFSET
    
.findFileLoop:
    cmp byte [si], 0x00
    je .fileNotFound ; if reach the end of the directory the file is not here
    
    push si
    push di
    
    mov cx, 11
    rep cmpsb ; compare the filenames
    je .fileFound ; if it matches we found the file
    
    pop di
    pop si

    add si, 32 ; go to the next entry
    jmp .findFileLoop

.fileFound:
    test byte [si], 00010000b
    jz .notADirectory

    pop di
    pop si

    mov ax, word [si+26]
    mov word [.cluster], ax ; copy start cluster
   
    cmp ax, 0x0000 ; if the first cluster is zero we just load the root directory
    je .loadRoot
    
    
    call LoadFAT ; when we got the entry we load the FAT (this is where the real magic happens)
    
    xor cx, cx ; calculate size of root in cx
    xor dx, dx ; set to 0 for div
    mov ax, 32
    mul word [RootEntries] ; RootSizeB = 32 * RootEntries
    div word [BytesPerSector] ; RootSizeS = RootSizeB / BytePerSector
    mov cx, ax ; cx = RootSizeS

    movzx ax, byte [NumberOfFATS]
    mul word [SectorsPerFAT] ; FatSizeS = NumberOfFATS * SectorsPerFAT 
    add ax, word [ReservedSectors] ; Root = FatSizeS + ReservedSectors
    
    mov word [.dataSector], ax ; data sector = ReservedSectors + FatSizeS + RootSizeS
    add word [.dataSector], cx
    
.clusterLoop:
    mov ax, word [.cluster] ; calcualte the sector from the cluster (result in ax)
    call Cluster2LBA
    add ax, word [.dataSector] ; add offset to dataSector
    
    mov bx, word [.targetBuffer]
    movzx cx, byte [SectorsPerCluster] ; how many sectors to read per cluster
    mov es, bx ; point es to segment
    mov bx, word [.targetBuffer+2] ; and bx to offset
    call ReadSectors ; readSectors reads address from ClusterLBA to ES:EBX
    
    mov word [.targetBuffer+2], bx ; ReadSectors advances pointer in EBX so we save the new position
    
    ; address of next cluster = (cluster*1.5) = cluster + (cluster/2)
    mov ax, word [.cluster]
    mov bx, ax
    shr bx, 1  ; bx = cluster/2
    add bx, ax ; bx = cluster/2 + cluster
    add bx, FAT_OFFSET
    mov dx, word [bx] ; load the next cluster in the chain from that address

    test al, 0x01 ; check if cluster is odd or even
    jz .evenCluster
    
.oddCluster:
    shr dx, 4      ; odd cluster => get upper 12 bits
    jmp .done
.evenCluster:
    and dx, 0x0FFF ; even cluster => get lower 12 bits
.done:    
    mov word [.cluster], dx ; save new cluster
    
    cmp dx, 0x0FF0 ; check for end of cluster chain
    jb .clusterLoop
    
    pop es
    popa
    xor ax, ax
    clc
    ret
.loadRoot:
    call LoadRoot
    pop es
    popa
    xor ax, ax
    clc
    ret
.notADirectory:
    pop di
    pop si
    pop es
    popa
    mov ax, NOT_A_DIRECTORY
    stc
    ret
.fileNotFound:
    pop es
    popa
    mov ax, FILE_NOT_FOUND
    stc
    ret
.cluster dw 0x0000 ; cluster we are currently working with
.dataSector dw 0x0000 ; start address of the data sector
.targetBuffer dw 0x0000, 0x0000
; ===========================================================