; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Provides general information for the OS.     %
; % Such as version and important system file    %
; % names.                                       %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMON_INC_
%define _COMMON_INC_

%define DEV_YEAR_C "2019"
%define DEV_YEAR_S "2012"

%define MAJOR_VERSION 2
%define MINOR_VERSION 0

Sysinit   db "SYSINIT SYS", 0x00 ; reads config and sets up system
Driver    db "SYSTEM  SYS", 0x00 ; API for int0x21
Strings   db "STRINGS SYS", 0x00 ; contains language specific strings that devs can use
SystemDir db "SYSTEM     ", 0x00 ; system directory

%endif
