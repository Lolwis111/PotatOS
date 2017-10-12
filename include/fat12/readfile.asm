; ===========================================================
; ReadFile()
;       reads a file from the current directory
;       into the memory
;       SI <= filename
;       BP:BX <= target buffer
;       ECX => filesize
;       carry flag for error indication
; ===========================================================
ReadFile:
    pusha
    push es
    
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
    pop di
    pop si
    jmp .ok
.customDirectory: ; if you want to load files from a different location directory 
    pusha         ; (not the one pwd points to) just set si to the directory entry
    push es       ; and call ReadFile.customDirectory
.ok:
    mov word [.targetBuffer], bp
    mov word [.targetBuffer+2], bx
    
    mov ax, word [si+26]
    mov word [.cluster], ax ; copy start cluster
    mov eax, dword [si+28]
    mov dword [.fileSize], eax ; copy filesize
    
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
    
.loadDone:
    pop es
    popa
    mov ecx, dword [.fileSize] ; last 4 bytes of the entry are the filesize
    xor ax, ax
    clc
    ret
    
.fileNotFound:
    pop es
    popa
    stc
    ret
.fileSize dd 0x00000000
.cluster dw 0x0000 ; cluster we are currently working with
.dataSector dw 0x0000 ; start address of the data sector
.targetBuffer dw 0x0000, 0x0000
; ===========================================================