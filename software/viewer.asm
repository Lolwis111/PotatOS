; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % this is a simple program to view LLP-images  %
; % TODO: documentation on LLP                   %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start


%include "strings.asm"
%include "language.asm"
%include "functions.asm"

input       times 12 db 0
fileName    times 12 db 0
hack        db 0x00

; =====================================================================
start:
    mov si, ax
    cmp byte [si], -1   ; check for an argument
    je .noArgument      ; no argument?

    cmp byte [si], '-'
    jne .load
    mov byte [hack], 0x01
    inc si
.load:
    mov di, fileName
    call AdjustFileName
    
    loadfile fileName, 0x9500 ; load the file
    cmp ax, -1
    je .error
    
    jmp init
; ===================================================================== 


; =====================================================================
.noArgument:
    print FILE_PROMPT ; get filename from user
    readline input, 11
    
    mov si, input           ; convert to uppercase
    call UpperCase
    
    mov si, input           ; convert to fat12
    mov di, fileName
    call AdjustFileName
    cmp ax, -1
    je .error
    
    loadfile fileName, 0x9500 ; load the file
    cmp ax, -1
    je .error
    jmp init
    
.error:
    print FILE_NOT_FOUND_ERROR  ; print an error message

    EXIT EXIT_FAILURE
; =====================================================================
    
    
; =====================================================================
exitV:
    xor ax, ax
    int 0x16

    mov ax, 0x0003 ; go back to text mode
    int 0x10
    
.clear_screen:
    mov ax, VIDEO_TEXT_SEGMENT ; override the screen in SYSTEM_COLOR
    mov gs, ax				   ; and with spaces
    xor bx, bx
    mov cx, SCREEN_BUFFER_SIZE
    mov al, byte [SYSTEM_COLOR]
.clearLoop:
    inc bx
    mov byte [gs:bx], al
    inc bx
    loop .clearLoop
    
    EXIT EXIT_SUCCESS
;======================================================================


; =====================================================================
exitInvalid:
    print INVALID_FILE_ERROR

    EXIT EXIT_SUCCESS
; =====================================================================


; ===================================================================== 
init:
    mov ax, 0x950 ; point fs to file in memory ("file segment")
    mov fs, ax
    
    mov esi, 0x03           ; check the first three chars
    cmp byte [hack], 0x01   ; only accept *.llp files (or use the "hack")
    je .setup

    xor esi, esi
    cmp byte [fs:esi], 'L'
    jne exitInvalid
    inc esi
    cmp byte [fs:esi], 'L'
    jne exitInvalid
    inc esi
    cmp byte [fs:esi], 'P'
    jne exitInvalid
    inc esi
    
.setup:
    ; go into graphics mode 320x200, 256 colors
    mov ax, 0x0013
    int 0x10
; ======================================================================
    
    
; ======================================================================
printImage:
    mov ax, 0xA000 ; point gs to video memory ("graphic segment")
    mov gs, ax
    xor bx, bx     ; offset to gs
    mov bp, 0x0003 ; offset to fs, skip the signature
    xor cx, cx     ; general counter
    xor dx, dx 
    
.pixelLoop:
    movzx cx, byte [fs:bp] ; get the amount
    mov al, byte [fs:bp+1] ; get the color
    add dx, cx
    .compressLoop: ; draw color al cx times
        mov byte [gs:bx], al
        inc bx
        loop .compressLoop
    add bp, 2
    
    cmp dx, 64000 ; 320x200 = 64000 => abort after this many bytes
    jne .pixelLoop
    jmp exitV
; ======================================================================
