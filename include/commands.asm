; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
; % Stellt die CMD-Befehle für MAIN.SYS         %
; % zur verfügung.                               %
; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%ifndef _COMMANDS_INC_
%define _COMMANDS_INC_

cmdLS		db "LS", 0x00       ; alle Dateien und ihre Größe auflisten
cmdLL       db "LL", 0x00       ; alle Dateien aufzählen

cmdHELP		db "HELP", 0x00     ; die Hilfe anzeigen
cmdDATE		db "DATE", 0x00     ; das Datum anzeigen
cmdTIME		db "TIME", 0x00     ; die Zeit anzeigen
cmdINFO		db "INFO", 0x00     ; Informationen anzeigen

cmdCOLOR	db "COLOR", 0x00    ; die Farbe wechseln
cmdCLEAR	db "CLS", 0x00      ; den Bildschirm leeren

cmdRENAME	db "RENAME", 0x00   ; zum umbenennen von Dateien
cmdDEL		db "DEL", 0x00      ; zum löschen von Dateien

%endif
