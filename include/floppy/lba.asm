; ======================================================================
; Cluster2LBA()
;       LBA = (cluster - 2) * sectors per cluster
; ======================================================================
Cluster2LBA:
	sub ax, 0x0002
	movzx cx, byte [SectorsPerCluster]
	mul cx
	
	ret
; ======================================================================


; ======================================================================
; LBA2CHS()
;       absolut sector = (logical sector / sector per track) + 1
;       absolut head   = (logical sector / sector per track) % heads
;       absolut track  = logical sector / (sector per track * heads)
; AX <= LBA
; AL => absolute track
; CL => absolute sector
; DL => absolute head
; ======================================================================
LBA2CHS:
	xor dx, dx
	
	div word [SectorsPerTrack]
	inc dl
    mov cl, dl
	
	xor dx, dx
	div word [HeadsPerCylinder]
	
	ret
; ======================================================================