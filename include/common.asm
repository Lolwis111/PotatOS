; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt allegemeine Informationen für das     %
; % System bereit. Z.B. Version und wichtige     %
; % wichtige Dateinamen.                         %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMON_INC_
%define _COMMON_INC_

%define DEV_YEAR_C "2017"
%define DEV_YEAR_S "2012"

MAJOR_VERSION db 0
MINOR_VERSION db 8

ImageName 	db	"MAIN    SYS", 00h
sinit	 	db	"SINIT   SYS", 00h
Driver		db	"SYSTEM  SYS", 00h
config		db  "CONFIG  CFG", 00h
Strings     db  "STRINGS SYS", 00h
SYSTEMROOT	db	"SYSTEM     "

%endif
