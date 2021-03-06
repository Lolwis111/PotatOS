%ifndef _DEFINES_ASM_
%define _DEFINES_ASM_

    [BITS 16]
    ; SCREEN
    
    %define SCREEN_WIDTH 80
    %define SCREEN_HEIGHT 25
    %define SCREEN_BUFFER_SIZE (SCREEN_HEIGHT * SCREEN_WIDTH)
    
    %define VIDEO_MEMORY_SEGMENT 0xB800
    %define VIDEO_GRAPHICS_SEGMENT 0xA000
    %define VIDEO_TEXT_SEGMENT VIDEO_MEMORY_SEGMENT
    
    ; GENERAL
    
    %define TRUE 0
    %define FALSE -1
    
    %define RESULT_OK        0x01
    %define RESULT_CANCEL    0x00
    
    %define EXIT_SUCCESS 0x00
    %define EXIT_FAILURE 0x01
    
    ; ERRORS
    
    %define NO_ERROR                0x00
    %define FILE_NOT_FOUND_ERROR    0x01
    %define NOT_A_DIRECTORY_ERROR   0x02
    %define OVERFLOW_ERROR          0x03
    %define INVALID_ARGUMENT_ERROR  0x04
    
    ; COLORS
        
    %define BLACK           0x00
    %define BLUE            0x01
    %define GREEN           0x02
    %define CYAN            0x03
    %define RED             0x04
    %define MAGENTA         0x05
    %define BROWN           0x06
    %define WHITE           0x07
    %define GREY            0x08
    %define BRIGHT_BLUE     0x09
    %define BRIGHT_GREEN    0x0A
    %define BRIGHT_CYAN     0x0B
    %define BRIGHT_RED      0x0C
    %define BRIGHT_MAGENTA  0x0D
    %define BRIGHT_YELLOW   0x0E
    %define BRIGHT_WHITE    0x0F
    
    %define createColor(foreground, background) ((background*16)+foreground)
    %define cursorPos(x, y) ((y * (SCREEN_WIDTH * 2)) + (x * 2))

    %define SERIAL_PORT_1 0x03F8

    ; ADDRESSES
    
    %define LOADER_SYS      0x0500
    %define SYSTEM_SYS      0x1000
    %define STRINGS_SYS     0x8000
    %define SOFTWARE_BASE   0x9000

    %define CURRENT_PATH_LENGTH     0x0503
    %define CURRENT_PATH            0x0505
    %define CURRENT_PATH_MAX_LENGTH 0x0500

    %define SYSTEM_COLOR    0x0500 ; byte indicating which color is used at the moment
    %define ERROR_CODE      0x0501 ; return code of the last executed command/programm
    
    ; FILESYSTEM
    
    %define DIRECTORY_OFFSET    0x4000 ; offset to directory
    %define DIRECTORY_SEGMENT   0x0400 ; segment to directory
    %define DIRECTORY_SIZE      0x2000 ; size of the directory memory block
    %define FAT_OFFSET          0x6000 ; offset to fat of disk
    %define FAT_SEGMENT         0x0600 ; segment to fat of disk
    %define FAT_SIZE            0x2000 ; size of the fat memory block

    ; These will trigger errors when the address ranges overlap
    ; due to some coding error 

    %if ((DIRECTORY_OFFSET)+(DIRECTORY_SIZE)) > (FAT_OFFSET)
        %error Directory overlaps with FAT!
    %endif

    %if ((FAT_OFFSET)+(FAT_SIZE)) > (STRINGS_SYS)
        %error FAT overlaps with strins.sys!
    %endif

    %if ((CURRENT_PATH)+(CURRENT_PATH_MAX_LENGTH)) > (SYSTEM_SYS)
        %error The current path overlaps with system.sys!
    %endif

%endif ; _DEFINES_ASM_
