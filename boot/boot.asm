[ORG 0x0] ; bootloader is executed at 0x7C00
[BITS 16] ; but we fix that by adjusting all the segments

start: 
    jmp boot

%include "bpb.asm" ; BIOS Parameter Block
%include "defines.asm"
%include "floppy/lba.asm"

%define FAT_SIZE 0x7BF0
%define DATA_SECTOR 0x7BF2

; ==============================
; prints a string
; si <= string address
; ==============================
Print:
    lodsb
    or al, al
    jz .return
    mov ah, 0x0E
    int 0x10
    jmp Print
.return:
    ret
; ==============================


; ==============================
; CX = sector count
; AX = start sector
; ES:BX = target buffer address
; =========================================================
ReadSectors:
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
	
        loop ReadSectors ; read CX sectors
    ret
;==========================================================
    

boot: 
    cli
    mov ax, 0x07C0
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ax, 0x7BFF      ; create a stack
    mov ss, ax
    mov sp, 0x7BFF
    
    sti

    mov byte [SYSTEM_COLOR], 0x07 ; Default color is white on black
    
    mov si, msgLoading
    call Print
    
; load the root directory
LoadRoot:
    ; calculate size in cx
    xor cx, cx  
    xor dx, dx ; set to 0 for div
    mov ax, 32
    mul word [RootEntries] ; RootSizeB = 32 * RootEntries
    div word [BytesPerSector] ; RootSizeS = RootSizeB / BytePerSector
    mov cx, ax

    movzx ax, byte [NumberOfFATS]
    mul word [SectorsPerFAT] ; FatSizeS = NumberOfFATS * SectorsPerFAT 
    mov word [FAT_SIZE], ax  ; save FatSizeS for later
    add ax, word [ReservedSectors] ; Root = FatSizeS + ReservedSectors
    
    mov word [DATA_SECTOR], ax ; data sector = ReservedSectors + FatSizeS + RootSizeS
    add word [DATA_SECTOR], cx
    
    ; after calculating size load root at 0x00007E00
    mov ebx, 0x0200
    call ReadSectors

    mov di, 0x0200 ; search loader.sys in the root directory
.fileLoop:
    cmp byte [es:di], 0x00 ; end of directory => file not found
    je fileNotFound
    
    push di
    
    mov cx, 11
    mov si, ImageName ; compare the file name of each entry
    rep cmpsb
    je LoadFAT ; go to the next step when the file is found
    
    pop di
    add di, 32 ; move to next entry
    jmp .fileLoop
    
    
LoadFAT:
    mov si, msgNewLine
    call Print

    pop di
   
    ; get cluster from the entry
    mov dx, word [di+26]
    
    mov word [cluster], dx
    
    mov cx, word [FAT_SIZE] ; fat size
    mov ax, word [ReservedSectors] ; fat is right behind the reserved sectors (usually sector 2)
    
    mov ebx, 0x0200 ; load the fat at 0x00007E00
    call ReadSectors
    
    mov si, msgNewLine
    call Print
    
    ; we gonna load loader.sys at 0x00000500
    ; so by pointing es to 0x0050 and bx to 0x0000
    ; we can have up to 64kib if secondary bootloader! :)
    mov ax, 0x0050 
    xor ebx, ebx
    mov es, ax
    
    push ebx
    
loadFile:
    pop ebx
    
    mov ax, word [cluster] ; calculate witch cluster to load
    call Cluster2LBA
    add ax, word [DATA_SECTOR] ; put dataSector offset on
    
    movzx cx, byte [SectorsPerCluster] ; clusters in fat12 can have up to 8 sectors so adjust that here
    call ReadSectors ; (ReadSectors advances ebx, so we dont have to care about this here)
    
    push ebx
    
    ; address of next cluster = (cluster*1.5) + 1 = cluster + (cluster/2) + 1
    mov ax, word [cluster]
    mov bx, ax
    shr bx, 1  ; bx = cluster/2
    add bx, ax ; bx = cluster/2 + cluster
    add bx, 0x0200 ; bx = cluster/2 + cluster + 0x200 (offset where fat is)
    mov dx, word [fs:bx] ; load the next cluster in the chain from that address
    
    test al, 0x01 ; check wether cluster is even or odd
    jnz .oddCluster
    
.evenCluster:
    and dx, 0x0FFF ; get lower 12 bits
    jmp .done
    
.oddCluster:
    shr dx, 4 ; by shifting 4 to the right we get the upper 12 bits
    
.done:
    mov word [cluster], dx  ; save new cluster
    
    cmp dx, 0x0FF0 ; check if we reached the end of the cluster chain
    jb loadFile
    
    mov si, msgOK ; if yes, print an success string
    call Print
    
    jmp 0x0050:0x0000 ; and jump into our second stage
    
fileNotFound:
    mov si, msgFailure ; print an error message
    call Print
    xor ax, ax ; wait for the user to press any key
    int 0x16
    int 0x19 ; and reboot the system

cluster     dw 0x0000
ImageName   db "LOADER  SYS"
msgLoading  db 0x0D, 0x0A, "Loading Bootimage..."
msgNewLine  db 0x0D, 0x0A, 0x00
msgOK       db "OK", 0x0D, 0x0A, 0x00
msgFailure  db 0x0D, 0x0A, "ERROR: PRESS ANY KEY TO RESET", 0x0D, 0x0A, 0x00

times 510-($-$$) db 0   ; pad this file to 510 Bytes (2 Bytes for signature)

dw 0xAA55               ; and make the last two bytes the boot signature
