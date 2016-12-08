; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Definiert grafische Werte für das System     %
; % Farben, Bildschirminformationen              %
; %                                              %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _DEFINES_ASM_
%define _DEFINES_ASM_

    %define TRUE 1
    %define FALSE 0

	%define SCREEN_WIDTH 80
	%define SCREEN_HEIGHT 25
    %define SCREEN_BUFFER_SIZE (SCREEN_HEIGHT * SCREEN_WIDTH)
	%define VIDEO_MEMORY_SEGMENT 0xB800
    %define SYSTEM_COLOR 0x1FFF
    %define SYSTEM_KB_STATUS 0x1FFE
    %define SYSTEM_BOOT_DRIVE 0x7FFF
	%define _HIGH_MEM_ FALSE
	
	%define BLACK			0x00
	%define BLUE			0x01
	%define GREEN			0x02
	%define CYAN			0x03
	%define RED				0x04
	%define MAGENTA			0x05
	%define BROWN			0x06
	%define WHITE			0x07
	%define GREY			0x08
	%define BRIGHT_BLUE		0x09
	%define BRIGHT_GREEN 	0x0A
	%define BRIGHT_CYAN		0x0B
	%define BRIGHT_RED		0x0C
	%define BRIGHT_MAGENTA	0x0D
	%define BRIGHT_YELLOW	0x0E
	%define BRIGHT_WHITE	0x0F
	
	%define createColor(foreground, background) ((foreground * 16) + background)
	%define cursorPos(x, y) ((y * (SCREEN_WIDTH * 2)) + (x * 2))
	
	%define RESULT_OK		0x01
	%define RESULT_CANCEL	0x00
	
    %define LOADER_SYS      0x500
    %define SYSTEM_SYS      0x1000
    %define MAIN_SYS        0x2000
    %define STRINGS_SYS     0x8000
    %define SOFTWARE_BASE   0x9000

%endif
