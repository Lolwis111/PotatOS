; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Definiert grafische Werte für das System     %
; % Farben, Bildschirminformationen              %
; %                                              %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _DEFINES_ASM_
%define _DEFINES_ASM_

	%define SCREEN_WIDTH 80
	%define SCREEN_HEIGHT 25
    %define SCREEN_BUFFER_SIZE (SCREEN_HEIGHT * SCREEN_WIDTH)
	%define VIDEO_MEMORY_SEGMENT 0xB800
    %define SYSTEM_COLOR 0x1FFF
    %define SYSTEM_KB_STATUS 0x1FFE
	%define _HIGH_MEM_ NO
	
	%define BLACK			00h
	%define BLUE			01h
	%define GREEN			02h
	%define CYAN			03h
	%define RED				04h
	%define MAGENTA			05h
	%define BROWN			06h
	%define WHITE			07h
	%define GREY			08h
	%define BRIGHT_BLUE		09h
	%define BRIGHT_GREEN 	0Ah
	%define BRIGHT_CYAN		0Bh
	%define BRIGHT_RED		0Ch
	%define BRIGHT_MAGENTA	0Dh
	%define BRIGHT_YELLOW	0Eh
	%define BRIGHT_WHITE	0Fh
	
	%define createColor(foreground, background) ((foreground*16)+background)
	%define cursorPos(x, y) ((y * (SCREEN_WIDTH * 2)) + (x * 2))
	
	%define RESULT_OK		01h
	%define RESULT_CANCEL	00h
	
    %define LOADER_SYS      0x500
    %define SYSTEM_SYS      0x1000
    %define MAIN_SYS        0x2000
    %define STRINGS_SYS     0x8000
    %define SOFTWARE_BASE   0x9000

%endif
