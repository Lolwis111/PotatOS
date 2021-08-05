; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % this represents the commands for main.sys    %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMANDS_INC_
%define _COMMANDS_INC_

cmdLS       db "LS", 0x00       ; list all files and their sizes
cmdCD       db "CD", 0x00       ; navigate too another directory (currently no paths supported)

cmdHELP     db "HELP", 0x00     ; print the help
cmdDATE     db "DATE", 0x00     ; show the date
cmdTIME     db "TIME", 0x00     ; show the time
cmdINFO     db "INFO", 0x00     ; give some system information

cmdCOLOR    db "COLOR", 0x00    ; change color of cli
cmdCLEAR    db "CLS", 0x00      ; clear cli

cmdRENAME   db "RENAME", 0x00   ; renaming files
cmdDEL      db "DEL", 0x00      ; deleting files

cmdPWD      db "PWD", 0x00      ; print working directory

cmdRETURN   db "RETURN?", 0x00  ; print return value of last command/program

cmdFILE     db "FILE", 0x00

%ifdef _DEBUG
cmdDUMP     db "DUMP", 0x00     ; debug: print all the buffers
%endif

%endif
