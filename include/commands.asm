; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt die CMD-Befehle für MAIN.SYS         %
; % zur verfügung.                               %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMANDS_INC_
%define _COMMANDS_INC_

cmdLS		db "LS", 00h
cmdLL       db "LL", 00h

cmdHELP		db "HELP", 00h
cmdDATE		db "DATE", 00h
cmdTIME		db "TIME", 00h
cmdINFO		db "INFO", 00h

cmdCOLOR	db "COLOR", 00h
cmdCLEAR	db "CLS", 00h

cmdRENAME	db "RENAME", 00h
cmdDEL		db "DEL", 00h

%endif
