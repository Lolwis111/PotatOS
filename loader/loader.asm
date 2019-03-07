; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % stage2 bootloader. loads all the important   %
; % files and does some initalisation            %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm" ; some defines (including offsets)

[ORG LOADER_SYS]
[BITS 16]

jmp start

%include "bpb.asm"     ; bios parameter block (for disk access)
%include "floppy/lba.asm" ; linear block address converters
%include "floppy/readsectors.asm" ; low-level floppy driver
%include "fat12/fat.asm"  ; loading fat from disk
%include "fat12/root.asm" ; loading root-dir from disk
%include "fat12/readfile.asm" ; loading file from disk
%include "fat12/readdirectory.asm" ; loading directory from disk
%include "print16.asm"
%include "common.asm"
; ====================================================================================
msgError0 db 0x0D, 0x0A, "System directory", 0x00
msgError1 db 0x0D, 0x0A, "strings.sys", 0x00
msgError2 db 0x0D, 0x0A, "system.sys", 0x00
msgError3 db 0x0D, 0x0A, "sysinit.sys", 0x00
msgError  db " missing!", 0x00 

msgHello  db 0x0D, 0x0A
          db "Loading files..."
          db 0x0D, 0x0A
          db 0x00
; ====================================================================================


; ====================================================================================
start:
    cli
    
    xor ax, ax      ; zero out all the segments
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    
    mov ax, 0x3000  ; put stack to 0x3FFFF
    mov ss, ax
    mov sp, 0xFFFF
    
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
.error:
    call Print
    mov si, msgError
    call Print
    xor ax, ax
    int 0x16
    int 0x19                    ; try rebooting when everything goes wrong
; ====================================================================================
