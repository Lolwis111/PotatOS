; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt allegemeine Informationen für das     %
; % System bereit. Z.B. Version und wichtige     %
; % wichtige Dateinamen.                         %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMON_INC_
%define _COMMON_INC_

%define DEV_YEAR_C "2017"
%define DEV_YEAR_S "2012"

MAJOR_VERSION db 1
MINOR_VERSION db 1

Sysinit     db  "SYSINIT SYS", 00h
Driver      db  "SYSTEM  SYS", 00h
Strings     db  "STRINGS SYS", 00h

%endif
