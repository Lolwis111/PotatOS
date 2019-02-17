; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt allegemeine Informationen für das     %
; % System bereit. Z.B. Version und wichtige     %
; % wichtige Dateinamen.                         %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMON_INC_
%define _COMMON_INC_

%define DEV_YEAR_C "2019"
%define DEV_YEAR_S "2012"

MAJOR_VERSION db 1
MINOR_VERSION db 1

Sysinit     db  "SYSINIT SYS", 0x00
Driver      db  "SYSTEM  SYS", 0x00
Strings     db  "STRINGS SYS", 0x00

%endif
