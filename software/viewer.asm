; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % this is a simple program to view LLP-images  %
; % TODO: documentation on LLP                   %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%include "defines.asm"

[ORG SOFTWARE_BASE]
[BITS 16]

jmp start

%include "keys.asm"
%include "strings.asm"
%include "language.asm"
%include "functions.asm"
%include "chars.asm"

%define IMAGE_DATA_SEGMENT 0x1000

input       times 12 db 0
fileName    times 12 db 0
hack        db 0x00
; =====================================================================
start:
    mov si, ax

    cmp ax, -1   ; check for an argument
    je .noArgument      ; no argument?

    cmp byte [si], '-'
    jne .load
    mov byte [hack], 0x01
    inc si
.load:
    mov di, fileName
    call AdjustFileName
    
    LOADFILE fileName, 0, IMAGE_DATA_SEGMENT ; load the file
    cmp ax, -1
    je .error
    
    jmp init
; ===================================================================== 


; =====================================================================
.noArgument:
    PRINT FILE_PROMPT ; get filename from user
    READLINE input, 11
    
    mov si, input           ; convert to uppercase
    call UpperCase
    
    mov si, input           ; convert to fat12
    mov di, fileName
    call AdjustFileName
    cmp ax, -1
    je .error
    
    LOADFILE fileName, 0, IMAGE_DATA_SEGMENT ; load the file
    cmp ax, -1
    je .error
    jmp init
    
.error:
    PRINT FILE_NOT_FOUND_ERROR  ; print an error message

    EXIT EXIT_FAILURE
; =====================================================================
    
    
; =====================================================================
exitV:
    READCHAR 

    mov ax, 0x0003 ; go back to text mode
    int 0x10
    
.clear_screen:
    mov ax, VIDEO_TEXT_SEGMENT ; override the screen in SYSTEM_COLOR
    mov es, ax
    xor edi, edi
    mov cx, (SCREEN_BUFFER_SIZE / 2)
    mov al, byte [SYSTEM_COLOR]
    mov ah, CHAR_SPACE
    rep movsw
    
    EXIT EXIT_SUCCESS
;======================================================================


; =====================================================================
exitInvalid:
    PRINT INVALID_FILE_ERROR

    EXIT EXIT_SUCCESS
; =====================================================================


; ===================================================================== 
init:
    mov ax, IMAGE_DATA_SEGMENT ; point fs to file in memory ("file segment")
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
    mov ax, VIDEO_GRAPHICS_SEGMENT ; point gs to video memory ("graphic imageDataSegment")
    mov gs, ax
    xor edi,edi     ; offset to gs
    mov esi, 0x0003 ; offset to fs, skip the signature
    xor cx, cx      ; general counter
    xor dx, dx 
    
.pixelLoop:
    movzx cx, byte [fs:esi] ; get the amount
    mov al, byte [fs:esi+1] ; get the color
    add dx, cx
    .compressLoop: ; draw color al cx times
        mov byte [gs:edi], al
        inc edi
        loop .compressLoop
    add esi, 2
    
    cmp dx, 64000 ; 320x200 = 64000 => abort after this many bytes
    jne .pixelLoop

    jmp exitV
; ======================================================================

imageData db 0x00
