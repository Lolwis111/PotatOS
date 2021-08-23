lblTop  db 177
        times 11 db 0x20
        times 148 db 177
        db 0x00

%ifdef german
    lblBottom   times 81 db 177
                db 24, " Hochscrollen", 177, 25
                db " Runterscrollen", 177, "ESC Beenden"
                db 177, "F5 Neu laden"
                times 22 db 177
                db 0x00
%else
    lblBottom   times 81 db 177
                db 24, " scroll up", 177, 25, " scroll down", 177
                db "ESC quit", 177, "F5 reload"
                times 34 db 177
                db 0x00
%endif
 
