; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % stage2 bootloader. loads all the important   %
; % files and does some initalisation            %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[ORG 0x500]
[BITS 16]

jmp start

%include "defines.asm" ; some defines (including offsets)
%include "bpb.asm"     ; bios parameter block (for disk access)
%include "floppy/lba.asm" ; linear block address converters
%include "floppy/readsectors.asm" ; low-level floppy driver
%include "fat12/fat.asm"  ; loading fat from disk
%include "fat12/root.asm" ; loading root-dir from disk
%include "fat12/readfile.asm" ; loading file from disk
%include "fat12/readdirectory.asm" ; loading directory from disk
%include "fat12/countfiles.asm" ; count files in system directory

Sysinit   db "SYSINIT SYS", 0x00 ; reads config and sets up system
Driver    db "SYSTEM  SYS", 0x00 ; API for int0x21
Strings   db "STRINGS SYS", 0x00 ; contains language specific strings that devs can use
Command   db "COMMAND BIN", 0x00
SystemDir db "SYSTEM     ", 0x00 ; system directory

; ====================================================================================
; Prints a string from si using BIOS interrupts as int0x21 is not setup
; by the time loader.sys is executed
; ====================================================================================
Print:
	lodsb       ; load next char
	or al, al   ; check if it is 0
	jz .return  ; if yes we are done
	mov ah, 0x0E ; else print it using bios
	int 0x10
	jmp Print
.return:
	ret
; ====================================================================================
    
    
; ====================================================================================
msgError0 db 0x0D, 0x0A, "System directory", 0x00
msgError1 db 0x0D, 0x0A, "strings.sys", 0x00
msgError2 db 0x0D, 0x0A, "system.sys", 0x00
msgError3 db 0x0D, 0x0A, "sysinit.sys", 0x00
msgError4 db 0x0D, 0x0A, "command.bin", 0x00
msgError  db " missing!", 0x00 

msgHello  db 0x0D, 0x0A, "Loading files...", 0x0D, 0x0A, 0x00
; ====================================================================================


; ====================================================================================
start:
	cli
	xor ax, ax      ; zero out all the segments
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ax, 0x3000  ; put stack to 0x3000:0x0000
	mov ss, ax
	xor sp, sp
	sti
	
	mov ax, 0x0003	; go into 16 color, 80x25 chars textmode
	int 0x10
	mov ax, 0x1003	; we do not need blinking
	xor bx, bx
	int 0x10
	
	mov si, msgHello
    call Print
    
    call LoadRoot       ; load the root directory
    
    mov si, SystemDir
    call ReadDirectory  ; load the 'system' directory
    jc .error0
    
    xor bp, bp          ; load 'strings.sys' at 0x0000:0x8000
    mov bx, STRINGS_SYS
    mov si, Strings
    call ReadFile
    jc .error1

	xor bp, bp          ; load 'system.sys' 0x0000:0x1000
	mov bx, SYSTEM_SYS
	mov si, Driver
	call ReadFile
	jc .error2

	xor bp, bp          ; load 'sysinit.sys' at 0x0000:0x9000
	mov bx, SOFTWARE_BASE
    mov si, Sysinit
	call ReadFile
	jc .error3
    
    mov bp, 0x8000      ; load command.bin at 0x8000:0x0000
    xor bx, bx
    mov si, Command
    call ReadFile
    jc .error4
    
    ; copy the system directory to 0x8000:0x0000
    ; TODO: build algorithm to resolve paths
    ; push es
    ; call CountFiles
    ; mov ax, 32
    ; xor di, di
    ; mul cx
    ; mov si, DIRECTORY_OFFSET
    ; mov cx, ax
    ; mov ax, 0x8000
    ; mov es, ax
    ; rep movsb ; copy from ds:si -> es:di (0x0000:DIRECTORY_OFFSET -> 0x8000:0x0000)
    
    ; pop es
    
	jmp SOFTWARE_BASE ; jump to the loaded program (in this case its sysinit.sys)
	
    
; if any of the files is missing we have a problem
.error0:
    mov si, msgError0
    jmp .error
.error1:
    mov si, msgError1
    jmp .error
.error2:
    mov si, msgError2
    jmp .error
.error3:
    mov si, msgError3
    jmp .error
.error4:
    mov si, msgError4
.error:
    call Print
    mov si, msgError
    call Print
	xor ax, ax
	int 0x16
	int 0x19                    ; try rebooting when everything goes wrong
; ====================================================================================
