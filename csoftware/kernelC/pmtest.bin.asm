00000000  EB0B              jmp short 0xd
00000002  4B                dec bx
00000003  45                inc bp
00000004  52                push dx
00000005  4E                dec si
00000006  45                inc bp
00000007  4C                dec sp
00000008  2020              and [bx+si],ah
0000000A  53                push bx
0000000B  59                pop cx
0000000C  53                push bx
0000000D  BA0290            mov dx,0x9002
00000010  BB0000            mov bx,0x0
00000013  BD0010            mov bp,0x1000
00000016  B405              mov ah,0x5
00000018  CD21              int 0x21
0000001A  E85000            call 0x6d
0000001D  EB1F              jmp short 0x3e
0000001F  90                nop
00000020  skipping 0x1E bytes
0000003E  FA                cli
0000003F  0F01163890        lgdt [0x9038]
00000044  0F20C0            mov eax,cr0
00000047  6683C801          or eax,byte +0x1
0000004B  0F22C0            mov cr0,eax
0000004E  EA53900800        jmp 0x8:0x9053
00000053  66B810008ED8      mov eax,0xd88e0010
00000059  8ED0              mov ss,ax
0000005B  8EC0              mov es,ax
0000005D  8EE0              mov fs,ax
0000005F  8EE8              mov gs,ax
00000061  BD0000            mov bp,0x0
00000064  0900              or [bx+si],ax
00000066  89EC              mov sp,bp
00000068  E85B00            call 0xc6
0000006B  0000              add [bx+si],al
0000006D  FA                cli
0000006E  E82E00            call 0x9f
00000071  B0AD              mov al,0xad
00000073  E664              out 0x64,al
00000075  E82700            call 0x9f
00000078  B0D0              mov al,0xd0
0000007A  E664              out 0x64,al
0000007C  E82700            call 0xa6
0000007F  E460              in al,0x60
00000081  6650              push eax
00000083  E81900            call 0x9f
00000086  B0D1              mov al,0xd1
00000088  E664              out 0x64,al
0000008A  E81200            call 0x9f
0000008D  6658              pop eax
0000008F  0C02              or al,0x2
00000091  E660              out 0x60,al
00000093  E80900            call 0x9f
00000096  B0AE              mov al,0xae
00000098  E664              out 0x64,al
0000009A  E80200            call 0x9f
0000009D  FB                sti
0000009E  C3                ret
0000009F  E464              in al,0x64
000000A1  A802              test al,0x2
000000A3  75FA              jnz 0x9f
000000A5  C3                ret
000000A6  E464              in al,0x64
000000A8  A801              test al,0x1
000000AA  74FA              jz 0xa6
000000AC  C3                ret
000000AD  60                pusha
000000AE  BA0080            mov dx,0x8000
000000B1  0B00              or ax,[bx+si]
000000B3  8A03              mov al,[bp+di]
000000B5  B40F              mov ah,0xf
000000B7  3C00              cmp al,0x0
000000B9  740B              jz 0xc6
000000BB  668902            mov [bp+si],eax
000000BE  83C301            add bx,byte +0x1
000000C1  83C202            add dx,byte +0x2
000000C4  EBED              jmp short 0xb3
000000C6  61                popa
000000C7  C3                ret
000000C8  BBD990            mov bx,0x90d9
000000CB  0000              add [bx+si],al
000000CD  E8DBFF            call 0xab
000000D0  FF                db 0xff
000000D1  FF                db 0xff
000000D2  E8296F            call 0x6ffe
000000D5  0000              add [bx+si],al
000000D7  EBFE              jmp short 0xd7
000000D9  57                push di
000000DA  65206172          and [gs:bx+di+0x72],ah
000000DE  65206E6F          and [gs:bp+0x6f],ch
000000E2  7720              ja 0x104
000000E4  696E203332        imul bp,[bp+0x20],word 0x3233
000000E9  204269            and [bp+si+0x69],al
000000EC  7420              jz 0x10e
000000EE  7072              jo 0x162
000000F0  6F                outsw
000000F1  7465              jz 0x158
000000F3  637465            arpl [si+0x65],si
000000F6  64206D6F          and [fs:di+0x6f],ch
000000FA  64652E008D4C24    add [cs:di+0x244c],cl
00000101  0483              add al,0x83
00000103  E4F0              in al,0xf0
00000105  FF71FC            push word [bx+di-0x4]
00000108  55                push bp
00000109  89E5              mov bp,sp
0000010B  57                push di
0000010C  56                push si
0000010D  53                push bx
0000010E  51                push cx
0000010F  81EC8800          sub sp,0x88
00000113  0000              add [bx+si],al
00000115  E8450A            call 0xb5d
00000118  0000              add [bx+si],al
0000011A  83EC0C            sub sp,byte +0xc
0000011D  686010            push word 0x1060
00000120  0100              add [bx+si],ax
00000122  E82005            call 0x645
00000125  0000              add [bx+si],al
00000127  83C410            add sp,byte +0x10
0000012A  83EC04            sub sp,byte +0x4
0000012D  8D458E            lea ax,[di-0x72]
00000130  6A28              push byte +0x28
00000132  6A00              push byte +0x0
00000134  50                push ax
00000135  E8AA0F            call 0x10e2
00000138  0000              add [bx+si],al
0000013A  C7042438          mov word [si],0x3824
0000013E  1101              adc [bx+di],ax
00000140  00E8              add al,ch
00000142  2A09              sub cl,[bx+di]
00000144  0000              add [bx+si],al
00000146  8D458E            lea ax,[di-0x72]
00000149  59                pop cx
0000014A  5B                pop bx
0000014B  6A28              push byte +0x28
0000014D  50                push ax
0000014E  E82C0B            call 0xc7d
00000151  0000              add [bx+si],al
00000153  C7042440          mov word [si],0x4024
00000157  1101              adc [bx+di],ax
00000159  00E8              add al,ch
0000015B  1109              adc [bx+di],cx
0000015D  0000              add [bx+si],al
0000015F  8D458E            lea ax,[di-0x72]
00000162  5E                pop si
00000163  5F                pop di
00000164  684311            push word 0x1143
00000167  0100              add [bx+si],ax
00000169  BE1000            mov si,0x10
0000016C  0000              add [bx+si],al
0000016E  50                push ax
0000016F  E8080E            call 0xf7a
00000172  0000              add [bx+si],al
00000174  83C410            add sp,byte +0x10
00000177  898574FF          mov [di-0x8c],ax
0000017B  FF                db 0xff
0000017C  FF85C075          inc word [di+0x75c0]
00000180  792E              jns 0x1b0
00000182  8DB42600          lea si,[si+0x26]
00000186  0000              add [bx+si],al
00000188  002E8D74          add [0x748d],ch
0000018C  26000F            add [es:bx],cl
0000018F  B69D              mov dh,0x9d
00000191  74FF              jz 0x192
00000193  FF                db 0xff
00000194  FFC1              inc cx
00000196  E304              jcxz 0x19c
00000198  8DB60000          lea si,[bp+0x0]
0000019C  0000              add [bx+si],al
0000019E  83EC0C            sub sp,byte +0xc
000001A1  0FB6FB            movzx di,bl
000001A4  83C301            add bx,byte +0x1
000001A7  57                push di
000001A8  E86902            call 0x414
000001AB  0000              add [bx+si],al
000001AD  58                pop ax
000001AE  5A                pop dx
000001AF  57                push di
000001B0  684A11            push word 0x114a
000001B3  0100              add [bx+si],ax
000001B5  E8B608            call 0xa6e
000001B8  0000              add [bx+si],al
000001BA  89F0              mov ax,si
000001BC  83C410            add sp,byte +0x10
000001BF  38C3              cmp bl,al
000001C1  75DB              jnz 0x19e
000001C3  83EC0C            sub sp,byte +0xc
000001C6  8D7310            lea si,[bp+di+0x10]
000001C9  684011            push word 0x1140
000001CC  0100              add [bx+si],ax
000001CE  E89D08            call 0xa6e
000001D1  0000              add [bx+si],al
000001D3  838574FFFF        add word [di-0x8c],byte -0x1
000001D8  FF01              inc word [bx+di]
000001DA  83C410            add sp,byte +0x10
000001DD  8B8574FF          mov ax,[di-0x8c]
000001E1  FF                db 0xff
000001E2  FF83F810          inc word [bp+di+0x10f8]
000001E6  75A6              jnz 0x18e
000001E8  83EC0C            sub sp,byte +0xc
000001EB  6A07              push byte +0x7
000001ED  E82402            call 0x414
000001F0  0000              add [bx+si],al
000001F2  83C410            add sp,byte +0x10
000001F5  E930FF            jmp 0x128
000001F8  FF                db 0xff
000001F9  FF83EC08          inc word [bp+di+0x8ec]
000001FD  8D458E            lea ax,[di-0x72]
00000200  684E11            push word 0x114e
00000203  0100              add [bx+si],ax
00000205  50                push ax
00000206  E8710D            call 0xf7a
00000209  0000              add [bx+si],al
0000020B  83C410            add sp,byte +0x10
0000020E  85C0              test ax,ax
00000210  7520              jnz 0x232
00000212  83EC0C            sub sp,byte +0xc
00000215  685511            push word 0x1155
00000218  0100              add [bx+si],ax
0000021A  6A7B              push byte +0x7b
0000021C  6A7B              push byte +0x7b
0000021E  6A7B              push byte +0x7b
00000220  689810            push word 0x1098
00000223  0100              add [bx+si],ax
00000225  E84608            call 0xa6e
00000228  0000              add [bx+si],al
0000022A  83C420            add sp,byte +0x20
0000022D  E9F8FE            jmp 0x128
00000230  FF                db 0xff
00000231  FF83EC08          inc word [bp+di+0x8ec]
00000235  8D458E            lea ax,[di-0x72]
00000238  685D11            push word 0x115d
0000023B  0100              add [bx+si],ax
0000023D  50                push ax
0000023E  E8390D            call 0xf7a
00000241  0000              add [bx+si],al
00000243  83C410            add sp,byte +0x10
00000246  85C0              test ax,ax
00000248  753C              jnz 0x286
0000024A  83EC08            sub sp,byte +0x8
0000024D  BBD007            mov bx,0x7d0
00000250  0000              add [bx+si],al
00000252  6A00              push byte +0x0
00000254  6A00              push byte +0x0
00000256  E82E0B            call 0xd87
00000259  0000              add [bx+si],al
0000025B  83C410            add sp,byte +0x10
0000025E  83EC08            sub sp,byte +0x8
00000261  6A07              push byte +0x7
00000263  6A20              push byte +0x20
00000265  E83103            call 0x599
00000268  0000              add [bx+si],al
0000026A  83C410            add sp,byte +0x10
0000026D  83EB01            sub bx,byte +0x1
00000270  75EC              jnz 0x25e
00000272  83EC08            sub sp,byte +0x8
00000275  6A00              push byte +0x0
00000277  6A00              push byte +0x0
00000279  E80B0B            call 0xd87
0000027C  0000              add [bx+si],al
0000027E  83C410            add sp,byte +0x10
00000281  E9A4FE            jmp 0x128
00000284  FF                db 0xff
00000285  FF83EC08          inc word [bp+di+0x8ec]
00000289  8D458E            lea ax,[di-0x72]
0000028C  686311            push word 0x1163
0000028F  0100              add [bx+si],ax
00000291  50                push ax
00000292  E8E50C            call 0xf7a
00000295  0000              add [bx+si],al
00000297  83C410            add sp,byte +0x10
0000029A  85C0              test ax,ax
0000029C  7550              jnz 0x2ee
0000029E  83EC0C            sub sp,byte +0xc
000002A1  685511            push word 0x1155
000002A4  0100              add [bx+si],ax
000002A6  E8660D            call 0x100f
000002A9  0000              add [bx+si],al
000002AB  C7042468          mov word [si],0x6824
000002AF  1101              adc [bx+di],ax
000002B1  0089C3E8          add [bx+di-0x173d],cl
000002B5  58                pop ax
000002B6  0D0000            or ax,0x0
000002B9  C70424DC          mov word [si],0xdc24
000002BD  1001              adc [bx+di],al
000002BF  0089C6E8          add [bx+di-0x173a],cl
000002C3  4A                dec dx
000002C4  0D0000            or ax,0x0
000002C7  83C40C            add sp,byte +0xc
000002CA  68DC10            push word 0x10dc
000002CD  0100              add [bx+si],ax
000002CF  50                push ax
000002D0  686811            push word 0x1168
000002D3  0100              add [bx+si],ax
000002D5  56                push si
000002D6  685511            push word 0x1155
000002D9  0100              add [bx+si],ax
000002DB  53                push bx
000002DC  687211            push word 0x1172
000002DF  0100              add [bx+si],ax
000002E1  E88A07            call 0xa6e
000002E4  0000              add [bx+si],al
000002E6  83C420            add sp,byte +0x20
000002E9  E93CFE            jmp 0x128
000002EC  FF                db 0xff
000002ED  FF83EC04          inc word [bp+di+0x4ec]
000002F1  8D458E            lea ax,[di-0x72]
000002F4  6A04              push byte +0x4
000002F6  688B11            push word 0x118b
000002F9  0100              add [bx+si],ax
000002FB  50                push ax
000002FC  E8BA0C            call 0xfb9
000002FF  0000              add [bx+si],al
00000301  83C410            add sp,byte +0x10
00000304  85C0              test ax,ax
00000306  7519              jnz 0x321
00000308  83EC08            sub sp,byte +0x8
0000030B  8D4592            lea ax,[di-0x6e]
0000030E  50                push ax
0000030F  689011            push word 0x1190
00000312  0100              add [bx+si],ax
00000314  E85707            call 0xa6e
00000317  0000              add [bx+si],al
00000319  83C410            add sp,byte +0x10
0000031C  E909FE            jmp 0x128
0000031F  FF                db 0xff
00000320  FF83EC04          inc word [bp+di+0x4ec]
00000324  8D458E            lea ax,[di-0x72]
00000327  6A04              push byte +0x4
00000329  689911            push word 0x1199
0000032C  0100              add [bx+si],ax
0000032E  50                push ax
0000032F  E8870C            call 0xfb9
00000332  0000              add [bx+si],al
00000334  83C410            add sp,byte +0x10
00000337  85C0              test ax,ax
00000339  755C              jnz 0x397
0000033B  B86F20            mov ax,0x206f
0000033E  0000              add [bx+si],al
00000340  83EC08            sub sp,byte +0x8
00000343  C6458D00          mov byte [di-0x73],0x0
00000347  6689458B          mov [di-0x75],eax
0000034B  8D4587            lea ax,[di-0x79]
0000034E  50                push ax
0000034F  8D45B6            lea ax,[di-0x4a]
00000352  50                push ax
00000353  C745874861        mov word [di-0x79],0x6148
00000358  6C                insb
00000359  6C                insb
0000035A  C745825765        mov word [di-0x7e],0x6557
0000035F  6C                insb
00000360  74C6              jz 0x328
00000362  45                inc bp
00000363  8600              xchg [bx+si],al
00000365  E8CD0C            call 0x1035
00000368  0000              add [bx+si],al
0000036A  8D4582            lea ax,[di-0x7e]
0000036D  5A                pop dx
0000036E  59                pop cx
0000036F  50                push ax
00000370  8D45B6            lea ax,[di-0x4a]
00000373  50                push ax
00000374  E8FB0C            call 0x1072
00000377  0000              add [bx+si],al
00000379  8D45B6            lea ax,[di-0x4a]
0000037C  50                push ax
0000037D  8D4582            lea ax,[di-0x7e]
00000380  50                push ax
00000381  8D4587            lea ax,[di-0x79]
00000384  50                push ax
00000385  689D11            push word 0x119d
00000388  0100              add [bx+si],ax
0000038A  E8E106            call 0xa6e
0000038D  0000              add [bx+si],al
0000038F  83C420            add sp,byte +0x20
00000392  E993FD            jmp 0x128
00000395  FF                db 0xff
00000396  FF83EC08          inc word [bp+di+0x8ec]
0000039A  8D458E            lea ax,[di-0x72]
0000039D  50                push ax
0000039E  68FC10            push word 0x10fc
000003A1  0100              add [bx+si],ax
000003A3  E8C806            call 0xa6e
000003A6  0000              add [bx+si],al
000003A8  83C410            add sp,byte +0x10
000003AB  E97AFD            jmp 0x128
000003AE  FF                db 0xff
000003AF  FF6690            jmp [bp-0x70]
000003B2  6690              xchg eax,eax
000003B4  6690              xchg eax,eax
000003B6  6690              xchg eax,eax
000003B8  6690              xchg eax,eax
000003BA  6690              xchg eax,eax
000003BC  6690              xchg eax,eax
000003BE  E83BFD            call 0xfc
000003C1  FF                db 0xff
000003C2  FF                db 0xff
000003C3  FA                cli
000003C4  F4                hlt
000003C5  6690              xchg eax,eax
000003C7  6690              xchg eax,eax
000003C9  6690              xchg eax,eax
000003CB  6690              xchg eax,eax
000003CD  90                nop
000003CE  55                push bp
000003CF  89E5              mov bp,sp
000003D1  53                push bx
000003D2  BBD007            mov bx,0x7d0
000003D5  0000              add [bx+si],al
000003D7  83EC0C            sub sp,byte +0xc
000003DA  6A00              push byte +0x0
000003DC  6A00              push byte +0x0
000003DE  E8A609            call 0xd87
000003E1  0000              add [bx+si],al
000003E3  83C410            add sp,byte +0x10
000003E6  2E8DB42600        lea si,[cs:si+0x26]
000003EB  0000              add [bx+si],al
000003ED  0083EC08          add [bp+di+0x8ec],al
000003F1  6A07              push byte +0x7
000003F3  6A20              push byte +0x20
000003F5  E8A101            call 0x599
000003F8  0000              add [bx+si],al
000003FA  83C410            add sp,byte +0x10
000003FD  83EB01            sub bx,byte +0x1
00000400  75EC              jnz 0x3ee
00000402  83EC08            sub sp,byte +0x8
00000405  6A00              push byte +0x0
00000407  6A00              push byte +0x0
00000409  E87B09            call 0xd87
0000040C  0000              add [bx+si],al
0000040E  8B5DFC            mov bx,[di-0x4]
00000411  83C410            add sp,byte +0x10
00000414  C9                leave
00000415  C3                ret
00000416  55                push bp
00000417  89E5              mov bp,sp
00000419  83EC14            sub sp,byte +0x14
0000041C  8B4508            mov ax,[di+0x8]
0000041F  8845EC            mov [di-0x14],al
00000422  0FB645EC          movzx ax,[di-0x14]
00000426  83E00F            and ax,byte +0xf
00000429  8845FF            mov [di-0x1],al
0000042C  0FB645EC          movzx ax,[di-0x14]
00000430  C0E804            shr al,byte 0x4
00000433  8845FE            mov [di-0x2],al
00000436  0FB645FF          movzx ax,[di-0x1]
0000043A  3A45FE            cmp al,[di-0x2]
0000043D  7409              jz 0x448
0000043F  0FB645EC          movzx ax,[di-0x14]
00000443  A22022            mov [0x2220],al
00000446  0100              add [bx+si],ax
00000448  90                nop
00000449  C9                leave
0000044A  C3                ret
0000044B  55                push bp
0000044C  89E5              mov bp,sp
0000044E  83EC10            sub sp,byte +0x10
00000451  C745FC0080        mov word [di-0x4],0x8000
00000456  0B00              or ax,[bx+si]
00000458  0FB605            movzx ax,[di]
0000045B  40                inc ax
0000045C  2401              and al,0x1
0000045E  000F              add [bx],cl
00000460  B6C0              mov dh,0xc0
00000462  01C0              add ax,ax
00000464  89C2              mov dx,ax
00000466  8B45FC            mov ax,[di-0x4]
00000469  01D0              add ax,dx
0000046B  8945F8            mov [di-0x8],ax
0000046E  0FB605            movzx ax,[di]
00000471  40                inc ax
00000472  2401              and al,0x1
00000474  000F              add [bx],cl
00000476  B6D0              mov dh,0xd0
00000478  0FB605            movzx ax,[di]
0000047B  41                inc cx
0000047C  2401              and al,0x1
0000047E  000F              add [bx],cl
00000480  B6C0              mov dh,0xc0
00000482  0FAFC2            imul ax,dx
00000485  0FB615            movzx dx,[di]
00000488  40                inc ax
00000489  2401              and al,0x1
0000048B  000F              add [bx],cl
0000048D  B6D2              mov dh,0xd2
0000048F  29D0              sub ax,dx
00000491  01C0              add ax,ax
00000493  8945F0            mov [di-0x10],ax
00000496  C745F40000        mov word [di-0xc],0x0
0000049B  0000              add [bx+si],al
0000049D  EB17              jmp short 0x4b6
0000049F  8B45F8            mov ax,[di-0x8]
000004A2  0FB610            movzx dx,[bx+si]
000004A5  8B45FC            mov ax,[di-0x4]
000004A8  8810              mov [bx+si],dl
000004AA  8345F801          add word [di-0x8],byte +0x1
000004AE  8345FC01          add word [di-0x4],byte +0x1
000004B2  8345F401          add word [di-0xc],byte +0x1
000004B6  8B45F4            mov ax,[di-0xc]
000004B9  3B45F0            cmp ax,[di-0x10]
000004BC  72E1              jc 0x49f
000004BE  C60541            mov byte [di],0x41
000004C1  2401              and al,0x1
000004C3  0017              add [bx],dl
000004C5  90                nop
000004C6  C9                leave
000004C7  C3                ret
000004C8  55                push bp
000004C9  89E5              mov bp,sp
000004CB  83EC18            sub sp,byte +0x18
000004CE  8B5508            mov dx,[di+0x8]
000004D1  8B450C            mov ax,[di+0xc]
000004D4  8855EC            mov [di-0x14],dl
000004D7  8845E8            mov [di-0x18],al
000004DA  0FB605            movzx ax,[di]
000004DD  41                inc cx
000004DE  2401              and al,0x1
000004E0  000F              add [bx],cl
000004E2  B6D0              mov dh,0xd0
000004E4  89D0              mov ax,dx
000004E6  C1E002            shl ax,byte 0x2
000004E9  01D0              add ax,dx
000004EB  C1E004            shl ax,byte 0x4
000004EE  89C2              mov dx,ax
000004F0  0FB605            movzx ax,[di]
000004F3  40                inc ax
000004F4  2401              and al,0x1
000004F6  000F              add [bx],cl
000004F8  B6C0              mov dh,0xc0
000004FA  01D0              add ax,dx
000004FC  01C0              add ax,ax
000004FE  8945FC            mov [di-0x4],ax
00000501  C745F80080        mov word [di-0x8],0x8000
00000506  0B00              or ax,[bx+si]
00000508  0FBE45EC          movsx ax,[di-0x14]
0000050C  83F80A            cmp ax,byte +0xa
0000050F  740E              jz 0x51f
00000511  83F80D            cmp ax,byte +0xd
00000514  751A              jnz 0x530
00000516  C60540            mov byte [di],0x40
00000519  2401              and al,0x1
0000051B  0000              add [bx+si],al
0000051D  EB41              jmp short 0x560
0000051F  0FB605            movzx ax,[di]
00000522  41                inc cx
00000523  2401              and al,0x1
00000525  0083C001          add [bp+di+0x1c0],al
00000529  A24124            mov [0x2441],al
0000052C  0100              add [bx+si],ax
0000052E  EB30              jmp short 0x560
00000530  8B55F8            mov dx,[di-0x8]
00000533  8B45FC            mov ax,[di-0x4]
00000536  01D0              add ax,dx
00000538  8945F4            mov [di-0xc],ax
0000053B  8B45F4            mov ax,[di-0xc]
0000053E  0FB655EC          movzx dx,[di-0x14]
00000542  8810              mov [bx+si],dl
00000544  8B45F4            mov ax,[di-0xc]
00000547  8D5001            lea dx,[bx+si+0x1]
0000054A  0FB645E8          movzx ax,[di-0x18]
0000054E  8802              mov [bp+si],al
00000550  0FB605            movzx ax,[di]
00000553  40                inc ax
00000554  2401              and al,0x1
00000556  0083C001          add [bp+di+0x1c0],al
0000055A  A24024            mov [0x2440],al
0000055D  0100              add [bx+si],ax
0000055F  90                nop
00000560  0FB605            movzx ax,[di]
00000563  40                inc ax
00000564  2401              and al,0x1
00000566  003C              add [si],bh
00000568  50                push ax
00000569  7516              jnz 0x581
0000056B  C60540            mov byte [di],0x40
0000056E  2401              and al,0x1
00000570  0000              add [bx+si],al
00000572  0FB605            movzx ax,[di]
00000575  41                inc cx
00000576  2401              and al,0x1
00000578  0083C001          add [bp+di+0x1c0],al
0000057C  A24124            mov [0x2441],al
0000057F  0100              add [bx+si],ax
00000581  0FB605            movzx ax,[di]
00000584  41                inc cx
00000585  2401              and al,0x1
00000587  003C              add [si],bh
00000589  16                push ss
0000058A  760C              jna 0x598
0000058C  C60541            mov byte [di],0x41
0000058F  2401              and al,0x1
00000591  0017              add [bx],dl
00000593  E8B3FE            call 0x449
00000596  FF                db 0xff
00000597  FF90C9C3          call [bx+si-0x3c37]
0000059B  55                push bp
0000059C  89E5              mov bp,sp
0000059E  83EC18            sub sp,byte +0x18
000005A1  8B5508            mov dx,[di+0x8]
000005A4  8B450C            mov ax,[di+0xc]
000005A7  8855F4            mov [di-0xc],dl
000005AA  8845F0            mov [di-0x10],al
000005AD  0FB655F0          movzx dx,[di-0x10]
000005B1  0FBE45F4          movsx ax,[di-0xc]
000005B5  52                push dx
000005B6  50                push ax
000005B7  E80CFF            call 0x4c6
000005BA  FF                db 0xff
000005BB  FF83C408          inc word [bp+di+0x8c4]
000005BF  0FB605            movzx ax,[di]
000005C2  41                inc cx
000005C3  2401              and al,0x1
000005C5  000F              add [bx],cl
000005C7  B6D0              mov dh,0xd0
000005C9  0FB605            movzx ax,[di]
000005CC  40                inc ax
000005CD  2401              and al,0x1
000005CF  000F              add [bx],cl
000005D1  B6C0              mov dh,0xc0
000005D3  83EC08            sub sp,byte +0x8
000005D6  52                push dx
000005D7  50                push ax
000005D8  E8AC07            call 0xd87
000005DB  0000              add [bx+si],al
000005DD  83C410            add sp,byte +0x10
000005E0  90                nop
000005E1  C9                leave
000005E2  C3                ret
000005E3  55                push bp
000005E4  89E5              mov bp,sp
000005E6  83EC18            sub sp,byte +0x18
000005E9  C745F40000        mov word [di-0xc],0x0
000005EE  0000              add [bx+si],al
000005F0  EB25              jmp short 0x617
000005F2  0FB605            movzx ax,[di]
000005F5  2022              and [bp+si],ah
000005F7  0100              add [bx+si],ax
000005F9  0FB6D0            movzx dx,al
000005FC  8B4508            mov ax,[di+0x8]
000005FF  0FB600            movzx ax,[bx+si]
00000602  0FBEC0            movsx ax,al
00000605  52                push dx
00000606  50                push ax
00000607  E8BCFE            call 0x4c6
0000060A  FF                db 0xff
0000060B  FF83C408          inc word [bp+di+0x8c4]
0000060F  83450801          add word [di+0x8],byte +0x1
00000613  8345F401          add word [di-0xc],byte +0x1
00000617  8B4508            mov ax,[di+0x8]
0000061A  0FB600            movzx ax,[bx+si]
0000061D  84C0              test al,al
0000061F  75D1              jnz 0x5f2
00000621  0FB605            movzx ax,[di]
00000624  41                inc cx
00000625  2401              and al,0x1
00000627  000F              add [bx],cl
00000629  B6D0              mov dh,0xd0
0000062B  0FB605            movzx ax,[di]
0000062E  40                inc ax
0000062F  2401              and al,0x1
00000631  000F              add [bx],cl
00000633  B6C0              mov dh,0xc0
00000635  83EC08            sub sp,byte +0x8
00000638  52                push dx
00000639  50                push ax
0000063A  E84A07            call 0xd87
0000063D  0000              add [bx+si],al
0000063F  83C410            add sp,byte +0x10
00000642  8B45F4            mov ax,[di-0xc]
00000645  C9                leave
00000646  C3                ret
00000647  55                push bp
00000648  89E5              mov bp,sp
0000064A  83EC18            sub sp,byte +0x18
0000064D  83EC0C            sub sp,byte +0xc
00000650  FF7508            push word [di+0x8]
00000653  E88BFF            call 0x5e1
00000656  FF                db 0xff
00000657  FF83C410          inc word [bp+di+0x10c4]
0000065B  8945F4            mov [di-0xc],ax
0000065E  0FB605            movzx ax,[di]
00000661  2022              and [bp+si],ah
00000663  0100              add [bx+si],ax
00000665  0FB6C0            movzx ax,al
00000668  83EC08            sub sp,byte +0x8
0000066B  50                push ax
0000066C  6A0D              push byte +0xd
0000066E  E828FF            call 0x599
00000671  FF                db 0xff
00000672  FF83C410          inc word [bp+di+0x10c4]
00000676  0FB605            movzx ax,[di]
00000679  2022              and [bp+si],ah
0000067B  0100              add [bx+si],ax
0000067D  0FB6C0            movzx ax,al
00000680  83EC08            sub sp,byte +0x8
00000683  50                push ax
00000684  6A0A              push byte +0xa
00000686  E810FF            call 0x599
00000689  FF                db 0xff
0000068A  FF83C410          inc word [bp+di+0x10c4]
0000068E  8B45F4            mov ax,[di-0xc]
00000691  83C002            add ax,byte +0x2
00000694  C9                leave
00000695  C3                ret
00000696  55                push bp
00000697  89E5              mov bp,sp
00000699  83EC20            sub sp,byte +0x20
0000069C  C745FC0000        mov word [di-0x4],0x0
000006A1  0000              add [bx+si],al
000006A3  C745F80000        mov word [di-0x8],0x0
000006A8  0000              add [bx+si],al
000006AA  837D0800          cmp word [di+0x8],byte +0x0
000006AE  7514              jnz 0x6c4
000006B0  8B450C            mov ax,[di+0xc]
000006B3  C60030            mov byte [bx+si],0x30
000006B6  8B450C            mov ax,[di+0xc]
000006B9  83C001            add ax,byte +0x1
000006BC  C60000            mov byte [bx+si],0x0
000006BF  E9CF00            jmp 0x791
000006C2  0000              add [bx+si],al
000006C4  837D0800          cmp word [di+0x8],byte +0x0
000006C8  7950              jns 0x71a
000006CA  837D100A          cmp word [di+0x10],byte +0xa
000006CE  754A              jnz 0x71a
000006D0  F75D08            neg word [di+0x8]
000006D3  C745FC0100        mov word [di-0x4],0x1
000006D8  0000              add [bx+si],al
000006DA  EB3E              jmp short 0x71a
000006DC  8B4508            mov ax,[di+0x8]
000006DF  99                cwd
000006E0  F77D10            idiv word [di+0x10]
000006E3  8955E8            mov [di-0x18],dx
000006E6  837DE809          cmp word [di-0x18],byte +0x9
000006EA  7E0A              jng 0x6f6
000006EC  8B45E8            mov ax,[di-0x18]
000006EF  83C057            add ax,byte +0x57
000006F2  89C1              mov cx,ax
000006F4  EB08              jmp short 0x6fe
000006F6  8B45E8            mov ax,[di-0x18]
000006F9  83C030            add ax,byte +0x30
000006FC  89C1              mov cx,ax
000006FE  8B45F8            mov ax,[di-0x8]
00000701  8D5001            lea dx,[bx+si+0x1]
00000704  8955F8            mov [di-0x8],dx
00000707  89C2              mov dx,ax
00000709  8B450C            mov ax,[di+0xc]
0000070C  01D0              add ax,dx
0000070E  8808              mov [bx+si],cl
00000710  8B4508            mov ax,[di+0x8]
00000713  99                cwd
00000714  F77D10            idiv word [di+0x10]
00000717  894508            mov [di+0x8],ax
0000071A  837D0800          cmp word [di+0x8],byte +0x0
0000071E  75BC              jnz 0x6dc
00000720  837DFC00          cmp word [di-0x4],byte +0x0
00000724  7E0F              jng 0x735
00000726  8B55F8            mov dx,[di-0x8]
00000729  8B450C            mov ax,[di+0xc]
0000072C  01D0              add ax,dx
0000072E  C6002D            mov byte [bx+si],0x2d
00000731  8345F801          add word [di-0x8],byte +0x1
00000735  C745F40000        mov word [di-0xc],0x0
0000073A  0000              add [bx+si],al
0000073C  8B45F8            mov ax,[di-0x8]
0000073F  83E801            sub ax,byte +0x1
00000742  8945F0            mov [di-0x10],ax
00000745  EB39              jmp short 0x780
00000747  8B55F4            mov dx,[di-0xc]
0000074A  8B450C            mov ax,[di+0xc]
0000074D  01D0              add ax,dx
0000074F  0FB600            movzx ax,[bx+si]
00000752  8845EF            mov [di-0x11],al
00000755  8B55F0            mov dx,[di-0x10]
00000758  8B450C            mov ax,[di+0xc]
0000075B  01D0              add ax,dx
0000075D  8B4DF4            mov cx,[di-0xc]
00000760  8B550C            mov dx,[di+0xc]
00000763  01CA              add dx,cx
00000765  0FB600            movzx ax,[bx+si]
00000768  8802              mov [bp+si],al
0000076A  8B55F0            mov dx,[di-0x10]
0000076D  8B450C            mov ax,[di+0xc]
00000770  01C2              add dx,ax
00000772  0FB645EF          movzx ax,[di-0x11]
00000776  8802              mov [bp+si],al
00000778  836DF001          sub word [di-0x10],byte +0x1
0000077C  8345F401          add word [di-0xc],byte +0x1
00000780  8B45F4            mov ax,[di-0xc]
00000783  3B45F0            cmp ax,[di-0x10]
00000786  7CBF              jl 0x747
00000788  8B55F8            mov dx,[di-0x8]
0000078B  8B450C            mov ax,[di+0xc]
0000078E  01D0              add ax,dx
00000790  C60000            mov byte [bx+si],0x0
00000793  C9                leave
00000794  C3                ret
00000795  55                push bp
00000796  89E5              mov bp,sp
00000798  83EC48            sub sp,byte +0x48
0000079B  C745F40000        mov word [di-0xc],0x0
000007A0  0000              add [bx+si],al
000007A2  8B4508            mov ax,[di+0x8]
000007A5  8945F0            mov [di-0x10],ax
000007A8  E98702            jmp 0xa32
000007AB  0000              add [bx+si],al
000007AD  8B450C            mov ax,[di+0xc]
000007B0  0FB600            movzx ax,[bx+si]
000007B3  3C25              cmp al,0x25
000007B5  0F853A02          jnz near 0x9f3
000007B9  0000              add [bx+si],al
000007BB  83450C01          add word [di+0xc],byte +0x1
000007BF  C745EC0000        mov word [di-0x14],0x0
000007C4  0000              add [bx+si],al
000007C6  EB1E              jmp short 0x7e6
000007C8  8B55EC            mov dx,[di-0x14]
000007CB  89D0              mov ax,dx
000007CD  C1E002            shl ax,byte 0x2
000007D0  01D0              add ax,dx
000007D2  01C0              add ax,ax
000007D4  8945EC            mov [di-0x14],ax
000007D7  8B450C            mov ax,[di+0xc]
000007DA  0FB600            movzx ax,[bx+si]
000007DD  0FBEC0            movsx ax,al
000007E0  83E830            sub ax,byte +0x30
000007E3  0145EC            add [di-0x14],ax
000007E6  8B450C            mov ax,[di+0xc]
000007E9  0FB600            movzx ax,[bx+si]
000007EC  3C2F              cmp al,0x2f
000007EE  7E0A              jng 0x7fa
000007F0  8B450C            mov ax,[di+0xc]
000007F3  0FB600            movzx ax,[bx+si]
000007F6  3C39              cmp al,0x39
000007F8  7ECE              jng 0x7c8
000007FA  8B450C            mov ax,[di+0xc]
000007FD  0FB600            movzx ax,[bx+si]
00000800  0FBEC0            movsx ax,al
00000803  83F825            cmp ax,byte +0x25
00000806  0F84AB01          jz near 0x9b5
0000080A  0000              add [bx+si],al
0000080C  83F825            cmp ax,byte +0x25
0000080F  0F8C1B02          jl near 0xa2e
00000813  0000              add [bx+si],al
00000815  83F878            cmp ax,byte +0x78
00000818  0F8F1202          jg near 0xa2e
0000081C  0000              add [bx+si],al
0000081E  83F863            cmp ax,byte +0x63
00000821  0F8C0902          jl near 0xa2e
00000825  0000              add [bx+si],al
00000827  83E863            sub ax,byte +0x63
0000082A  83F815            cmp ax,byte +0x15
0000082D  0F87FD01          ja near 0xa2e
00000831  0000              add [bx+si],al
00000833  8B04              mov ax,[si]
00000835  85AC1101          test [si+0x111],bp
00000839  00FF              add bh,bh
0000083B  E08B              loopne 0x7c8
0000083D  45                inc bp
0000083E  108D5004          adc [di+0x450],cl
00000842  895510            mov [di+0x10],dx
00000845  8B00              mov ax,[bx+si]
00000847  8945DC            mov [di-0x24],ax
0000084A  6A0A              push byte +0xa
0000084C  8D45C7            lea ax,[di-0x39]
0000084F  50                push ax
00000850  FF75DC            push word [di-0x24]
00000853  E83EFE            call 0x694
00000856  FF                db 0xff
00000857  FF83C40C          inc word [bp+di+0xcc4]
0000085B  83EC0C            sub sp,byte +0xc
0000085E  8D45C7            lea ax,[di-0x39]
00000861  50                push ax
00000862  E8AA07            call 0x100f
00000865  0000              add [bx+si],al
00000867  83C410            add sp,byte +0x10
0000086A  0145F4            add [di-0xc],ax
0000086D  837DF000          cmp word [di-0x10],byte +0x0
00000871  0F84A901          jz near 0xa1e
00000875  0000              add [bx+si],al
00000877  83EC08            sub sp,byte +0x8
0000087A  8D45C7            lea ax,[di-0x39]
0000087D  50                push ax
0000087E  FF75F0            push word [di-0x10]
00000881  E8EE07            call 0x1072
00000884  0000              add [bx+si],al
00000886  83C410            add sp,byte +0x10
00000889  E99201            jmp 0xa1e
0000088C  0000              add [bx+si],al
0000088E  8B4510            mov ax,[di+0x10]
00000891  8D5004            lea dx,[bx+si+0x4]
00000894  895510            mov [di+0x10],dx
00000897  8B00              mov ax,[bx+si]
00000899  8945E0            mov [di-0x20],ax
0000089C  8B45E0            mov ax,[di-0x20]
0000089F  83EC04            sub sp,byte +0x4
000008A2  6A08              push byte +0x8
000008A4  8D55C7            lea dx,[di-0x39]
000008A7  52                push dx
000008A8  50                push ax
000008A9  E8E8FD            call 0x694
000008AC  FF                db 0xff
000008AD  FF83C410          inc word [bp+di+0x10c4]
000008B1  83EC0C            sub sp,byte +0xc
000008B4  8D45C7            lea ax,[di-0x39]
000008B7  50                push ax
000008B8  E85407            call 0x100f
000008BB  0000              add [bx+si],al
000008BD  83C410            add sp,byte +0x10
000008C0  0145F4            add [di-0xc],ax
000008C3  837DF000          cmp word [di-0x10],byte +0x0
000008C7  0F845601          jz near 0xa21
000008CB  0000              add [bx+si],al
000008CD  83EC08            sub sp,byte +0x8
000008D0  8D45C7            lea ax,[di-0x39]
000008D3  50                push ax
000008D4  FF75F0            push word [di-0x10]
000008D7  E89807            call 0x1072
000008DA  0000              add [bx+si],al
000008DC  83C410            add sp,byte +0x10
000008DF  E93F01            jmp 0xa21
000008E2  0000              add [bx+si],al
000008E4  8B4510            mov ax,[di+0x10]
000008E7  8D5004            lea dx,[bx+si+0x4]
000008EA  895510            mov [di+0x10],dx
000008ED  8B00              mov ax,[bx+si]
000008EF  8945E8            mov [di-0x18],ax
000008F2  8B45E8            mov ax,[di-0x18]
000008F5  83EC04            sub sp,byte +0x4
000008F8  6A10              push byte +0x10
000008FA  8D55C7            lea dx,[di-0x39]
000008FD  52                push dx
000008FE  50                push ax
000008FF  E892FD            call 0x694
00000902  FF                db 0xff
00000903  FF83C410          inc word [bp+di+0x10c4]
00000907  83EC0C            sub sp,byte +0xc
0000090A  8D45C7            lea ax,[di-0x39]
0000090D  50                push ax
0000090E  E8FE06            call 0x100f
00000911  0000              add [bx+si],al
00000913  83C410            add sp,byte +0x10
00000916  0145F4            add [di-0xc],ax
00000919  837DF000          cmp word [di-0x10],byte +0x0
0000091D  0F840301          jz near 0xa24
00000921  0000              add [bx+si],al
00000923  83EC08            sub sp,byte +0x8
00000926  8D45C7            lea ax,[di-0x39]
00000929  50                push ax
0000092A  FF75F0            push word [di-0x10]
0000092D  E84207            call 0x1072
00000930  0000              add [bx+si],al
00000932  83C410            add sp,byte +0x10
00000935  E9EC00            jmp 0xa24
00000938  0000              add [bx+si],al
0000093A  8B4510            mov ax,[di+0x10]
0000093D  8D5004            lea dx,[bx+si+0x4]
00000940  895510            mov [di+0x10],dx
00000943  8B00              mov ax,[bx+si]
00000945  8945E4            mov [di-0x1c],ax
00000948  83EC0C            sub sp,byte +0xc
0000094B  FF75E4            push word [di-0x1c]
0000094E  E8BE06            call 0x100f
00000951  0000              add [bx+si],al
00000953  83C410            add sp,byte +0x10
00000956  0145F4            add [di-0xc],ax
00000959  837DF000          cmp word [di-0x10],byte +0x0
0000095D  0F84C600          jz near 0xa27
00000961  0000              add [bx+si],al
00000963  83EC08            sub sp,byte +0x8
00000966  FF75E4            push word [di-0x1c]
00000969  FF75F0            push word [di-0x10]
0000096C  E80307            call 0x1072
0000096F  0000              add [bx+si],al
00000971  83C410            add sp,byte +0x10
00000974  E9B000            jmp 0xa27
00000977  0000              add [bx+si],al
00000979  8B4510            mov ax,[di+0x10]
0000097C  8D5004            lea dx,[bx+si+0x4]
0000097F  895510            mov [di+0x10],dx
00000982  8B00              mov ax,[bx+si]
00000984  8845DB            mov [di-0x25],al
00000987  0FB645DB          movzx ax,[di-0x25]
0000098B  8845C7            mov [di-0x39],al
0000098E  C645C800          mov byte [di-0x38],0x0
00000992  8345F401          add word [di-0xc],byte +0x1
00000996  837DF000          cmp word [di-0x10],byte +0x0
0000099A  0F848C00          jz near 0xa2a
0000099E  0000              add [bx+si],al
000009A0  83EC08            sub sp,byte +0x8
000009A3  8D45C7            lea ax,[di-0x39]
000009A6  50                push ax
000009A7  FF75F0            push word [di-0x10]
000009AA  E8C506            call 0x1072
000009AD  0000              add [bx+si],al
000009AF  83C410            add sp,byte +0x10
000009B2  8945F0            mov [di-0x10],ax
000009B5  EB75              jmp short 0xa2c
000009B7  0FB605            movzx ax,[di]
000009BA  2022              and [bp+si],ah
000009BC  0100              add [bx+si],ax
000009BE  0FB6C0            movzx ax,al
000009C1  83EC08            sub sp,byte +0x8
000009C4  50                push ax
000009C5  6A25              push byte +0x25
000009C7  E8CFFB            call 0x599
000009CA  FF                db 0xff
000009CB  FF83C410          inc word [bp+di+0x10c4]
000009CF  C645C725          mov byte [di-0x39],0x25
000009D3  C645C800          mov byte [di-0x38],0x0
000009D7  8345F401          add word [di-0xc],byte +0x1
000009DB  837DF000          cmp word [di-0x10],byte +0x0
000009DF  744E              jz 0xa2f
000009E1  83EC08            sub sp,byte +0x8
000009E4  8D45C7            lea ax,[di-0x39]
000009E7  50                push ax
000009E8  FF75F0            push word [di-0x10]
000009EB  E88406            call 0x1072
000009EE  0000              add [bx+si],al
000009F0  83C410            add sp,byte +0x10
000009F3  EB3A              jmp short 0xa2f
000009F5  8B450C            mov ax,[di+0xc]
000009F8  0FB600            movzx ax,[bx+si]
000009FB  8845C7            mov [di-0x39],al
000009FE  C645C800          mov byte [di-0x38],0x0
00000A02  8345F401          add word [di-0xc],byte +0x1
00000A06  837DF000          cmp word [di-0x10],byte +0x0
00000A0A  7424              jz 0xa30
00000A0C  83EC08            sub sp,byte +0x8
00000A0F  8D45C7            lea ax,[di-0x39]
00000A12  50                push ax
00000A13  FF75F0            push word [di-0x10]
00000A16  E85906            call 0x1072
00000A19  0000              add [bx+si],al
00000A1B  83C410            add sp,byte +0x10
00000A1E  EB10              jmp short 0xa30
00000A20  90                nop
00000A21  EB0D              jmp short 0xa30
00000A23  90                nop
00000A24  EB0A              jmp short 0xa30
00000A26  90                nop
00000A27  EB07              jmp short 0xa30
00000A29  90                nop
00000A2A  EB04              jmp short 0xa30
00000A2C  90                nop
00000A2D  EB01              jmp short 0xa30
00000A2F  90                nop
00000A30  83450C01          add word [di+0xc],byte +0x1
00000A34  8B450C            mov ax,[di+0xc]
00000A37  0FB600            movzx ax,[bx+si]
00000A3A  84C0              test al,al
00000A3C  0F856BFD          jnz near 0x7ab
00000A40  FF                db 0xff
00000A41  FF8B45F4          dec word [bp+di-0xbbb]
00000A45  C9                leave
00000A46  C3                ret
00000A47  55                push bp
00000A48  89E5              mov bp,sp
00000A4A  83EC18            sub sp,byte +0x18
00000A4D  8D4510            lea ax,[di+0x10]
00000A50  8945F0            mov [di-0x10],ax
00000A53  8B45F0            mov ax,[di-0x10]
00000A56  83EC04            sub sp,byte +0x4
00000A59  50                push ax
00000A5A  FF750C            push word [di+0xc]
00000A5D  FF7508            push word [di+0x8]
00000A60  E830FD            call 0x793
00000A63  FF                db 0xff
00000A64  FF83C410          inc word [bp+di+0x10c4]
00000A68  8945F4            mov [di-0xc],ax
00000A6B  8B45F4            mov ax,[di-0xc]
00000A6E  C9                leave
00000A6F  C3                ret
00000A70  55                push bp
00000A71  89E5              mov bp,sp
00000A73  53                push bx
00000A74  83EC14            sub sp,byte +0x14
00000A77  89E0              mov ax,sp
00000A79  89C3              mov bx,ax
00000A7B  8D450C            lea ax,[di+0xc]
00000A7E  8945E8            mov [di-0x18],ax
00000A81  8B45E8            mov ax,[di-0x18]
00000A84  83EC04            sub sp,byte +0x4
00000A87  50                push ax
00000A88  FF7508            push word [di+0x8]
00000A8B  6A00              push byte +0x0
00000A8D  E803FD            call 0x793
00000A90  FF                db 0xff
00000A91  FF83C410          inc word [bp+di+0x10c4]
00000A95  8945F4            mov [di-0xc],ax
00000A98  8B45F4            mov ax,[di-0xc]
00000A9B  83C001            add ax,byte +0x1
00000A9E  8D50FF            lea dx,[bx+si-0x1]
00000AA1  8955F0            mov [di-0x10],dx
00000AA4  89C2              mov dx,ax
00000AA6  B81000            mov ax,0x10
00000AA9  0000              add [bx+si],al
00000AAB  83E801            sub ax,byte +0x1
00000AAE  01D0              add ax,dx
00000AB0  B91000            mov cx,0x10
00000AB3  0000              add [bx+si],al
00000AB5  BA0000            mov dx,0x0
00000AB8  0000              add [bx+si],al
00000ABA  F7F1              div cx
00000ABC  6BC010            imul ax,ax,byte +0x10
00000ABF  29C4              sub sp,ax
00000AC1  89E0              mov ax,sp
00000AC3  83C000            add ax,byte +0x0
00000AC6  8945EC            mov [di-0x14],ax
00000AC9  8B45E8            mov ax,[di-0x18]
00000ACC  83EC04            sub sp,byte +0x4
00000ACF  50                push ax
00000AD0  FF7508            push word [di+0x8]
00000AD3  FF75EC            push word [di-0x14]
00000AD6  E8BAFC            call 0x793
00000AD9  FF                db 0xff
00000ADA  FF83C410          inc word [bp+di+0x10c4]
00000ADE  8945F4            mov [di-0xc],ax
00000AE1  8B45F4            mov ax,[di-0xc]
00000AE4  89DC              mov sp,bx
00000AE6  8B5DFC            mov bx,[di-0x4]
00000AE9  C9                leave
00000AEA  C3                ret
00000AEB  55                push bp
00000AEC  89E5              mov bp,sp
00000AEE  83EC08            sub sp,byte +0x8
00000AF1  EB0D              jmp short 0xb00
00000AF3  83EC0C            sub sp,byte +0xc
00000AF6  6A21              push byte +0x21
00000AF8  E84E04            call 0xf49
00000AFB  0000              add [bx+si],al
00000AFD  83C410            add sp,byte +0x10
00000B00  83EC0C            sub sp,byte +0xc
00000B03  6A64              push byte +0x64
00000B05  E81406            call 0x111c
00000B08  0000              add [bx+si],al
00000B0A  83C410            add sp,byte +0x10
00000B0D  0FB6C0            movzx ax,al
00000B10  83E001            and ax,byte +0x1
00000B13  85C0              test ax,ax
00000B15  74DC              jz 0xaf3
00000B17  83EC0C            sub sp,byte +0xc
00000B1A  6A60              push byte +0x60
00000B1C  E8FD05            call 0x111c
00000B1F  0000              add [bx+si],al
00000B21  83C410            add sp,byte +0x10
00000B24  C9                leave
00000B25  C3                ret
00000B26  55                push bp
00000B27  89E5              mov bp,sp
00000B29  83EC18            sub sp,byte +0x18
00000B2C  8B4508            mov ax,[di+0x8]
00000B2F  8845F4            mov [di-0xc],al
00000B32  90                nop
00000B33  83EC0C            sub sp,byte +0xc
00000B36  6A64              push byte +0x64
00000B38  E8E105            call 0x111c
00000B3B  0000              add [bx+si],al
00000B3D  83C410            add sp,byte +0x10
00000B40  0FB6C0            movzx ax,al
00000B43  83E002            and ax,byte +0x2
00000B46  85C0              test ax,ax
00000B48  7FE9              jg 0xb33
00000B4A  0FB645F4          movzx ax,[di-0xc]
00000B4E  83EC08            sub sp,byte +0x8
00000B51  50                push ax
00000B52  6A64              push byte +0x64
00000B54  E8E205            call 0x1139
00000B57  0000              add [bx+si],al
00000B59  83C410            add sp,byte +0x10
00000B5C  90                nop
00000B5D  C9                leave
00000B5E  C3                ret
00000B5F  55                push bp
00000B60  89E5              mov bp,sp
00000B62  83EC08            sub sp,byte +0x8
00000B65  83EC0C            sub sp,byte +0xc
00000B68  68AD00            push word 0xad
00000B6B  0000              add [bx+si],al
00000B6D  E8B4FF            call 0xb24
00000B70  FF                db 0xff
00000B71  FF83C410          inc word [bp+di+0x10c4]
00000B75  83EC0C            sub sp,byte +0xc
00000B78  6A60              push byte +0x60
00000B7A  E89F05            call 0x111c
00000B7D  0000              add [bx+si],al
00000B7F  83C410            add sp,byte +0x10
00000B82  83EC0C            sub sp,byte +0xc
00000B85  68AE00            push word 0xae
00000B88  0000              add [bx+si],al
00000B8A  E897FF            call 0xb24
00000B8D  FF                db 0xff
00000B8E  FF83C410          inc word [bp+di+0x10c4]
00000B92  90                nop
00000B93  C9                leave
00000B94  C3                ret
00000B95  55                push bp
00000B96  89E5              mov bp,sp
00000B98  83EC18            sub sp,byte +0x18
00000B9B  E84BFF            call 0xae9
00000B9E  FF                db 0xff
00000B9F  FF8845F7          dec word [bx+si-0x8bb]
00000BA3  0FB645F7          movzx ax,[di-0x9]
00000BA7  0FBEC0            movsx ax,al
00000BAA  83EC0C            sub sp,byte +0xc
00000BAD  50                push ax
00000BAE  E89803            call 0xf49
00000BB1  0000              add [bx+si],al
00000BB3  83C410            add sp,byte +0x10
00000BB6  8B4508            mov ax,[di+0x8]
00000BB9  0FB655F7          movzx dx,[di-0x9]
00000BBD  885001            mov [bx+si+0x1],dl
00000BC0  8B4508            mov ax,[di+0x8]
00000BC3  C60000            mov byte [bx+si],0x0
00000BC6  8B4508            mov ax,[di+0x8]
00000BC9  0FB64001          movzx ax,[bx+si+0x1]
00000BCD  0FB6C0            movzx ax,al
00000BD0  3DB600            cmp ax,0xb6
00000BD3  0000              add [bx+si],al
00000BD5  7435              jz 0xc0c
00000BD7  3DB600            cmp ax,0xb6
00000BDA  0000              add [bx+si],al
00000BDC  7F42              jg 0xc20
00000BDE  3DAA00            cmp ax,0xaa
00000BE1  0000              add [bx+si],al
00000BE3  7427              jz 0xc0c
00000BE5  3DAA00            cmp ax,0xaa
00000BE8  0000              add [bx+si],al
00000BEA  7F34              jg 0xc20
00000BEC  83F839            cmp ax,byte +0x39
00000BEF  7427              jz 0xc18
00000BF1  83F839            cmp ax,byte +0x39
00000BF4  7F2A              jg 0xc20
00000BF6  83F82A            cmp ax,byte +0x2a
00000BF9  7405              jz 0xc00
00000BFB  83F836            cmp ax,byte +0x36
00000BFE  7520              jnz 0xc20
00000C00  C7054424          mov word [di],0x2444
00000C04  0100              add [bx+si],ax
00000C06  0100              add [bx+si],ax
00000C08  0000              add [bx+si],al
00000C0A  EB4D              jmp short 0xc59
00000C0C  C7054424          mov word [di],0x2444
00000C10  0100              add [bx+si],ax
00000C12  0000              add [bx+si],al
00000C14  0000              add [bx+si],al
00000C16  EB41              jmp short 0xc59
00000C18  8B4508            mov ax,[di+0x8]
00000C1B  C60020            mov byte [bx+si],0x20
00000C1E  EB39              jmp short 0xc59
00000C20  A14424            mov ax,[0x2444]
00000C23  0100              add [bx+si],ax
00000C25  83F801            cmp ax,byte +0x1
00000C28  7518              jnz 0xc42
00000C2A  8B4508            mov ax,[di+0x8]
00000C2D  0FB64001          movzx ax,[bx+si+0x1]
00000C31  0FB6C0            movzx ax,al
00000C34  0FB6904023        movzx dx,[bx+si+0x2340]
00000C39  0100              add [bx+si],ax
00000C3B  8B4508            mov ax,[di+0x8]
00000C3E  8810              mov [bx+si],dl
00000C40  EB16              jmp short 0xc58
00000C42  8B4508            mov ax,[di+0x8]
00000C45  0FB64001          movzx ax,[bx+si+0x1]
00000C49  0FB6C0            movzx ax,al
00000C4C  0FB6904022        movzx dx,[bx+si+0x2240]
00000C51  0100              add [bx+si],ax
00000C53  8B4508            mov ax,[di+0x8]
00000C56  8810              mov [bx+si],dl
00000C58  90                nop
00000C59  90                nop
00000C5A  C9                leave
00000C5B  C3                ret
00000C5C  55                push bp
00000C5D  89E5              mov bp,sp
00000C5F  83EC18            sub sp,byte +0x18
00000C62  C645F600          mov byte [di-0xa],0x0
00000C66  C645F700          mov byte [di-0x9],0x0
00000C6A  83EC0C            sub sp,byte +0xc
00000C6D  8D45F6            lea ax,[di-0xa]
00000C70  50                push ax
00000C71  E81FFF            call 0xb93
00000C74  FF                db 0xff
00000C75  FF83C410          inc word [bp+di+0x10c4]
00000C79  0FB645F6          movzx ax,[di-0xa]
00000C7D  C9                leave
00000C7E  C3                ret
00000C7F  55                push bp
00000C80  89E5              mov bp,sp
00000C82  83EC18            sub sp,byte +0x18
00000C85  C745F40000        mov word [di-0xc],0x0
00000C8A  0000              add [bx+si],al
00000C8C  C645F200          mov byte [di-0xe],0x0
00000C90  C645F300          mov byte [di-0xd],0x0
00000C94  83EC0C            sub sp,byte +0xc
00000C97  8D45F2            lea ax,[di-0xe]
00000C9A  50                push ax
00000C9B  E8F5FE            call 0xb93
00000C9E  FF                db 0xff
00000C9F  FF83C410          inc word [bp+di+0x10c4]
00000CA3  0FB645F3          movzx ax,[di-0xd]
00000CA7  3C1C              cmp al,0x1c
00000CA9  7513              jnz 0xcbe
00000CAB  8B55F4            mov dx,[di-0xc]
00000CAE  8B4508            mov ax,[di+0x8]
00000CB1  01D0              add ax,dx
00000CB3  C60000            mov byte [bx+si],0x0
00000CB6  8B45F4            mov ax,[di-0xc]
00000CB9  E9C900            jmp 0xd85
00000CBC  0000              add [bx+si],al
00000CBE  0FB645F3          movzx ax,[di-0xd]
00000CC2  3C0E              cmp al,0xe
00000CC4  7571              jnz 0xd37
00000CC6  837DF400          cmp word [di-0xc],byte +0x0
00000CCA  7EC0              jng 0xc8c
00000CCC  836DF401          sub word [di-0xc],byte +0x1
00000CD0  0FB605            movzx ax,[di]
00000CD3  40                inc ax
00000CD4  2401              and al,0x1
00000CD6  0083E801          add [bp+di+0x1e8],al
00000CDA  A24024            mov [0x2440],al
00000CDD  0100              add [bx+si],ax
00000CDF  0FB605            movzx ax,[di]
00000CE2  2022              and [bp+si],ah
00000CE4  0100              add [bx+si],ax
00000CE6  0FB6C0            movzx ax,al
00000CE9  83EC08            sub sp,byte +0x8
00000CEC  50                push ax
00000CED  6A20              push byte +0x20
00000CEF  E8A7F8            call 0x599
00000CF2  FF                db 0xff
00000CF3  FF83C410          inc word [bp+di+0x10c4]
00000CF7  0FB605            movzx ax,[di]
00000CFA  40                inc ax
00000CFB  2401              and al,0x1
00000CFD  0083E801          add [bp+di+0x1e8],al
00000D01  A24024            mov [0x2440],al
00000D04  0100              add [bx+si],ax
00000D06  0FB605            movzx ax,[di]
00000D09  41                inc cx
00000D0A  2401              and al,0x1
00000D0C  000F              add [bx],cl
00000D0E  B6D0              mov dh,0xd0
00000D10  0FB605            movzx ax,[di]
00000D13  40                inc ax
00000D14  2401              and al,0x1
00000D16  000F              add [bx],cl
00000D18  B6C0              mov dh,0xc0
00000D1A  83EC08            sub sp,byte +0x8
00000D1D  52                push dx
00000D1E  50                push ax
00000D1F  E86500            call 0xd87
00000D22  0000              add [bx+si],al
00000D24  83C410            add sp,byte +0x10
00000D27  8B55F4            mov dx,[di-0xc]
00000D2A  8B4508            mov ax,[di+0x8]
00000D2D  01D0              add ax,dx
00000D2F  C60000            mov byte [bx+si],0x0
00000D32  E955FF            jmp 0xc8a
00000D35  FF                db 0xff
00000D36  FF0F              dec word [bx]
00000D38  B645              mov dh,0x45
00000D3A  F284C0            repne test al,al
00000D3D  0F8449FF          jz near 0xc8a
00000D41  FF                db 0xff
00000D42  FF8B450C          dec word [bp+di+0xc45]
00000D46  83E801            sub ax,byte +0x1
00000D49  3945F4            cmp [di-0xc],ax
00000D4C  0F8D3AFF          jnl near 0xc8a
00000D50  FF                db 0xff
00000D51  FF8B55F4          dec word [bp+di-0xbab]
00000D55  8B4508            mov ax,[di+0x8]
00000D58  01C2              add dx,ax
00000D5A  0FB645F2          movzx ax,[di-0xe]
00000D5E  8802              mov [bp+si],al
00000D60  8345F401          add word [di-0xc],byte +0x1
00000D64  0FB605            movzx ax,[di]
00000D67  2022              and [bp+si],ah
00000D69  0100              add [bx+si],ax
00000D6B  0FB6D0            movzx dx,al
00000D6E  0FB645F2          movzx ax,[di-0xe]
00000D72  0FBEC0            movsx ax,al
00000D75  83EC08            sub sp,byte +0x8
00000D78  52                push dx
00000D79  50                push ax
00000D7A  E81CF8            call 0x599
00000D7D  FF                db 0xff
00000D7E  FF83C410          inc word [bp+di+0x10c4]
00000D82  E905FF            jmp 0xc8a
00000D85  FF                db 0xff
00000D86  FFC9              dec cx
00000D88  C3                ret
00000D89  55                push bp
00000D8A  89E5              mov bp,sp
00000D8C  83EC18            sub sp,byte +0x18
00000D8F  837D0800          cmp word [di+0x8],byte +0x0
00000D93  7907              jns 0xd9c
00000D95  C745080000        mov word [di+0x8],0x0
00000D9A  0000              add [bx+si],al
00000D9C  837D084F          cmp word [di+0x8],byte +0x4f
00000DA0  7E07              jng 0xda9
00000DA2  C745084F00        mov word [di+0x8],0x4f
00000DA7  0000              add [bx+si],al
00000DA9  837D0C00          cmp word [di+0xc],byte +0x0
00000DAD  7907              jns 0xdb6
00000DAF  C7450C0000        mov word [di+0xc],0x0
00000DB4  0000              add [bx+si],al
00000DB6  837D0C18          cmp word [di+0xc],byte +0x18
00000DBA  7E07              jng 0xdc3
00000DBC  C7450C1800        mov word [di+0xc],0x18
00000DC1  0000              add [bx+si],al
00000DC3  8B4508            mov ax,[di+0x8]
00000DC6  A24024            mov [0x2440],al
00000DC9  0100              add [bx+si],ax
00000DCB  8B450C            mov ax,[di+0xc]
00000DCE  A24124            mov [0x2441],al
00000DD1  0100              add [bx+si],ax
00000DD3  8B450C            mov ax,[di+0xc]
00000DD6  89C2              mov dx,ax
00000DD8  89D0              mov ax,dx
00000DDA  C1E002            shl ax,byte 0x2
00000DDD  01D0              add ax,dx
00000DDF  C1E004            shl ax,byte 0x4
00000DE2  89C2              mov dx,ax
00000DE4  8B4508            mov ax,[di+0x8]
00000DE7  01D0              add ax,dx
00000DE9  668945F6          mov [di-0xa],eax
00000DED  83EC08            sub sp,byte +0x8
00000DF0  6A0F              push byte +0xf
00000DF2  68D403            push word 0x3d4
00000DF5  0000              add [bx+si],al
00000DF7  E83F03            call 0x1139
00000DFA  0000              add [bx+si],al
00000DFC  83C410            add sp,byte +0x10
00000DFF  0F                db 0x0f
00000E00  B745              mov bh,0x45
00000E02  F6                db 0xf6
00000E03  0FB6C0            movzx ax,al
00000E06  83EC08            sub sp,byte +0x8
00000E09  50                push ax
00000E0A  68D503            push word 0x3d5
00000E0D  0000              add [bx+si],al
00000E0F  E82703            call 0x1139
00000E12  0000              add [bx+si],al
00000E14  83C410            add sp,byte +0x10
00000E17  83EC08            sub sp,byte +0x8
00000E1A  6A0E              push byte +0xe
00000E1C  68D403            push word 0x3d4
00000E1F  0000              add [bx+si],al
00000E21  E81503            call 0x1139
00000E24  0000              add [bx+si],al
00000E26  83C410            add sp,byte +0x10
00000E29  0F                db 0x0f
00000E2A  B745              mov bh,0x45
00000E2C  F666C1            mul byte [bp-0x3f]
00000E2F  E8080F            call 0x1d3a
00000E32  B6C0              mov dh,0xc0
00000E34  83EC08            sub sp,byte +0x8
00000E37  50                push ax
00000E38  68D503            push word 0x3d5
00000E3B  0000              add [bx+si],al
00000E3D  E8F902            call 0x1139
00000E40  0000              add [bx+si],al
00000E42  83C410            add sp,byte +0x10
00000E45  90                nop
00000E46  C9                leave
00000E47  C3                ret
00000E48  55                push bp
00000E49  89E5              mov bp,sp
00000E4B  83EC08            sub sp,byte +0x8
00000E4E  83EC08            sub sp,byte +0x8
00000E51  6A00              push byte +0x0
00000E53  68F903            push word 0x3f9
00000E56  0000              add [bx+si],al
00000E58  E8DE02            call 0x1139
00000E5B  0000              add [bx+si],al
00000E5D  83C410            add sp,byte +0x10
00000E60  83EC08            sub sp,byte +0x8
00000E63  688000            push word 0x80
00000E66  0000              add [bx+si],al
00000E68  68FB03            push word 0x3fb
00000E6B  0000              add [bx+si],al
00000E6D  E8C902            call 0x1139
00000E70  0000              add [bx+si],al
00000E72  83C410            add sp,byte +0x10
00000E75  83EC08            sub sp,byte +0x8
00000E78  6A03              push byte +0x3
00000E7A  68F803            push word 0x3f8
00000E7D  0000              add [bx+si],al
00000E7F  E8B702            call 0x1139
00000E82  0000              add [bx+si],al
00000E84  83C410            add sp,byte +0x10
00000E87  83EC08            sub sp,byte +0x8
00000E8A  6A00              push byte +0x0
00000E8C  68F903            push word 0x3f9
00000E8F  0000              add [bx+si],al
00000E91  E8A502            call 0x1139
00000E94  0000              add [bx+si],al
00000E96  83C410            add sp,byte +0x10
00000E99  83EC08            sub sp,byte +0x8
00000E9C  6A03              push byte +0x3
00000E9E  68FB03            push word 0x3fb
00000EA1  0000              add [bx+si],al
00000EA3  E89302            call 0x1139
00000EA6  0000              add [bx+si],al
00000EA8  83C410            add sp,byte +0x10
00000EAB  83EC08            sub sp,byte +0x8
00000EAE  68C700            push word 0xc7
00000EB1  0000              add [bx+si],al
00000EB3  68FA03            push word 0x3fa
00000EB6  0000              add [bx+si],al
00000EB8  E87E02            call 0x1139
00000EBB  0000              add [bx+si],al
00000EBD  83C410            add sp,byte +0x10
00000EC0  83EC08            sub sp,byte +0x8
00000EC3  6A0B              push byte +0xb
00000EC5  68FC03            push word 0x3fc
00000EC8  0000              add [bx+si],al
00000ECA  E86C02            call 0x1139
00000ECD  0000              add [bx+si],al
00000ECF  83C410            add sp,byte +0x10
00000ED2  83EC08            sub sp,byte +0x8
00000ED5  6A1E              push byte +0x1e
00000ED7  68FC03            push word 0x3fc
00000EDA  0000              add [bx+si],al
00000EDC  E85A02            call 0x1139
00000EDF  0000              add [bx+si],al
00000EE1  83C410            add sp,byte +0x10
00000EE4  83EC08            sub sp,byte +0x8
00000EE7  68AE00            push word 0xae
00000EEA  0000              add [bx+si],al
00000EEC  68F803            push word 0x3f8
00000EEF  0000              add [bx+si],al
00000EF1  E84502            call 0x1139
00000EF4  0000              add [bx+si],al
00000EF6  83C410            add sp,byte +0x10
00000EF9  83EC0C            sub sp,byte +0xc
00000EFC  68F803            push word 0x3f8
00000EFF  0000              add [bx+si],al
00000F01  E81802            call 0x111c
00000F04  0000              add [bx+si],al
00000F06  83C410            add sp,byte +0x10
00000F09  3CAE              cmp al,0xae
00000F0B  7407              jz 0xf14
00000F0D  B80100            mov ax,0x1
00000F10  0000              add [bx+si],al
00000F12  EB17              jmp short 0xf2b
00000F14  83EC08            sub sp,byte +0x8
00000F17  6A0F              push byte +0xf
00000F19  68FC03            push word 0x3fc
00000F1C  0000              add [bx+si],al
00000F1E  E81802            call 0x1139
00000F21  0000              add [bx+si],al
00000F23  83C410            add sp,byte +0x10
00000F26  B80000            mov ax,0x0
00000F29  0000              add [bx+si],al
00000F2B  C9                leave
00000F2C  C3                ret
00000F2D  55                push bp
00000F2E  89E5              mov bp,sp
00000F30  83EC08            sub sp,byte +0x8
00000F33  83EC0C            sub sp,byte +0xc
00000F36  68FD03            push word 0x3fd
00000F39  0000              add [bx+si],al
00000F3B  E8DE01            call 0x111c
00000F3E  0000              add [bx+si],al
00000F40  83C410            add sp,byte +0x10
00000F43  0FB6C0            movzx ax,al
00000F46  83E020            and ax,byte +0x20
00000F49  C9                leave
00000F4A  C3                ret
00000F4B  55                push bp
00000F4C  89E5              mov bp,sp
00000F4E  83EC18            sub sp,byte +0x18
00000F51  8B4508            mov ax,[di+0x8]
00000F54  8845F4            mov [di-0xc],al
00000F57  90                nop
00000F58  E8D0FF            call 0xf2b
00000F5B  FF                db 0xff
00000F5C  FF85C074          inc word [di+0x74c0]
00000F60  F7                db 0xf7
00000F61  0FB645F4          movzx ax,[di-0xc]
00000F65  0FB6C0            movzx ax,al
00000F68  83EC08            sub sp,byte +0x8
00000F6B  50                push ax
00000F6C  68F803            push word 0x3f8
00000F6F  0000              add [bx+si],al
00000F71  E8C501            call 0x1139
00000F74  0000              add [bx+si],al
00000F76  83C410            add sp,byte +0x10
00000F79  90                nop
00000F7A  C9                leave
00000F7B  C3                ret
00000F7C  55                push bp
00000F7D  89E5              mov bp,sp
00000F7F  EB08              jmp short 0xf89
00000F81  83450801          add word [di+0x8],byte +0x1
00000F85  83450C01          add word [di+0xc],byte +0x1
00000F89  8B4508            mov ax,[di+0x8]
00000F8C  0FB600            movzx ax,[bx+si]
00000F8F  84C0              test al,al
00000F91  7410              jz 0xfa3
00000F93  8B4508            mov ax,[di+0x8]
00000F96  0FB610            movzx dx,[bx+si]
00000F99  8B450C            mov ax,[di+0xc]
00000F9C  0FB600            movzx ax,[bx+si]
00000F9F  38C2              cmp dl,al
00000FA1  74DE              jz 0xf81
00000FA3  8B4508            mov ax,[di+0x8]
00000FA6  0FB600            movzx ax,[bx+si]
00000FA9  0FB6D0            movzx dx,al
00000FAC  8B450C            mov ax,[di+0xc]
00000FAF  0FB600            movzx ax,[bx+si]
00000FB2  0FB6C8            movzx cx,al
00000FB5  89D0              mov ax,dx
00000FB7  29C8              sub ax,cx
00000FB9  5D                pop bp
00000FBA  C3                ret
00000FBB  55                push bp
00000FBC  89E5              mov bp,sp
00000FBE  EB0C              jmp short 0xfcc
00000FC0  83450801          add word [di+0x8],byte +0x1
00000FC4  83450C01          add word [di+0xc],byte +0x1
00000FC8  836D1001          sub word [di+0x10],byte +0x1
00000FCC  837D1000          cmp word [di+0x10],byte +0x0
00000FD0  741A              jz 0xfec
00000FD2  8B4508            mov ax,[di+0x8]
00000FD5  0FB600            movzx ax,[bx+si]
00000FD8  84C0              test al,al
00000FDA  7410              jz 0xfec
00000FDC  8B4508            mov ax,[di+0x8]
00000FDF  0FB610            movzx dx,[bx+si]
00000FE2  8B450C            mov ax,[di+0xc]
00000FE5  0FB600            movzx ax,[bx+si]
00000FE8  38C2              cmp dl,al
00000FEA  74D4              jz 0xfc0
00000FEC  837D1000          cmp word [di+0x10],byte +0x0
00000FF0  7507              jnz 0xff9
00000FF2  B80000            mov ax,0x0
00000FF5  0000              add [bx+si],al
00000FF7  EB16              jmp short 0x100f
00000FF9  8B4508            mov ax,[di+0x8]
00000FFC  0FB600            movzx ax,[bx+si]
00000FFF  0FB6D0            movzx dx,al
00001002  8B450C            mov ax,[di+0xc]
00001005  0FB600            movzx ax,[bx+si]
00001008  0FB6C8            movzx cx,al
0000100B  89D0              mov ax,dx
0000100D  29C8              sub ax,cx
0000100F  5D                pop bp
00001010  C3                ret
00001011  55                push bp
00001012  89E5              mov bp,sp
00001014  83EC10            sub sp,byte +0x10
00001017  C745FC0000        mov word [di-0x4],0x0
0000101C  0000              add [bx+si],al
0000101E  EB08              jmp short 0x1028
00001020  8345FC01          add word [di-0x4],byte +0x1
00001024  83450801          add word [di+0x8],byte +0x1
00001028  8B4508            mov ax,[di+0x8]
0000102B  0FB600            movzx ax,[bx+si]
0000102E  84C0              test al,al
00001030  75EE              jnz 0x1020
00001032  8B45FC            mov ax,[di-0x4]
00001035  C9                leave
00001036  C3                ret
00001037  55                push bp
00001038  89E5              mov bp,sp
0000103A  83EC10            sub sp,byte +0x10
0000103D  C745FC0000        mov word [di-0x4],0x0
00001042  0000              add [bx+si],al
00001044  8B55FC            mov dx,[di-0x4]
00001047  8B450C            mov ax,[di+0xc]
0000104A  01D0              add ax,dx
0000104C  8B4DFC            mov cx,[di-0x4]
0000104F  8B5508            mov dx,[di+0x8]
00001052  01CA              add dx,cx
00001054  0FB600            movzx ax,[bx+si]
00001057  8802              mov [bp+si],al
00001059  8B55FC            mov dx,[di-0x4]
0000105C  8B4508            mov ax,[di+0x8]
0000105F  01D0              add ax,dx
00001061  0FB600            movzx ax,[bx+si]
00001064  84C0              test al,al
00001066  7406              jz 0x106e
00001068  8345FC01          add word [di-0x4],byte +0x1
0000106C  EBD6              jmp short 0x1044
0000106E  90                nop
0000106F  8B4508            mov ax,[di+0x8]
00001072  C9                leave
00001073  C3                ret
00001074  55                push bp
00001075  89E5              mov bp,sp
00001077  83EC10            sub sp,byte +0x10
0000107A  8B4508            mov ax,[di+0x8]
0000107D  8945FC            mov [di-0x4],ax
00001080  EB04              jmp short 0x1086
00001082  8345FC01          add word [di-0x4],byte +0x1
00001086  8B45FC            mov ax,[di-0x4]
00001089  0FB600            movzx ax,[bx+si]
0000108C  84C0              test al,al
0000108E  75F2              jnz 0x1082
00001090  FF750C            push word [di+0xc]
00001093  FF75FC            push word [di-0x4]
00001096  E89CFF            call 0x1035
00001099  FF                db 0xff
0000109A  FF83C408          inc word [bp+di+0x8c4]
0000109E  8B4508            mov ax,[di+0x8]
000010A1  C9                leave
000010A2  C3                ret
000010A3  55                push bp
000010A4  89E5              mov bp,sp
000010A6  83EC10            sub sp,byte +0x10
000010A9  8B450C            mov ax,[di+0xc]
000010AC  8945F8            mov [di-0x8],ax
000010AF  8B4508            mov ax,[di+0x8]
000010B2  8945F4            mov [di-0xc],ax
000010B5  C745FC0000        mov word [di-0x4],0x0
000010BA  0000              add [bx+si],al
000010BC  EB19              jmp short 0x10d7
000010BE  8B55F8            mov dx,[di-0x8]
000010C1  8B45FC            mov ax,[di-0x4]
000010C4  01D0              add ax,dx
000010C6  8B4DF4            mov cx,[di-0xc]
000010C9  8B55FC            mov dx,[di-0x4]
000010CC  01CA              add dx,cx
000010CE  0FB600            movzx ax,[bx+si]
000010D1  8802              mov [bp+si],al
000010D3  8345FC01          add word [di-0x4],byte +0x1
000010D7  8B45FC            mov ax,[di-0x4]
000010DA  3B4510            cmp ax,[di+0x10]
000010DD  72DF              jc 0x10be
000010DF  8B4508            mov ax,[di+0x8]
000010E2  C9                leave
000010E3  C3                ret
000010E4  55                push bp
000010E5  89E5              mov bp,sp
000010E7  83EC10            sub sp,byte +0x10
000010EA  8B450C            mov ax,[di+0xc]
000010ED  8845FB            mov [di-0x5],al
000010F0  8B4508            mov ax,[di+0x8]
000010F3  8945F4            mov [di-0xc],ax
000010F6  C745FC0000        mov word [di-0x4],0x0
000010FB  0000              add [bx+si],al
000010FD  EB12              jmp short 0x1111
000010FF  8B55F4            mov dx,[di-0xc]
00001102  8B45FC            mov ax,[di-0x4]
00001105  01C2              add dx,ax
00001107  0FB645FB          movzx ax,[di-0x5]
0000110B  8802              mov [bp+si],al
0000110D  8345FC01          add word [di-0x4],byte +0x1
00001111  8B45FC            mov ax,[di-0x4]
00001114  3B4510            cmp ax,[di+0x10]
00001117  72E6              jc 0x10ff
00001119  8B4508            mov ax,[di+0x8]
0000111C  C9                leave
0000111D  C3                ret
0000111E  55                push bp
0000111F  89E5              mov bp,sp
00001121  83EC14            sub sp,byte +0x14
00001124  8B4508            mov ax,[di+0x8]
00001127  668945EC          mov [di-0x14],eax
0000112B  0F                db 0x0f
0000112C  B745              mov bh,0x45
0000112E  EC                in al,dx
0000112F  89C2              mov dx,ax
00001131  EC                in al,dx
00001132  8845FF            mov [di-0x1],al
00001135  0FB645FF          movzx ax,[di-0x1]
00001139  C9                leave
0000113A  C3                ret
0000113B  55                push bp
0000113C  89E5              mov bp,sp
0000113E  83EC08            sub sp,byte +0x8
00001141  8B4508            mov ax,[di+0x8]
00001144  8B550C            mov dx,[di+0xc]
00001147  668945FC          mov [di-0x4],eax
0000114B  89D0              mov ax,dx
0000114D  8845F8            mov [di-0x8],al
00001150  0F                db 0x0f
00001151  B755              mov bh,0x55
00001153  FC                cld
00001154  0FB645F8          movzx ax,[di-0x8]
00001158  EE                out dx,al
00001159  90                nop
0000115A  C9                leave
0000115B  C3                ret
0000115C  0000              add [bx+si],al
0000115E  57                push di
0000115F  656C              gs insb
00001161  636F6D            arpl [bx+0x6d],bp
00001164  6520746F          and [gs:si+0x6f],dh
00001168  20546F            and [si+0x6f],dl
0000116B  6D                insw
0000116C  61                popa
0000116D  744F              jz 0x11be
0000116F  53                push bx
00001170  2E205468          and [cs:si+0x68],dl
00001174  6520506F          and [gs:bx+si+0x6f],dl
00001178  7461              jz 0x11db
0000117A  744F              jz 0x11cb
0000117C  53                push bx
0000117D  20666F            and [bp+0x6f],ah
00001180  726B              jc 0x11ed
00001182  207772            and [bx+0x72],dh
00001185  697474656E        imul si,[si+0x74],word 0x6e65
0000118A  20696E            and [bx+di+0x6e],ch
0000118D  20430D            and [bp+di+0xd],al
00001190  0A0A              or cl,[bp+si]
00001192  0000              add [bx+si],al
00001194  0000              add [bx+si],al
00001196  7072              jo 0x120a
00001198  696E74663A        imul bp,[bp+0x74],word 0x3a66
0000119D  0D0A62            or ax,0x620a
000011A0  61                popa
000011A1  7365              jnc 0x1208
000011A3  2038              and [bx+si],bh
000011A5  3A25              cmp ah,[di]
000011A7  6F                outsw
000011A8  0D0A62            or ax,0x620a
000011AB  61                popa
000011AC  7365              jnc 0x1213
000011AE  2031              and [bx+di],dh
000011B0  303A              xor [bp+si],bh
000011B2  25640D            and ax,0xd64
000011B5  0A6261            or ah,[bp+si+0x61]
000011B8  7365              jnc 0x121f
000011BA  2031              and [bx+di],dh
000011BC  363A25            cmp ah,[ss:di]
000011BF  780D              js 0x11ce
000011C1  0A416E            or al,[bx+di+0x6e]
000011C4  6420736F          and [fs:bp+di+0x6f],dh
000011C8  6D                insw
000011C9  65207374          and [gs:bp+di+0x74],dh
000011CD  7269              jc 0x1238
000011CF  6E                outsb
000011D0  673A25730D0A00    cmp ah,[dword 0xa0d73]
000011D7  0000              add [bx+si],al
000011D9  004550            add [di+0x50],al
000011DC  49                dec cx
000011DD  43                inc bx
000011DE  204841            and [bx+si+0x41],cl
000011E1  52                push dx
000011E2  44                inc sp
000011E3  43                inc bx
000011E4  4F                dec di
000011E5  52                push dx
000011E6  45                inc bp
000011E7  205348            and [bp+di+0x48],dl
000011EA  4F                dec di
000011EB  4F                dec di
000011EC  42                inc dx
000011ED  49                dec cx
000011EE  45                inc bp
000011EF  20444F            and [si+0x4f],al
000011F2  47                inc di
000011F3  204D45            and [di+0x45],cl
000011F6  4D                dec bp
000011F7  45                inc bp
000011F8  53                push bx
000011F9  00556E            add [di+0x6e],dl
000011FC  7265              jc 0x1263
000011FE  636F67            arpl [bx+0x67],bp
00001201  6E                outsb
00001202  697A656420        imul di,[bp+si+0x65],word 0x2064
00001207  636F6D            arpl [bx+0x6d],bp
0000120A  6D                insw
0000120B  61                popa
0000120C  6E                outsb
0000120D  642027            and [fs:bx],ah
00001210  257327            and ax,0x2773
00001213  2120              and [bx+si],sp
00001215  54                push sp
00001216  7279              jc 0x1291
00001218  206865            and [bx+si+0x65],ch
0000121B  6C                insb
0000121C  7020              jo 0x123e
0000121E  746F              jz 0x128f
00001220  206C69            and [si+0x69],ch
00001223  7374              jnc 0x1299
00001225  20616C            and [bx+di+0x6c],ah
00001228  6C                insb
00001229  20636F            and [bp+di+0x6f],ah
0000122C  6D                insw
0000122D  6D                insw
0000122E  61                popa
0000122F  6E                outsb
00001230  64732E            fs jnc 0x1261
00001233  0D0A00            or ax,0xa
00001236  0D0A43            or ax,0x430a
00001239  4D                dec bp
0000123A  44                inc sp
0000123B  3E2000            and [ds:bx+si],al
0000123E  0D0A00            or ax,0xa
00001241  636F6C            arpl [bx+0x6c],bp
00001244  6F                outsw
00001245  7273              jc 0x12ba
00001247  0025              add [di],ah
00001249  7820              js 0x126b
0000124B  007072            add [bx+si+0x72],dh
0000124E  696E746600        imul bp,[bp+0x74],word 0x66
00001253  7465              jz 0x12ba
00001255  7374              jnc 0x12cb
00001257  3132              xor [bp+si],si
00001259  3300              xor ax,[bx+si]
0000125B  636C65            arpl [si+0x65],bp
0000125E  61                popa
0000125F  7200              jc 0x1261
00001261  7465              jz 0x12c8
00001263  7374              jnc 0x12d9
00001265  00536F            add [bp+di+0x6f],dl
00001268  6D                insw
00001269  65205465          and [gs:si+0x65],dl
0000126D  7874              js 0x12e3
0000126F  0025              add [di],ah
00001271  643A20            cmp ah,[fs:bx+si]
00001274  25730D            and ax,0xd73
00001277  0A25              or ah,[di]
00001279  643A20            cmp ah,[fs:bx+si]
0000127C  25730D            and ax,0xd73
0000127F  0A25              or ah,[di]
00001281  643A20            cmp ah,[fs:bx+si]
00001284  25730D            and ax,0xd73
00001287  0A00              or al,[bx+si]
00001289  61                popa
0000128A  7267              jc 0x12f3
0000128C  7300              jnc 0x128e
0000128E  61                popa
0000128F  7267              jc 0x12f8
00001291  733A              jnc 0x12cd
00001293  2025              and [di],ah
00001295  7300              jnc 0x1297
00001297  636174            arpl [bx+di+0x74],sp
0000129A  0025              add [di],ah
0000129C  730D              jnc 0x12ab
0000129E  0A25              or ah,[di]
000012A0  730D              jnc 0x12af
000012A2  0A25              or ah,[di]
000012A4  730D              jnc 0x12b3
000012A6  0A00              or al,[bx+si]
000012A8  0000              add [bx+si],al
000012AA  7B08              jpo 0x12b4
000012AC  0100              add [bx+si],ax
000012AE  3E07              ds pop es
000012B0  0100              add [bx+si],ax
000012B2  3209              xor cl,[bx+di]
000012B4  0100              add [bx+si],ax
000012B6  3209              xor cl,[bx+di]
000012B8  0100              add [bx+si],ax
000012BA  3209              xor cl,[bx+di]
000012BC  0100              add [bx+si],ax
000012BE  3209              xor cl,[bx+di]
000012C0  0100              add [bx+si],ax
000012C2  3E07              ds pop es
000012C4  0100              add [bx+si],ax
000012C6  3209              xor cl,[bx+di]
000012C8  0100              add [bx+si],ax
000012CA  3209              xor cl,[bx+di]
000012CC  0100              add [bx+si],ax
000012CE  3209              xor cl,[bx+di]
000012D0  0100              add [bx+si],ax
000012D2  3209              xor cl,[bx+di]
000012D4  0100              add [bx+si],ax
000012D6  3209              xor cl,[bx+di]
000012D8  0100              add [bx+si],ax
000012DA  90                nop
000012DB  07                pop es
000012DC  0100              add [bx+si],ax
000012DE  3209              xor cl,[bx+di]
000012E0  0100              add [bx+si],ax
000012E2  3209              xor cl,[bx+di]
000012E4  0100              add [bx+si],ax
000012E6  3209              xor cl,[bx+di]
000012E8  0100              add [bx+si],ax
000012EA  3C08              cmp al,0x8
000012EC  0100              add [bx+si],ax
000012EE  3209              xor cl,[bx+di]
000012F0  0100              add [bx+si],ax
000012F2  3209              xor cl,[bx+di]
000012F4  0100              add [bx+si],ax
000012F6  3209              xor cl,[bx+di]
000012F8  0100              add [bx+si],ax
000012FA  3209              xor cl,[bx+di]
000012FC  0100              add [bx+si],ax
000012FE  E607              out 0x7,al
00001300  0100              add [bx+si],ax
00001302  0000              add [bx+si],al
00001304  0000              add [bx+si],al
00001306  0000              add [bx+si],al
00001308  0000              add [bx+si],al
0000130A  0000              add [bx+si],al
0000130C  0000              add [bx+si],al
0000130E  0000              add [bx+si],al
00001310  0000              add [bx+si],al
00001312  0000              add [bx+si],al
00001314  0000              add [bx+si],al
00001316  0000              add [bx+si],al
00001318  0000              add [bx+si],al
0000131A  0000              add [bx+si],al
0000131C  0000              add [bx+si],al
0000131E  0000              add [bx+si],al
00001320  0000              add [bx+si],al
00001322  0000              add [bx+si],al
00001324  0000              add [bx+si],al
00001326  0000              add [bx+si],al
00001328  0000              add [bx+si],al
0000132A  0000              add [bx+si],al
0000132C  0000              add [bx+si],al
0000132E  0000              add [bx+si],al
00001330  0000              add [bx+si],al
00001332  0000              add [bx+si],al
00001334  0000              add [bx+si],al
00001336  0000              add [bx+si],al
00001338  0000              add [bx+si],al
0000133A  0000              add [bx+si],al
0000133C  0000              add [bx+si],al
0000133E  0000              add [bx+si],al
00001340  0000              add [bx+si],al
00001342  0000              add [bx+si],al
00001344  0000              add [bx+si],al
00001346  0000              add [bx+si],al
00001348  0000              add [bx+si],al
0000134A  0000              add [bx+si],al
0000134C  0000              add [bx+si],al
0000134E  0000              add [bx+si],al
00001350  0000              add [bx+si],al
00001352  0000              add [bx+si],al
00001354  0000              add [bx+si],al
00001356  0000              add [bx+si],al
00001358  0000              add [bx+si],al
0000135A  0000              add [bx+si],al
0000135C  0000              add [bx+si],al
0000135E  0000              add [bx+si],al
00001360  0000              add [bx+si],al
00001362  0000              add [bx+si],al
00001364  0000              add [bx+si],al
00001366  0000              add [bx+si],al
00001368  0000              add [bx+si],al
0000136A  0000              add [bx+si],al
0000136C  0000              add [bx+si],al
0000136E  0000              add [bx+si],al
00001370  0000              add [bx+si],al
00001372  0000              add [bx+si],al
00001374  0000              add [bx+si],al
00001376  0000              add [bx+si],al
00001378  0000              add [bx+si],al
0000137A  0000              add [bx+si],al
0000137C  0000              add [bx+si],al
0000137E  0000              add [bx+si],al
00001380  0000              add [bx+si],al
00001382  0000              add [bx+si],al
00001384  0000              add [bx+si],al
00001386  0000              add [bx+si],al
00001388  0000              add [bx+si],al
0000138A  0000              add [bx+si],al
0000138C  0000              add [bx+si],al
0000138E  0000              add [bx+si],al
00001390  0000              add [bx+si],al
00001392  0000              add [bx+si],al
00001394  0000              add [bx+si],al
00001396  0000              add [bx+si],al
00001398  0000              add [bx+si],al
0000139A  0000              add [bx+si],al
0000139C  0000              add [bx+si],al
0000139E  0000              add [bx+si],al
000013A0  0000              add [bx+si],al
000013A2  0000              add [bx+si],al
000013A4  0000              add [bx+si],al
000013A6  0000              add [bx+si],al
000013A8  0000              add [bx+si],al
000013AA  0000              add [bx+si],al
000013AC  0000              add [bx+si],al
000013AE  0000              add [bx+si],al
000013B0  0000              add [bx+si],al
000013B2  0000              add [bx+si],al
000013B4  0000              add [bx+si],al
000013B6  0000              add [bx+si],al
000013B8  0000              add [bx+si],al
000013BA  0000              add [bx+si],al
000013BC  0000              add [bx+si],al
000013BE  0000              add [bx+si],al
000013C0  0000              add [bx+si],al
000013C2  0000              add [bx+si],al
000013C4  0000              add [bx+si],al
000013C6  0000              add [bx+si],al
000013C8  0000              add [bx+si],al
000013CA  0000              add [bx+si],al
000013CC  0000              add [bx+si],al
000013CE  0000              add [bx+si],al
000013D0  0000              add [bx+si],al
000013D2  0000              add [bx+si],al
000013D4  0000              add [bx+si],al
000013D6  0000              add [bx+si],al
000013D8  0000              add [bx+si],al
000013DA  0000              add [bx+si],al
000013DC  0000              add [bx+si],al
000013DE  0000              add [bx+si],al
000013E0  0000              add [bx+si],al
000013E2  0000              add [bx+si],al
000013E4  0000              add [bx+si],al
000013E6  0000              add [bx+si],al
000013E8  0000              add [bx+si],al
000013EA  0000              add [bx+si],al
000013EC  0000              add [bx+si],al
000013EE  0000              add [bx+si],al
000013F0  0000              add [bx+si],al
000013F2  0000              add [bx+si],al
000013F4  0000              add [bx+si],al
000013F6  0000              add [bx+si],al
000013F8  0000              add [bx+si],al
000013FA  0000              add [bx+si],al
000013FC  0000              add [bx+si],al
000013FE  0000              add [bx+si],al
00001400  0000              add [bx+si],al
00001402  0000              add [bx+si],al
00001404  0000              add [bx+si],al
00001406  0000              add [bx+si],al
00001408  0000              add [bx+si],al
0000140A  0000              add [bx+si],al
0000140C  0000              add [bx+si],al
0000140E  0000              add [bx+si],al
00001410  0000              add [bx+si],al
00001412  0000              add [bx+si],al
00001414  0000              add [bx+si],al
00001416  0000              add [bx+si],al
00001418  0000              add [bx+si],al
0000141A  0000              add [bx+si],al
0000141C  0000              add [bx+si],al
0000141E  0000              add [bx+si],al
00001420  0000              add [bx+si],al
00001422  0000              add [bx+si],al
00001424  0000              add [bx+si],al
00001426  0000              add [bx+si],al
00001428  0000              add [bx+si],al
0000142A  0000              add [bx+si],al
0000142C  0000              add [bx+si],al
0000142E  0000              add [bx+si],al
00001430  0000              add [bx+si],al
00001432  0000              add [bx+si],al
00001434  0000              add [bx+si],al
00001436  0000              add [bx+si],al
00001438  0000              add [bx+si],al
0000143A  0000              add [bx+si],al
0000143C  0000              add [bx+si],al
0000143E  0000              add [bx+si],al
00001440  0000              add [bx+si],al
00001442  0000              add [bx+si],al
00001444  0000              add [bx+si],al
00001446  0000              add [bx+si],al
00001448  0000              add [bx+si],al
0000144A  0000              add [bx+si],al
0000144C  0000              add [bx+si],al
0000144E  0000              add [bx+si],al
00001450  0000              add [bx+si],al
00001452  0000              add [bx+si],al
00001454  0000              add [bx+si],al
00001456  0000              add [bx+si],al
00001458  0000              add [bx+si],al
0000145A  0000              add [bx+si],al
0000145C  0000              add [bx+si],al
0000145E  0000              add [bx+si],al
00001460  0000              add [bx+si],al
00001462  0000              add [bx+si],al
00001464  0000              add [bx+si],al
00001466  0000              add [bx+si],al
00001468  0000              add [bx+si],al
0000146A  0000              add [bx+si],al
0000146C  0000              add [bx+si],al
0000146E  0000              add [bx+si],al
00001470  0000              add [bx+si],al
00001472  0000              add [bx+si],al
00001474  0000              add [bx+si],al
00001476  0000              add [bx+si],al
00001478  0000              add [bx+si],al
0000147A  0000              add [bx+si],al
0000147C  0000              add [bx+si],al
0000147E  0000              add [bx+si],al
00001480  0000              add [bx+si],al
00001482  0000              add [bx+si],al
00001484  0000              add [bx+si],al
00001486  0000              add [bx+si],al
00001488  0000              add [bx+si],al
0000148A  0000              add [bx+si],al
0000148C  0000              add [bx+si],al
0000148E  0000              add [bx+si],al
00001490  0000              add [bx+si],al
00001492  0000              add [bx+si],al
00001494  0000              add [bx+si],al
00001496  0000              add [bx+si],al
00001498  0000              add [bx+si],al
0000149A  0000              add [bx+si],al
0000149C  0000              add [bx+si],al
0000149E  0000              add [bx+si],al
000014A0  0000              add [bx+si],al
000014A2  0000              add [bx+si],al
000014A4  0000              add [bx+si],al
000014A6  0000              add [bx+si],al
000014A8  0000              add [bx+si],al
000014AA  0000              add [bx+si],al
000014AC  0000              add [bx+si],al
000014AE  0000              add [bx+si],al
000014B0  0000              add [bx+si],al
000014B2  0000              add [bx+si],al
000014B4  0000              add [bx+si],al
000014B6  0000              add [bx+si],al
000014B8  0000              add [bx+si],al
000014BA  0000              add [bx+si],al
000014BC  0000              add [bx+si],al
000014BE  0000              add [bx+si],al
000014C0  0000              add [bx+si],al
000014C2  0000              add [bx+si],al
000014C4  0000              add [bx+si],al
000014C6  0000              add [bx+si],al
000014C8  0000              add [bx+si],al
000014CA  0000              add [bx+si],al
000014CC  0000              add [bx+si],al
000014CE  0000              add [bx+si],al
000014D0  0000              add [bx+si],al
000014D2  0000              add [bx+si],al
000014D4  0000              add [bx+si],al
000014D6  0000              add [bx+si],al
000014D8  0000              add [bx+si],al
000014DA  0000              add [bx+si],al
000014DC  0000              add [bx+si],al
000014DE  0000              add [bx+si],al
000014E0  0000              add [bx+si],al
000014E2  0000              add [bx+si],al
000014E4  0000              add [bx+si],al
000014E6  0000              add [bx+si],al
000014E8  0000              add [bx+si],al
000014EA  0000              add [bx+si],al
000014EC  0000              add [bx+si],al
000014EE  0000              add [bx+si],al
000014F0  0000              add [bx+si],al
000014F2  0000              add [bx+si],al
000014F4  0000              add [bx+si],al
000014F6  0000              add [bx+si],al
000014F8  0000              add [bx+si],al
000014FA  0000              add [bx+si],al
000014FC  0000              add [bx+si],al
000014FE  0000              add [bx+si],al
00001500  0000              add [bx+si],al
00001502  0000              add [bx+si],al
00001504  0000              add [bx+si],al
00001506  0000              add [bx+si],al
00001508  0000              add [bx+si],al
0000150A  0000              add [bx+si],al
0000150C  0000              add [bx+si],al
0000150E  0000              add [bx+si],al
00001510  0000              add [bx+si],al
00001512  0000              add [bx+si],al
00001514  0000              add [bx+si],al
00001516  0000              add [bx+si],al
00001518  0000              add [bx+si],al
0000151A  0000              add [bx+si],al
0000151C  0000              add [bx+si],al
0000151E  0000              add [bx+si],al
00001520  0000              add [bx+si],al
00001522  0000              add [bx+si],al
00001524  0000              add [bx+si],al
00001526  0000              add [bx+si],al
00001528  0000              add [bx+si],al
0000152A  0000              add [bx+si],al
0000152C  0000              add [bx+si],al
0000152E  0000              add [bx+si],al
00001530  0000              add [bx+si],al
00001532  0000              add [bx+si],al
00001534  0000              add [bx+si],al
00001536  0000              add [bx+si],al
00001538  0000              add [bx+si],al
0000153A  0000              add [bx+si],al
0000153C  0000              add [bx+si],al
0000153E  0000              add [bx+si],al
00001540  0000              add [bx+si],al
00001542  0000              add [bx+si],al
00001544  0000              add [bx+si],al
00001546  0000              add [bx+si],al
00001548  0000              add [bx+si],al
0000154A  0000              add [bx+si],al
0000154C  0000              add [bx+si],al
0000154E  0000              add [bx+si],al
00001550  0000              add [bx+si],al
00001552  0000              add [bx+si],al
00001554  0000              add [bx+si],al
00001556  0000              add [bx+si],al
00001558  0000              add [bx+si],al
0000155A  0000              add [bx+si],al
0000155C  0000              add [bx+si],al
0000155E  0000              add [bx+si],al
00001560  0000              add [bx+si],al
00001562  0000              add [bx+si],al
00001564  0000              add [bx+si],al
00001566  0000              add [bx+si],al
00001568  0000              add [bx+si],al
0000156A  0000              add [bx+si],al
0000156C  0000              add [bx+si],al
0000156E  0000              add [bx+si],al
00001570  0000              add [bx+si],al
00001572  0000              add [bx+si],al
00001574  0000              add [bx+si],al
00001576  0000              add [bx+si],al
00001578  0000              add [bx+si],al
0000157A  0000              add [bx+si],al
0000157C  0000              add [bx+si],al
0000157E  0000              add [bx+si],al
00001580  0000              add [bx+si],al
00001582  0000              add [bx+si],al
00001584  0000              add [bx+si],al
00001586  0000              add [bx+si],al
00001588  0000              add [bx+si],al
0000158A  0000              add [bx+si],al
0000158C  0000              add [bx+si],al
0000158E  0000              add [bx+si],al
00001590  0000              add [bx+si],al
00001592  0000              add [bx+si],al
00001594  0000              add [bx+si],al
00001596  0000              add [bx+si],al
00001598  0000              add [bx+si],al
0000159A  0000              add [bx+si],al
0000159C  0000              add [bx+si],al
0000159E  0000              add [bx+si],al
000015A0  0000              add [bx+si],al
000015A2  0000              add [bx+si],al
000015A4  0000              add [bx+si],al
000015A6  0000              add [bx+si],al
000015A8  0000              add [bx+si],al
000015AA  0000              add [bx+si],al
000015AC  0000              add [bx+si],al
000015AE  0000              add [bx+si],al
000015B0  0000              add [bx+si],al
000015B2  0000              add [bx+si],al
000015B4  0000              add [bx+si],al
000015B6  0000              add [bx+si],al
000015B8  0000              add [bx+si],al
000015BA  0000              add [bx+si],al
000015BC  0000              add [bx+si],al
000015BE  0000              add [bx+si],al
000015C0  0000              add [bx+si],al
000015C2  0000              add [bx+si],al
000015C4  0000              add [bx+si],al
000015C6  0000              add [bx+si],al
000015C8  0000              add [bx+si],al
000015CA  0000              add [bx+si],al
000015CC  0000              add [bx+si],al
000015CE  0000              add [bx+si],al
000015D0  0000              add [bx+si],al
000015D2  0000              add [bx+si],al
000015D4  0000              add [bx+si],al
000015D6  0000              add [bx+si],al
000015D8  0000              add [bx+si],al
000015DA  0000              add [bx+si],al
000015DC  0000              add [bx+si],al
000015DE  0000              add [bx+si],al
000015E0  0000              add [bx+si],al
000015E2  0000              add [bx+si],al
000015E4  0000              add [bx+si],al
000015E6  0000              add [bx+si],al
000015E8  0000              add [bx+si],al
000015EA  0000              add [bx+si],al
000015EC  0000              add [bx+si],al
000015EE  0000              add [bx+si],al
000015F0  0000              add [bx+si],al
000015F2  0000              add [bx+si],al
000015F4  0000              add [bx+si],al
000015F6  0000              add [bx+si],al
000015F8  0000              add [bx+si],al
000015FA  0000              add [bx+si],al
000015FC  0000              add [bx+si],al
000015FE  0000              add [bx+si],al
00001600  0000              add [bx+si],al
00001602  0000              add [bx+si],al
00001604  0000              add [bx+si],al
00001606  0000              add [bx+si],al
00001608  0000              add [bx+si],al
0000160A  0000              add [bx+si],al
0000160C  0000              add [bx+si],al
0000160E  0000              add [bx+si],al
00001610  0000              add [bx+si],al
00001612  0000              add [bx+si],al
00001614  0000              add [bx+si],al
00001616  0000              add [bx+si],al
00001618  0000              add [bx+si],al
0000161A  0000              add [bx+si],al
0000161C  0000              add [bx+si],al
0000161E  0000              add [bx+si],al
00001620  0000              add [bx+si],al
00001622  0000              add [bx+si],al
00001624  0000              add [bx+si],al
00001626  0000              add [bx+si],al
00001628  0000              add [bx+si],al
0000162A  0000              add [bx+si],al
0000162C  0000              add [bx+si],al
0000162E  0000              add [bx+si],al
00001630  0000              add [bx+si],al
00001632  0000              add [bx+si],al
00001634  0000              add [bx+si],al
00001636  0000              add [bx+si],al
00001638  0000              add [bx+si],al
0000163A  0000              add [bx+si],al
0000163C  0000              add [bx+si],al
0000163E  0000              add [bx+si],al
00001640  0000              add [bx+si],al
00001642  0000              add [bx+si],al
00001644  0000              add [bx+si],al
00001646  0000              add [bx+si],al
00001648  0000              add [bx+si],al
0000164A  0000              add [bx+si],al
0000164C  0000              add [bx+si],al
0000164E  0000              add [bx+si],al
00001650  0000              add [bx+si],al
00001652  0000              add [bx+si],al
00001654  0000              add [bx+si],al
00001656  0000              add [bx+si],al
00001658  0000              add [bx+si],al
0000165A  0000              add [bx+si],al
0000165C  0000              add [bx+si],al
0000165E  0000              add [bx+si],al
00001660  0000              add [bx+si],al
00001662  0000              add [bx+si],al
00001664  0000              add [bx+si],al
00001666  0000              add [bx+si],al
00001668  0000              add [bx+si],al
0000166A  0000              add [bx+si],al
0000166C  0000              add [bx+si],al
0000166E  0000              add [bx+si],al
00001670  0000              add [bx+si],al
00001672  0000              add [bx+si],al
00001674  0000              add [bx+si],al
00001676  0000              add [bx+si],al
00001678  0000              add [bx+si],al
0000167A  0000              add [bx+si],al
0000167C  0000              add [bx+si],al
0000167E  0000              add [bx+si],al
00001680  0000              add [bx+si],al
00001682  0000              add [bx+si],al
00001684  0000              add [bx+si],al
00001686  0000              add [bx+si],al
00001688  0000              add [bx+si],al
0000168A  0000              add [bx+si],al
0000168C  0000              add [bx+si],al
0000168E  0000              add [bx+si],al
00001690  0000              add [bx+si],al
00001692  0000              add [bx+si],al
00001694  0000              add [bx+si],al
00001696  0000              add [bx+si],al
00001698  0000              add [bx+si],al
0000169A  0000              add [bx+si],al
0000169C  0000              add [bx+si],al
0000169E  0000              add [bx+si],al
000016A0  0000              add [bx+si],al
000016A2  0000              add [bx+si],al
000016A4  0000              add [bx+si],al
000016A6  0000              add [bx+si],al
000016A8  0000              add [bx+si],al
000016AA  0000              add [bx+si],al
000016AC  0000              add [bx+si],al
000016AE  0000              add [bx+si],al
000016B0  0000              add [bx+si],al
000016B2  0000              add [bx+si],al
000016B4  0000              add [bx+si],al
000016B6  0000              add [bx+si],al
000016B8  0000              add [bx+si],al
000016BA  0000              add [bx+si],al
000016BC  0000              add [bx+si],al
000016BE  0000              add [bx+si],al
000016C0  0000              add [bx+si],al
000016C2  0000              add [bx+si],al
000016C4  0000              add [bx+si],al
000016C6  0000              add [bx+si],al
000016C8  0000              add [bx+si],al
000016CA  0000              add [bx+si],al
000016CC  0000              add [bx+si],al
000016CE  0000              add [bx+si],al
000016D0  0000              add [bx+si],al
000016D2  0000              add [bx+si],al
000016D4  0000              add [bx+si],al
000016D6  0000              add [bx+si],al
000016D8  0000              add [bx+si],al
000016DA  0000              add [bx+si],al
000016DC  0000              add [bx+si],al
000016DE  0000              add [bx+si],al
000016E0  0000              add [bx+si],al
000016E2  0000              add [bx+si],al
000016E4  0000              add [bx+si],al
000016E6  0000              add [bx+si],al
000016E8  0000              add [bx+si],al
000016EA  0000              add [bx+si],al
000016EC  0000              add [bx+si],al
000016EE  0000              add [bx+si],al
000016F0  0000              add [bx+si],al
000016F2  0000              add [bx+si],al
000016F4  0000              add [bx+si],al
000016F6  0000              add [bx+si],al
000016F8  0000              add [bx+si],al
000016FA  0000              add [bx+si],al
000016FC  0000              add [bx+si],al
000016FE  0000              add [bx+si],al
00001700  0000              add [bx+si],al
00001702  0000              add [bx+si],al
00001704  0000              add [bx+si],al
00001706  0000              add [bx+si],al
00001708  0000              add [bx+si],al
0000170A  0000              add [bx+si],al
0000170C  0000              add [bx+si],al
0000170E  0000              add [bx+si],al
00001710  0000              add [bx+si],al
00001712  0000              add [bx+si],al
00001714  0000              add [bx+si],al
00001716  0000              add [bx+si],al
00001718  0000              add [bx+si],al
0000171A  0000              add [bx+si],al
0000171C  0000              add [bx+si],al
0000171E  0000              add [bx+si],al
00001720  0000              add [bx+si],al
00001722  0000              add [bx+si],al
00001724  0000              add [bx+si],al
00001726  0000              add [bx+si],al
00001728  0000              add [bx+si],al
0000172A  0000              add [bx+si],al
0000172C  0000              add [bx+si],al
0000172E  0000              add [bx+si],al
00001730  0000              add [bx+si],al
00001732  0000              add [bx+si],al
00001734  0000              add [bx+si],al
00001736  0000              add [bx+si],al
00001738  0000              add [bx+si],al
0000173A  0000              add [bx+si],al
0000173C  0000              add [bx+si],al
0000173E  0000              add [bx+si],al
00001740  0000              add [bx+si],al
00001742  0000              add [bx+si],al
00001744  0000              add [bx+si],al
00001746  0000              add [bx+si],al
00001748  0000              add [bx+si],al
0000174A  0000              add [bx+si],al
0000174C  0000              add [bx+si],al
0000174E  0000              add [bx+si],al
00001750  0000              add [bx+si],al
00001752  0000              add [bx+si],al
00001754  0000              add [bx+si],al
00001756  0000              add [bx+si],al
00001758  0000              add [bx+si],al
0000175A  0000              add [bx+si],al
0000175C  0000              add [bx+si],al
0000175E  0000              add [bx+si],al
00001760  0000              add [bx+si],al
00001762  0000              add [bx+si],al
00001764  0000              add [bx+si],al
00001766  0000              add [bx+si],al
00001768  0000              add [bx+si],al
0000176A  0000              add [bx+si],al
0000176C  0000              add [bx+si],al
0000176E  0000              add [bx+si],al
00001770  0000              add [bx+si],al
00001772  0000              add [bx+si],al
00001774  0000              add [bx+si],al
00001776  0000              add [bx+si],al
00001778  0000              add [bx+si],al
0000177A  0000              add [bx+si],al
0000177C  0000              add [bx+si],al
0000177E  0000              add [bx+si],al
00001780  0000              add [bx+si],al
00001782  0000              add [bx+si],al
00001784  0000              add [bx+si],al
00001786  0000              add [bx+si],al
00001788  0000              add [bx+si],al
0000178A  0000              add [bx+si],al
0000178C  0000              add [bx+si],al
0000178E  0000              add [bx+si],al
00001790  0000              add [bx+si],al
00001792  0000              add [bx+si],al
00001794  0000              add [bx+si],al
00001796  0000              add [bx+si],al
00001798  0000              add [bx+si],al
0000179A  0000              add [bx+si],al
0000179C  0000              add [bx+si],al
0000179E  0000              add [bx+si],al
000017A0  0000              add [bx+si],al
000017A2  0000              add [bx+si],al
000017A4  0000              add [bx+si],al
000017A6  0000              add [bx+si],al
000017A8  0000              add [bx+si],al
000017AA  0000              add [bx+si],al
000017AC  0000              add [bx+si],al
000017AE  0000              add [bx+si],al
000017B0  0000              add [bx+si],al
000017B2  0000              add [bx+si],al
000017B4  0000              add [bx+si],al
000017B6  0000              add [bx+si],al
000017B8  0000              add [bx+si],al
000017BA  0000              add [bx+si],al
000017BC  0000              add [bx+si],al
000017BE  0000              add [bx+si],al
000017C0  0000              add [bx+si],al
000017C2  0000              add [bx+si],al
000017C4  0000              add [bx+si],al
000017C6  0000              add [bx+si],al
000017C8  0000              add [bx+si],al
000017CA  0000              add [bx+si],al
000017CC  0000              add [bx+si],al
000017CE  0000              add [bx+si],al
000017D0  0000              add [bx+si],al
000017D2  0000              add [bx+si],al
000017D4  0000              add [bx+si],al
000017D6  0000              add [bx+si],al
000017D8  0000              add [bx+si],al
000017DA  0000              add [bx+si],al
000017DC  0000              add [bx+si],al
000017DE  0000              add [bx+si],al
000017E0  0000              add [bx+si],al
000017E2  0000              add [bx+si],al
000017E4  0000              add [bx+si],al
000017E6  0000              add [bx+si],al
000017E8  0000              add [bx+si],al
000017EA  0000              add [bx+si],al
000017EC  0000              add [bx+si],al
000017EE  0000              add [bx+si],al
000017F0  0000              add [bx+si],al
000017F2  0000              add [bx+si],al
000017F4  0000              add [bx+si],al
000017F6  0000              add [bx+si],al
000017F8  0000              add [bx+si],al
000017FA  0000              add [bx+si],al
000017FC  0000              add [bx+si],al
000017FE  0000              add [bx+si],al
00001800  0000              add [bx+si],al
00001802  0000              add [bx+si],al
00001804  0000              add [bx+si],al
00001806  0000              add [bx+si],al
00001808  0000              add [bx+si],al
0000180A  0000              add [bx+si],al
0000180C  0000              add [bx+si],al
0000180E  0000              add [bx+si],al
00001810  0000              add [bx+si],al
00001812  0000              add [bx+si],al
00001814  0000              add [bx+si],al
00001816  0000              add [bx+si],al
00001818  0000              add [bx+si],al
0000181A  0000              add [bx+si],al
0000181C  0000              add [bx+si],al
0000181E  0000              add [bx+si],al
00001820  0000              add [bx+si],al
00001822  0000              add [bx+si],al
00001824  0000              add [bx+si],al
00001826  0000              add [bx+si],al
00001828  0000              add [bx+si],al
0000182A  0000              add [bx+si],al
0000182C  0000              add [bx+si],al
0000182E  0000              add [bx+si],al
00001830  0000              add [bx+si],al
00001832  0000              add [bx+si],al
00001834  0000              add [bx+si],al
00001836  0000              add [bx+si],al
00001838  0000              add [bx+si],al
0000183A  0000              add [bx+si],al
0000183C  0000              add [bx+si],al
0000183E  0000              add [bx+si],al
00001840  0000              add [bx+si],al
00001842  0000              add [bx+si],al
00001844  0000              add [bx+si],al
00001846  0000              add [bx+si],al
00001848  0000              add [bx+si],al
0000184A  0000              add [bx+si],al
0000184C  0000              add [bx+si],al
0000184E  0000              add [bx+si],al
00001850  0000              add [bx+si],al
00001852  0000              add [bx+si],al
00001854  0000              add [bx+si],al
00001856  0000              add [bx+si],al
00001858  0000              add [bx+si],al
0000185A  0000              add [bx+si],al
0000185C  0000              add [bx+si],al
0000185E  0000              add [bx+si],al
00001860  0000              add [bx+si],al
00001862  0000              add [bx+si],al
00001864  0000              add [bx+si],al
00001866  0000              add [bx+si],al
00001868  0000              add [bx+si],al
0000186A  0000              add [bx+si],al
0000186C  0000              add [bx+si],al
0000186E  0000              add [bx+si],al
00001870  0000              add [bx+si],al
00001872  0000              add [bx+si],al
00001874  0000              add [bx+si],al
00001876  0000              add [bx+si],al
00001878  0000              add [bx+si],al
0000187A  0000              add [bx+si],al
0000187C  0000              add [bx+si],al
0000187E  0000              add [bx+si],al
00001880  0000              add [bx+si],al
00001882  0000              add [bx+si],al
00001884  0000              add [bx+si],al
00001886  0000              add [bx+si],al
00001888  0000              add [bx+si],al
0000188A  0000              add [bx+si],al
0000188C  0000              add [bx+si],al
0000188E  0000              add [bx+si],al
00001890  0000              add [bx+si],al
00001892  0000              add [bx+si],al
00001894  0000              add [bx+si],al
00001896  0000              add [bx+si],al
00001898  0000              add [bx+si],al
0000189A  0000              add [bx+si],al
0000189C  0000              add [bx+si],al
0000189E  0000              add [bx+si],al
000018A0  0000              add [bx+si],al
000018A2  0000              add [bx+si],al
000018A4  0000              add [bx+si],al
000018A6  0000              add [bx+si],al
000018A8  0000              add [bx+si],al
000018AA  0000              add [bx+si],al
000018AC  0000              add [bx+si],al
000018AE  0000              add [bx+si],al
000018B0  0000              add [bx+si],al
000018B2  0000              add [bx+si],al
000018B4  0000              add [bx+si],al
000018B6  0000              add [bx+si],al
000018B8  0000              add [bx+si],al
000018BA  0000              add [bx+si],al
000018BC  0000              add [bx+si],al
000018BE  0000              add [bx+si],al
000018C0  0000              add [bx+si],al
000018C2  0000              add [bx+si],al
000018C4  0000              add [bx+si],al
000018C6  0000              add [bx+si],al
000018C8  0000              add [bx+si],al
000018CA  0000              add [bx+si],al
000018CC  0000              add [bx+si],al
000018CE  0000              add [bx+si],al
000018D0  0000              add [bx+si],al
000018D2  0000              add [bx+si],al
000018D4  0000              add [bx+si],al
000018D6  0000              add [bx+si],al
000018D8  0000              add [bx+si],al
000018DA  0000              add [bx+si],al
000018DC  0000              add [bx+si],al
000018DE  0000              add [bx+si],al
000018E0  0000              add [bx+si],al
000018E2  0000              add [bx+si],al
000018E4  0000              add [bx+si],al
000018E6  0000              add [bx+si],al
000018E8  0000              add [bx+si],al
000018EA  0000              add [bx+si],al
000018EC  0000              add [bx+si],al
000018EE  0000              add [bx+si],al
000018F0  0000              add [bx+si],al
000018F2  0000              add [bx+si],al
000018F4  0000              add [bx+si],al
000018F6  0000              add [bx+si],al
000018F8  0000              add [bx+si],al
000018FA  0000              add [bx+si],al
000018FC  0000              add [bx+si],al
000018FE  0000              add [bx+si],al
00001900  0000              add [bx+si],al
00001902  0000              add [bx+si],al
00001904  0000              add [bx+si],al
00001906  0000              add [bx+si],al
00001908  0000              add [bx+si],al
0000190A  0000              add [bx+si],al
0000190C  0000              add [bx+si],al
0000190E  0000              add [bx+si],al
00001910  0000              add [bx+si],al
00001912  0000              add [bx+si],al
00001914  0000              add [bx+si],al
00001916  0000              add [bx+si],al
00001918  0000              add [bx+si],al
0000191A  0000              add [bx+si],al
0000191C  0000              add [bx+si],al
0000191E  0000              add [bx+si],al
00001920  0000              add [bx+si],al
00001922  0000              add [bx+si],al
00001924  0000              add [bx+si],al
00001926  0000              add [bx+si],al
00001928  0000              add [bx+si],al
0000192A  0000              add [bx+si],al
0000192C  0000              add [bx+si],al
0000192E  0000              add [bx+si],al
00001930  0000              add [bx+si],al
00001932  0000              add [bx+si],al
00001934  0000              add [bx+si],al
00001936  0000              add [bx+si],al
00001938  0000              add [bx+si],al
0000193A  0000              add [bx+si],al
0000193C  0000              add [bx+si],al
0000193E  0000              add [bx+si],al
00001940  0000              add [bx+si],al
00001942  0000              add [bx+si],al
00001944  0000              add [bx+si],al
00001946  0000              add [bx+si],al
00001948  0000              add [bx+si],al
0000194A  0000              add [bx+si],al
0000194C  0000              add [bx+si],al
0000194E  0000              add [bx+si],al
00001950  0000              add [bx+si],al
00001952  0000              add [bx+si],al
00001954  0000              add [bx+si],al
00001956  0000              add [bx+si],al
00001958  0000              add [bx+si],al
0000195A  0000              add [bx+si],al
0000195C  0000              add [bx+si],al
0000195E  0000              add [bx+si],al
00001960  0000              add [bx+si],al
00001962  0000              add [bx+si],al
00001964  0000              add [bx+si],al
00001966  0000              add [bx+si],al
00001968  0000              add [bx+si],al
0000196A  0000              add [bx+si],al
0000196C  0000              add [bx+si],al
0000196E  0000              add [bx+si],al
00001970  0000              add [bx+si],al
00001972  0000              add [bx+si],al
00001974  0000              add [bx+si],al
00001976  0000              add [bx+si],al
00001978  0000              add [bx+si],al
0000197A  0000              add [bx+si],al
0000197C  0000              add [bx+si],al
0000197E  0000              add [bx+si],al
00001980  0000              add [bx+si],al
00001982  0000              add [bx+si],al
00001984  0000              add [bx+si],al
00001986  0000              add [bx+si],al
00001988  0000              add [bx+si],al
0000198A  0000              add [bx+si],al
0000198C  0000              add [bx+si],al
0000198E  0000              add [bx+si],al
00001990  0000              add [bx+si],al
00001992  0000              add [bx+si],al
00001994  0000              add [bx+si],al
00001996  0000              add [bx+si],al
00001998  0000              add [bx+si],al
0000199A  0000              add [bx+si],al
0000199C  0000              add [bx+si],al
0000199E  0000              add [bx+si],al
000019A0  0000              add [bx+si],al
000019A2  0000              add [bx+si],al
000019A4  0000              add [bx+si],al
000019A6  0000              add [bx+si],al
000019A8  0000              add [bx+si],al
000019AA  0000              add [bx+si],al
000019AC  0000              add [bx+si],al
000019AE  0000              add [bx+si],al
000019B0  0000              add [bx+si],al
000019B2  0000              add [bx+si],al
000019B4  0000              add [bx+si],al
000019B6  0000              add [bx+si],al
000019B8  0000              add [bx+si],al
000019BA  0000              add [bx+si],al
000019BC  0000              add [bx+si],al
000019BE  0000              add [bx+si],al
000019C0  0000              add [bx+si],al
000019C2  0000              add [bx+si],al
000019C4  0000              add [bx+si],al
000019C6  0000              add [bx+si],al
000019C8  0000              add [bx+si],al
000019CA  0000              add [bx+si],al
000019CC  0000              add [bx+si],al
000019CE  0000              add [bx+si],al
000019D0  0000              add [bx+si],al
000019D2  0000              add [bx+si],al
000019D4  0000              add [bx+si],al
000019D6  0000              add [bx+si],al
000019D8  0000              add [bx+si],al
000019DA  0000              add [bx+si],al
000019DC  0000              add [bx+si],al
000019DE  0000              add [bx+si],al
000019E0  0000              add [bx+si],al
000019E2  0000              add [bx+si],al
000019E4  0000              add [bx+si],al
000019E6  0000              add [bx+si],al
000019E8  0000              add [bx+si],al
000019EA  0000              add [bx+si],al
000019EC  0000              add [bx+si],al
000019EE  0000              add [bx+si],al
000019F0  0000              add [bx+si],al
000019F2  0000              add [bx+si],al
000019F4  0000              add [bx+si],al
000019F6  0000              add [bx+si],al
000019F8  0000              add [bx+si],al
000019FA  0000              add [bx+si],al
000019FC  0000              add [bx+si],al
000019FE  0000              add [bx+si],al
00001A00  0000              add [bx+si],al
00001A02  0000              add [bx+si],al
00001A04  0000              add [bx+si],al
00001A06  0000              add [bx+si],al
00001A08  0000              add [bx+si],al
00001A0A  0000              add [bx+si],al
00001A0C  0000              add [bx+si],al
00001A0E  0000              add [bx+si],al
00001A10  0000              add [bx+si],al
00001A12  0000              add [bx+si],al
00001A14  0000              add [bx+si],al
00001A16  0000              add [bx+si],al
00001A18  0000              add [bx+si],al
00001A1A  0000              add [bx+si],al
00001A1C  0000              add [bx+si],al
00001A1E  0000              add [bx+si],al
00001A20  0000              add [bx+si],al
00001A22  0000              add [bx+si],al
00001A24  0000              add [bx+si],al
00001A26  0000              add [bx+si],al
00001A28  0000              add [bx+si],al
00001A2A  0000              add [bx+si],al
00001A2C  0000              add [bx+si],al
00001A2E  0000              add [bx+si],al
00001A30  0000              add [bx+si],al
00001A32  0000              add [bx+si],al
00001A34  0000              add [bx+si],al
00001A36  0000              add [bx+si],al
00001A38  0000              add [bx+si],al
00001A3A  0000              add [bx+si],al
00001A3C  0000              add [bx+si],al
00001A3E  0000              add [bx+si],al
00001A40  0000              add [bx+si],al
00001A42  0000              add [bx+si],al
00001A44  0000              add [bx+si],al
00001A46  0000              add [bx+si],al
00001A48  0000              add [bx+si],al
00001A4A  0000              add [bx+si],al
00001A4C  0000              add [bx+si],al
00001A4E  0000              add [bx+si],al
00001A50  0000              add [bx+si],al
00001A52  0000              add [bx+si],al
00001A54  0000              add [bx+si],al
00001A56  0000              add [bx+si],al
00001A58  0000              add [bx+si],al
00001A5A  0000              add [bx+si],al
00001A5C  0000              add [bx+si],al
00001A5E  0000              add [bx+si],al
00001A60  0000              add [bx+si],al
00001A62  0000              add [bx+si],al
00001A64  0000              add [bx+si],al
00001A66  0000              add [bx+si],al
00001A68  0000              add [bx+si],al
00001A6A  0000              add [bx+si],al
00001A6C  0000              add [bx+si],al
00001A6E  0000              add [bx+si],al
00001A70  0000              add [bx+si],al
00001A72  0000              add [bx+si],al
00001A74  0000              add [bx+si],al
00001A76  0000              add [bx+si],al
00001A78  0000              add [bx+si],al
00001A7A  0000              add [bx+si],al
00001A7C  0000              add [bx+si],al
00001A7E  0000              add [bx+si],al
00001A80  0000              add [bx+si],al
00001A82  0000              add [bx+si],al
00001A84  0000              add [bx+si],al
00001A86  0000              add [bx+si],al
00001A88  0000              add [bx+si],al
00001A8A  0000              add [bx+si],al
00001A8C  0000              add [bx+si],al
00001A8E  0000              add [bx+si],al
00001A90  0000              add [bx+si],al
00001A92  0000              add [bx+si],al
00001A94  0000              add [bx+si],al
00001A96  0000              add [bx+si],al
00001A98  0000              add [bx+si],al
00001A9A  0000              add [bx+si],al
00001A9C  0000              add [bx+si],al
00001A9E  0000              add [bx+si],al
00001AA0  0000              add [bx+si],al
00001AA2  0000              add [bx+si],al
00001AA4  0000              add [bx+si],al
00001AA6  0000              add [bx+si],al
00001AA8  0000              add [bx+si],al
00001AAA  0000              add [bx+si],al
00001AAC  0000              add [bx+si],al
00001AAE  0000              add [bx+si],al
00001AB0  0000              add [bx+si],al
00001AB2  0000              add [bx+si],al
00001AB4  0000              add [bx+si],al
00001AB6  0000              add [bx+si],al
00001AB8  0000              add [bx+si],al
00001ABA  0000              add [bx+si],al
00001ABC  0000              add [bx+si],al
00001ABE  0000              add [bx+si],al
00001AC0  0000              add [bx+si],al
00001AC2  0000              add [bx+si],al
00001AC4  0000              add [bx+si],al
00001AC6  0000              add [bx+si],al
00001AC8  0000              add [bx+si],al
00001ACA  0000              add [bx+si],al
00001ACC  0000              add [bx+si],al
00001ACE  0000              add [bx+si],al
00001AD0  0000              add [bx+si],al
00001AD2  0000              add [bx+si],al
00001AD4  0000              add [bx+si],al
00001AD6  0000              add [bx+si],al
00001AD8  0000              add [bx+si],al
00001ADA  0000              add [bx+si],al
00001ADC  0000              add [bx+si],al
00001ADE  0000              add [bx+si],al
00001AE0  0000              add [bx+si],al
00001AE2  0000              add [bx+si],al
00001AE4  0000              add [bx+si],al
00001AE6  0000              add [bx+si],al
00001AE8  0000              add [bx+si],al
00001AEA  0000              add [bx+si],al
00001AEC  0000              add [bx+si],al
00001AEE  0000              add [bx+si],al
00001AF0  0000              add [bx+si],al
00001AF2  0000              add [bx+si],al
00001AF4  0000              add [bx+si],al
00001AF6  0000              add [bx+si],al
00001AF8  0000              add [bx+si],al
00001AFA  0000              add [bx+si],al
00001AFC  0000              add [bx+si],al
00001AFE  0000              add [bx+si],al
00001B00  0000              add [bx+si],al
00001B02  0000              add [bx+si],al
00001B04  0000              add [bx+si],al
00001B06  0000              add [bx+si],al
00001B08  0000              add [bx+si],al
00001B0A  0000              add [bx+si],al
00001B0C  0000              add [bx+si],al
00001B0E  0000              add [bx+si],al
00001B10  0000              add [bx+si],al
00001B12  0000              add [bx+si],al
00001B14  0000              add [bx+si],al
00001B16  0000              add [bx+si],al
00001B18  0000              add [bx+si],al
00001B1A  0000              add [bx+si],al
00001B1C  0000              add [bx+si],al
00001B1E  0000              add [bx+si],al
00001B20  0000              add [bx+si],al
00001B22  0000              add [bx+si],al
00001B24  0000              add [bx+si],al
00001B26  0000              add [bx+si],al
00001B28  0000              add [bx+si],al
00001B2A  0000              add [bx+si],al
00001B2C  0000              add [bx+si],al
00001B2E  0000              add [bx+si],al
00001B30  0000              add [bx+si],al
00001B32  0000              add [bx+si],al
00001B34  0000              add [bx+si],al
00001B36  0000              add [bx+si],al
00001B38  0000              add [bx+si],al
00001B3A  0000              add [bx+si],al
00001B3C  0000              add [bx+si],al
00001B3E  0000              add [bx+si],al
00001B40  0000              add [bx+si],al
00001B42  0000              add [bx+si],al
00001B44  0000              add [bx+si],al
00001B46  0000              add [bx+si],al
00001B48  0000              add [bx+si],al
00001B4A  0000              add [bx+si],al
00001B4C  0000              add [bx+si],al
00001B4E  0000              add [bx+si],al
00001B50  0000              add [bx+si],al
00001B52  0000              add [bx+si],al
00001B54  0000              add [bx+si],al
00001B56  0000              add [bx+si],al
00001B58  0000              add [bx+si],al
00001B5A  0000              add [bx+si],al
00001B5C  0000              add [bx+si],al
00001B5E  0000              add [bx+si],al
00001B60  0000              add [bx+si],al
00001B62  0000              add [bx+si],al
00001B64  0000              add [bx+si],al
00001B66  0000              add [bx+si],al
00001B68  0000              add [bx+si],al
00001B6A  0000              add [bx+si],al
00001B6C  0000              add [bx+si],al
00001B6E  0000              add [bx+si],al
00001B70  0000              add [bx+si],al
00001B72  0000              add [bx+si],al
00001B74  0000              add [bx+si],al
00001B76  0000              add [bx+si],al
00001B78  0000              add [bx+si],al
00001B7A  0000              add [bx+si],al
00001B7C  0000              add [bx+si],al
00001B7E  0000              add [bx+si],al
00001B80  0000              add [bx+si],al
00001B82  0000              add [bx+si],al
00001B84  0000              add [bx+si],al
00001B86  0000              add [bx+si],al
00001B88  0000              add [bx+si],al
00001B8A  0000              add [bx+si],al
00001B8C  0000              add [bx+si],al
00001B8E  0000              add [bx+si],al
00001B90  0000              add [bx+si],al
00001B92  0000              add [bx+si],al
00001B94  0000              add [bx+si],al
00001B96  0000              add [bx+si],al
00001B98  0000              add [bx+si],al
00001B9A  0000              add [bx+si],al
00001B9C  0000              add [bx+si],al
00001B9E  0000              add [bx+si],al
00001BA0  0000              add [bx+si],al
00001BA2  0000              add [bx+si],al
00001BA4  0000              add [bx+si],al
00001BA6  0000              add [bx+si],al
00001BA8  0000              add [bx+si],al
00001BAA  0000              add [bx+si],al
00001BAC  0000              add [bx+si],al
00001BAE  0000              add [bx+si],al
00001BB0  0000              add [bx+si],al
00001BB2  0000              add [bx+si],al
00001BB4  0000              add [bx+si],al
00001BB6  0000              add [bx+si],al
00001BB8  0000              add [bx+si],al
00001BBA  0000              add [bx+si],al
00001BBC  0000              add [bx+si],al
00001BBE  0000              add [bx+si],al
00001BC0  0000              add [bx+si],al
00001BC2  0000              add [bx+si],al
00001BC4  0000              add [bx+si],al
00001BC6  0000              add [bx+si],al
00001BC8  0000              add [bx+si],al
00001BCA  0000              add [bx+si],al
00001BCC  0000              add [bx+si],al
00001BCE  0000              add [bx+si],al
00001BD0  0000              add [bx+si],al
00001BD2  0000              add [bx+si],al
00001BD4  0000              add [bx+si],al
00001BD6  0000              add [bx+si],al
00001BD8  0000              add [bx+si],al
00001BDA  0000              add [bx+si],al
00001BDC  0000              add [bx+si],al
00001BDE  0000              add [bx+si],al
00001BE0  0000              add [bx+si],al
00001BE2  0000              add [bx+si],al
00001BE4  0000              add [bx+si],al
00001BE6  0000              add [bx+si],al
00001BE8  0000              add [bx+si],al
00001BEA  0000              add [bx+si],al
00001BEC  0000              add [bx+si],al
00001BEE  0000              add [bx+si],al
00001BF0  0000              add [bx+si],al
00001BF2  0000              add [bx+si],al
00001BF4  0000              add [bx+si],al
00001BF6  0000              add [bx+si],al
00001BF8  0000              add [bx+si],al
00001BFA  0000              add [bx+si],al
00001BFC  0000              add [bx+si],al
00001BFE  0000              add [bx+si],al
00001C00  0000              add [bx+si],al
00001C02  0000              add [bx+si],al
00001C04  0000              add [bx+si],al
00001C06  0000              add [bx+si],al
00001C08  0000              add [bx+si],al
00001C0A  0000              add [bx+si],al
00001C0C  0000              add [bx+si],al
00001C0E  0000              add [bx+si],al
00001C10  0000              add [bx+si],al
00001C12  0000              add [bx+si],al
00001C14  0000              add [bx+si],al
00001C16  0000              add [bx+si],al
00001C18  0000              add [bx+si],al
00001C1A  0000              add [bx+si],al
00001C1C  0000              add [bx+si],al
00001C1E  0000              add [bx+si],al
00001C20  0000              add [bx+si],al
00001C22  0000              add [bx+si],al
00001C24  0000              add [bx+si],al
00001C26  0000              add [bx+si],al
00001C28  0000              add [bx+si],al
00001C2A  0000              add [bx+si],al
00001C2C  0000              add [bx+si],al
00001C2E  0000              add [bx+si],al
00001C30  0000              add [bx+si],al
00001C32  0000              add [bx+si],al
00001C34  0000              add [bx+si],al
00001C36  0000              add [bx+si],al
00001C38  0000              add [bx+si],al
00001C3A  0000              add [bx+si],al
00001C3C  0000              add [bx+si],al
00001C3E  0000              add [bx+si],al
00001C40  0000              add [bx+si],al
00001C42  0000              add [bx+si],al
00001C44  0000              add [bx+si],al
00001C46  0000              add [bx+si],al
00001C48  0000              add [bx+si],al
00001C4A  0000              add [bx+si],al
00001C4C  0000              add [bx+si],al
00001C4E  0000              add [bx+si],al
00001C50  0000              add [bx+si],al
00001C52  0000              add [bx+si],al
00001C54  0000              add [bx+si],al
00001C56  0000              add [bx+si],al
00001C58  0000              add [bx+si],al
00001C5A  0000              add [bx+si],al
00001C5C  0000              add [bx+si],al
00001C5E  0000              add [bx+si],al
00001C60  0000              add [bx+si],al
00001C62  0000              add [bx+si],al
00001C64  0000              add [bx+si],al
00001C66  0000              add [bx+si],al
00001C68  0000              add [bx+si],al
00001C6A  0000              add [bx+si],al
00001C6C  0000              add [bx+si],al
00001C6E  0000              add [bx+si],al
00001C70  0000              add [bx+si],al
00001C72  0000              add [bx+si],al
00001C74  0000              add [bx+si],al
00001C76  0000              add [bx+si],al
00001C78  0000              add [bx+si],al
00001C7A  0000              add [bx+si],al
00001C7C  0000              add [bx+si],al
00001C7E  0000              add [bx+si],al
00001C80  0000              add [bx+si],al
00001C82  0000              add [bx+si],al
00001C84  0000              add [bx+si],al
00001C86  0000              add [bx+si],al
00001C88  0000              add [bx+si],al
00001C8A  0000              add [bx+si],al
00001C8C  0000              add [bx+si],al
00001C8E  0000              add [bx+si],al
00001C90  0000              add [bx+si],al
00001C92  0000              add [bx+si],al
00001C94  0000              add [bx+si],al
00001C96  0000              add [bx+si],al
00001C98  0000              add [bx+si],al
00001C9A  0000              add [bx+si],al
00001C9C  0000              add [bx+si],al
00001C9E  0000              add [bx+si],al
00001CA0  0000              add [bx+si],al
00001CA2  0000              add [bx+si],al
00001CA4  0000              add [bx+si],al
00001CA6  0000              add [bx+si],al
00001CA8  0000              add [bx+si],al
00001CAA  0000              add [bx+si],al
00001CAC  0000              add [bx+si],al
00001CAE  0000              add [bx+si],al
00001CB0  0000              add [bx+si],al
00001CB2  0000              add [bx+si],al
00001CB4  0000              add [bx+si],al
00001CB6  0000              add [bx+si],al
00001CB8  0000              add [bx+si],al
00001CBA  0000              add [bx+si],al
00001CBC  0000              add [bx+si],al
00001CBE  0000              add [bx+si],al
00001CC0  0000              add [bx+si],al
00001CC2  0000              add [bx+si],al
00001CC4  0000              add [bx+si],al
00001CC6  0000              add [bx+si],al
00001CC8  0000              add [bx+si],al
00001CCA  0000              add [bx+si],al
00001CCC  0000              add [bx+si],al
00001CCE  0000              add [bx+si],al
00001CD0  0000              add [bx+si],al
00001CD2  0000              add [bx+si],al
00001CD4  0000              add [bx+si],al
00001CD6  0000              add [bx+si],al
00001CD8  0000              add [bx+si],al
00001CDA  0000              add [bx+si],al
00001CDC  0000              add [bx+si],al
00001CDE  0000              add [bx+si],al
00001CE0  0000              add [bx+si],al
00001CE2  0000              add [bx+si],al
00001CE4  0000              add [bx+si],al
00001CE6  0000              add [bx+si],al
00001CE8  0000              add [bx+si],al
00001CEA  0000              add [bx+si],al
00001CEC  0000              add [bx+si],al
00001CEE  0000              add [bx+si],al
00001CF0  0000              add [bx+si],al
00001CF2  0000              add [bx+si],al
00001CF4  0000              add [bx+si],al
00001CF6  0000              add [bx+si],al
00001CF8  0000              add [bx+si],al
00001CFA  0000              add [bx+si],al
00001CFC  0000              add [bx+si],al
00001CFE  0000              add [bx+si],al
00001D00  0000              add [bx+si],al
00001D02  0000              add [bx+si],al
00001D04  0000              add [bx+si],al
00001D06  0000              add [bx+si],al
00001D08  0000              add [bx+si],al
00001D0A  0000              add [bx+si],al
00001D0C  0000              add [bx+si],al
00001D0E  0000              add [bx+si],al
00001D10  0000              add [bx+si],al
00001D12  0000              add [bx+si],al
00001D14  0000              add [bx+si],al
00001D16  0000              add [bx+si],al
00001D18  0000              add [bx+si],al
00001D1A  0000              add [bx+si],al
00001D1C  0000              add [bx+si],al
00001D1E  0000              add [bx+si],al
00001D20  0000              add [bx+si],al
00001D22  0000              add [bx+si],al
00001D24  0000              add [bx+si],al
00001D26  0000              add [bx+si],al
00001D28  0000              add [bx+si],al
00001D2A  0000              add [bx+si],al
00001D2C  0000              add [bx+si],al
00001D2E  0000              add [bx+si],al
00001D30  0000              add [bx+si],al
00001D32  0000              add [bx+si],al
00001D34  0000              add [bx+si],al
00001D36  0000              add [bx+si],al
00001D38  0000              add [bx+si],al
00001D3A  0000              add [bx+si],al
00001D3C  0000              add [bx+si],al
00001D3E  0000              add [bx+si],al
00001D40  0000              add [bx+si],al
00001D42  0000              add [bx+si],al
00001D44  0000              add [bx+si],al
00001D46  0000              add [bx+si],al
00001D48  0000              add [bx+si],al
00001D4A  0000              add [bx+si],al
00001D4C  0000              add [bx+si],al
00001D4E  0000              add [bx+si],al
00001D50  0000              add [bx+si],al
00001D52  0000              add [bx+si],al
00001D54  0000              add [bx+si],al
00001D56  0000              add [bx+si],al
00001D58  0000              add [bx+si],al
00001D5A  0000              add [bx+si],al
00001D5C  0000              add [bx+si],al
00001D5E  0000              add [bx+si],al
00001D60  0000              add [bx+si],al
00001D62  0000              add [bx+si],al
00001D64  0000              add [bx+si],al
00001D66  0000              add [bx+si],al
00001D68  0000              add [bx+si],al
00001D6A  0000              add [bx+si],al
00001D6C  0000              add [bx+si],al
00001D6E  0000              add [bx+si],al
00001D70  0000              add [bx+si],al
00001D72  0000              add [bx+si],al
00001D74  0000              add [bx+si],al
00001D76  0000              add [bx+si],al
00001D78  0000              add [bx+si],al
00001D7A  0000              add [bx+si],al
00001D7C  0000              add [bx+si],al
00001D7E  0000              add [bx+si],al
00001D80  0000              add [bx+si],al
00001D82  0000              add [bx+si],al
00001D84  0000              add [bx+si],al
00001D86  0000              add [bx+si],al
00001D88  0000              add [bx+si],al
00001D8A  0000              add [bx+si],al
00001D8C  0000              add [bx+si],al
00001D8E  0000              add [bx+si],al
00001D90  0000              add [bx+si],al
00001D92  0000              add [bx+si],al
00001D94  0000              add [bx+si],al
00001D96  0000              add [bx+si],al
00001D98  0000              add [bx+si],al
00001D9A  0000              add [bx+si],al
00001D9C  0000              add [bx+si],al
00001D9E  0000              add [bx+si],al
00001DA0  0000              add [bx+si],al
00001DA2  0000              add [bx+si],al
00001DA4  0000              add [bx+si],al
00001DA6  0000              add [bx+si],al
00001DA8  0000              add [bx+si],al
00001DAA  0000              add [bx+si],al
00001DAC  0000              add [bx+si],al
00001DAE  0000              add [bx+si],al
00001DB0  0000              add [bx+si],al
00001DB2  0000              add [bx+si],al
00001DB4  0000              add [bx+si],al
00001DB6  0000              add [bx+si],al
00001DB8  0000              add [bx+si],al
00001DBA  0000              add [bx+si],al
00001DBC  0000              add [bx+si],al
00001DBE  0000              add [bx+si],al
00001DC0  0000              add [bx+si],al
00001DC2  0000              add [bx+si],al
00001DC4  0000              add [bx+si],al
00001DC6  0000              add [bx+si],al
00001DC8  0000              add [bx+si],al
00001DCA  0000              add [bx+si],al
00001DCC  0000              add [bx+si],al
00001DCE  0000              add [bx+si],al
00001DD0  0000              add [bx+si],al
00001DD2  0000              add [bx+si],al
00001DD4  0000              add [bx+si],al
00001DD6  0000              add [bx+si],al
00001DD8  0000              add [bx+si],al
00001DDA  0000              add [bx+si],al
00001DDC  0000              add [bx+si],al
00001DDE  0000              add [bx+si],al
00001DE0  0000              add [bx+si],al
00001DE2  0000              add [bx+si],al
00001DE4  0000              add [bx+si],al
00001DE6  0000              add [bx+si],al
00001DE8  0000              add [bx+si],al
00001DEA  0000              add [bx+si],al
00001DEC  0000              add [bx+si],al
00001DEE  0000              add [bx+si],al
00001DF0  0000              add [bx+si],al
00001DF2  0000              add [bx+si],al
00001DF4  0000              add [bx+si],al
00001DF6  0000              add [bx+si],al
00001DF8  0000              add [bx+si],al
00001DFA  0000              add [bx+si],al
00001DFC  0000              add [bx+si],al
00001DFE  0000              add [bx+si],al
00001E00  0000              add [bx+si],al
00001E02  0000              add [bx+si],al
00001E04  0000              add [bx+si],al
00001E06  0000              add [bx+si],al
00001E08  0000              add [bx+si],al
00001E0A  0000              add [bx+si],al
00001E0C  0000              add [bx+si],al
00001E0E  0000              add [bx+si],al
00001E10  0000              add [bx+si],al
00001E12  0000              add [bx+si],al
00001E14  0000              add [bx+si],al
00001E16  0000              add [bx+si],al
00001E18  0000              add [bx+si],al
00001E1A  0000              add [bx+si],al
00001E1C  0000              add [bx+si],al
00001E1E  0000              add [bx+si],al
00001E20  0000              add [bx+si],al
00001E22  0000              add [bx+si],al
00001E24  0000              add [bx+si],al
00001E26  0000              add [bx+si],al
00001E28  0000              add [bx+si],al
00001E2A  0000              add [bx+si],al
00001E2C  0000              add [bx+si],al
00001E2E  0000              add [bx+si],al
00001E30  0000              add [bx+si],al
00001E32  0000              add [bx+si],al
00001E34  0000              add [bx+si],al
00001E36  0000              add [bx+si],al
00001E38  0000              add [bx+si],al
00001E3A  0000              add [bx+si],al
00001E3C  0000              add [bx+si],al
00001E3E  0000              add [bx+si],al
00001E40  0000              add [bx+si],al
00001E42  0000              add [bx+si],al
00001E44  0000              add [bx+si],al
00001E46  0000              add [bx+si],al
00001E48  0000              add [bx+si],al
00001E4A  0000              add [bx+si],al
00001E4C  0000              add [bx+si],al
00001E4E  0000              add [bx+si],al
00001E50  0000              add [bx+si],al
00001E52  0000              add [bx+si],al
00001E54  0000              add [bx+si],al
00001E56  0000              add [bx+si],al
00001E58  0000              add [bx+si],al
00001E5A  0000              add [bx+si],al
00001E5C  0000              add [bx+si],al
00001E5E  0000              add [bx+si],al
00001E60  0000              add [bx+si],al
00001E62  0000              add [bx+si],al
00001E64  0000              add [bx+si],al
00001E66  0000              add [bx+si],al
00001E68  0000              add [bx+si],al
00001E6A  0000              add [bx+si],al
00001E6C  0000              add [bx+si],al
00001E6E  0000              add [bx+si],al
00001E70  0000              add [bx+si],al
00001E72  0000              add [bx+si],al
00001E74  0000              add [bx+si],al
00001E76  0000              add [bx+si],al
00001E78  0000              add [bx+si],al
00001E7A  0000              add [bx+si],al
00001E7C  0000              add [bx+si],al
00001E7E  0000              add [bx+si],al
00001E80  0000              add [bx+si],al
00001E82  0000              add [bx+si],al
00001E84  0000              add [bx+si],al
00001E86  0000              add [bx+si],al
00001E88  0000              add [bx+si],al
00001E8A  0000              add [bx+si],al
00001E8C  0000              add [bx+si],al
00001E8E  0000              add [bx+si],al
00001E90  0000              add [bx+si],al
00001E92  0000              add [bx+si],al
00001E94  0000              add [bx+si],al
00001E96  0000              add [bx+si],al
00001E98  0000              add [bx+si],al
00001E9A  0000              add [bx+si],al
00001E9C  0000              add [bx+si],al
00001E9E  0000              add [bx+si],al
00001EA0  0000              add [bx+si],al
00001EA2  0000              add [bx+si],al
00001EA4  0000              add [bx+si],al
00001EA6  0000              add [bx+si],al
00001EA8  0000              add [bx+si],al
00001EAA  0000              add [bx+si],al
00001EAC  0000              add [bx+si],al
00001EAE  0000              add [bx+si],al
00001EB0  0000              add [bx+si],al
00001EB2  0000              add [bx+si],al
00001EB4  0000              add [bx+si],al
00001EB6  0000              add [bx+si],al
00001EB8  0000              add [bx+si],al
00001EBA  0000              add [bx+si],al
00001EBC  0000              add [bx+si],al
00001EBE  0000              add [bx+si],al
00001EC0  0000              add [bx+si],al
00001EC2  0000              add [bx+si],al
00001EC4  0000              add [bx+si],al
00001EC6  0000              add [bx+si],al
00001EC8  0000              add [bx+si],al
00001ECA  0000              add [bx+si],al
00001ECC  0000              add [bx+si],al
00001ECE  0000              add [bx+si],al
00001ED0  0000              add [bx+si],al
00001ED2  0000              add [bx+si],al
00001ED4  0000              add [bx+si],al
00001ED6  0000              add [bx+si],al
00001ED8  0000              add [bx+si],al
00001EDA  0000              add [bx+si],al
00001EDC  0000              add [bx+si],al
00001EDE  0000              add [bx+si],al
00001EE0  0000              add [bx+si],al
00001EE2  0000              add [bx+si],al
00001EE4  0000              add [bx+si],al
00001EE6  0000              add [bx+si],al
00001EE8  0000              add [bx+si],al
00001EEA  0000              add [bx+si],al
00001EEC  0000              add [bx+si],al
00001EEE  0000              add [bx+si],al
00001EF0  0000              add [bx+si],al
00001EF2  0000              add [bx+si],al
00001EF4  0000              add [bx+si],al
00001EF6  0000              add [bx+si],al
00001EF8  0000              add [bx+si],al
00001EFA  0000              add [bx+si],al
00001EFC  0000              add [bx+si],al
00001EFE  0000              add [bx+si],al
00001F00  0000              add [bx+si],al
00001F02  0000              add [bx+si],al
00001F04  0000              add [bx+si],al
00001F06  0000              add [bx+si],al
00001F08  0000              add [bx+si],al
00001F0A  0000              add [bx+si],al
00001F0C  0000              add [bx+si],al
00001F0E  0000              add [bx+si],al
00001F10  0000              add [bx+si],al
00001F12  0000              add [bx+si],al
00001F14  0000              add [bx+si],al
00001F16  0000              add [bx+si],al
00001F18  0000              add [bx+si],al
00001F1A  0000              add [bx+si],al
00001F1C  0000              add [bx+si],al
00001F1E  0000              add [bx+si],al
00001F20  0000              add [bx+si],al
00001F22  0000              add [bx+si],al
00001F24  0000              add [bx+si],al
00001F26  0000              add [bx+si],al
00001F28  0000              add [bx+si],al
00001F2A  0000              add [bx+si],al
00001F2C  0000              add [bx+si],al
00001F2E  0000              add [bx+si],al
00001F30  0000              add [bx+si],al
00001F32  0000              add [bx+si],al
00001F34  0000              add [bx+si],al
00001F36  0000              add [bx+si],al
00001F38  0000              add [bx+si],al
00001F3A  0000              add [bx+si],al
00001F3C  0000              add [bx+si],al
00001F3E  0000              add [bx+si],al
00001F40  0000              add [bx+si],al
00001F42  0000              add [bx+si],al
00001F44  0000              add [bx+si],al
00001F46  0000              add [bx+si],al
00001F48  0000              add [bx+si],al
00001F4A  0000              add [bx+si],al
00001F4C  0000              add [bx+si],al
00001F4E  0000              add [bx+si],al
00001F50  0000              add [bx+si],al
00001F52  0000              add [bx+si],al
00001F54  0000              add [bx+si],al
00001F56  0000              add [bx+si],al
00001F58  0000              add [bx+si],al
00001F5A  0000              add [bx+si],al
00001F5C  0000              add [bx+si],al
00001F5E  0000              add [bx+si],al
00001F60  0000              add [bx+si],al
00001F62  0000              add [bx+si],al
00001F64  0000              add [bx+si],al
00001F66  0000              add [bx+si],al
00001F68  0000              add [bx+si],al
00001F6A  0000              add [bx+si],al
00001F6C  0000              add [bx+si],al
00001F6E  0000              add [bx+si],al
00001F70  0000              add [bx+si],al
00001F72  0000              add [bx+si],al
00001F74  0000              add [bx+si],al
00001F76  0000              add [bx+si],al
00001F78  0000              add [bx+si],al
00001F7A  0000              add [bx+si],al
00001F7C  0000              add [bx+si],al
00001F7E  0000              add [bx+si],al
00001F80  0000              add [bx+si],al
00001F82  0000              add [bx+si],al
00001F84  0000              add [bx+si],al
00001F86  0000              add [bx+si],al
00001F88  0000              add [bx+si],al
00001F8A  0000              add [bx+si],al
00001F8C  0000              add [bx+si],al
00001F8E  0000              add [bx+si],al
00001F90  0000              add [bx+si],al
00001F92  0000              add [bx+si],al
00001F94  0000              add [bx+si],al
00001F96  0000              add [bx+si],al
00001F98  0000              add [bx+si],al
00001F9A  0000              add [bx+si],al
00001F9C  0000              add [bx+si],al
00001F9E  0000              add [bx+si],al
00001FA0  0000              add [bx+si],al
00001FA2  0000              add [bx+si],al
00001FA4  0000              add [bx+si],al
00001FA6  0000              add [bx+si],al
00001FA8  0000              add [bx+si],al
00001FAA  0000              add [bx+si],al
00001FAC  0000              add [bx+si],al
00001FAE  0000              add [bx+si],al
00001FB0  0000              add [bx+si],al
00001FB2  0000              add [bx+si],al
00001FB4  0000              add [bx+si],al
00001FB6  0000              add [bx+si],al
00001FB8  0000              add [bx+si],al
00001FBA  0000              add [bx+si],al
00001FBC  0000              add [bx+si],al
00001FBE  0000              add [bx+si],al
00001FC0  0000              add [bx+si],al
00001FC2  0000              add [bx+si],al
00001FC4  0000              add [bx+si],al
00001FC6  0000              add [bx+si],al
00001FC8  0000              add [bx+si],al
00001FCA  0000              add [bx+si],al
00001FCC  0000              add [bx+si],al
00001FCE  0000              add [bx+si],al
00001FD0  0000              add [bx+si],al
00001FD2  0000              add [bx+si],al
00001FD4  0000              add [bx+si],al
00001FD6  0000              add [bx+si],al
00001FD8  0000              add [bx+si],al
00001FDA  0000              add [bx+si],al
00001FDC  0000              add [bx+si],al
00001FDE  0000              add [bx+si],al
00001FE0  0000              add [bx+si],al
00001FE2  0000              add [bx+si],al
00001FE4  0000              add [bx+si],al
00001FE6  0000              add [bx+si],al
00001FE8  0000              add [bx+si],al
00001FEA  0000              add [bx+si],al
00001FEC  0000              add [bx+si],al
00001FEE  0000              add [bx+si],al
00001FF0  0000              add [bx+si],al
00001FF2  0000              add [bx+si],al
00001FF4  0000              add [bx+si],al
00001FF6  0000              add [bx+si],al
00001FF8  0000              add [bx+si],al
00001FFA  0000              add [bx+si],al
00001FFC  0000              add [bx+si],al
00001FFE  0000              add [bx+si],al
00002000  0000              add [bx+si],al
00002002  0000              add [bx+si],al
00002004  0000              add [bx+si],al
00002006  0000              add [bx+si],al
00002008  0000              add [bx+si],al
0000200A  0000              add [bx+si],al
0000200C  0000              add [bx+si],al
0000200E  0000              add [bx+si],al
00002010  0000              add [bx+si],al
00002012  0000              add [bx+si],al
00002014  0000              add [bx+si],al
00002016  0000              add [bx+si],al
00002018  0000              add [bx+si],al
0000201A  0000              add [bx+si],al
0000201C  0000              add [bx+si],al
0000201E  0000              add [bx+si],al
00002020  0000              add [bx+si],al
00002022  0000              add [bx+si],al
00002024  0000              add [bx+si],al
00002026  0000              add [bx+si],al
00002028  0000              add [bx+si],al
0000202A  0000              add [bx+si],al
0000202C  0000              add [bx+si],al
0000202E  0000              add [bx+si],al
00002030  0000              add [bx+si],al
00002032  0000              add [bx+si],al
00002034  0000              add [bx+si],al
00002036  0000              add [bx+si],al
00002038  0000              add [bx+si],al
0000203A  0000              add [bx+si],al
0000203C  0000              add [bx+si],al
0000203E  0000              add [bx+si],al
00002040  0000              add [bx+si],al
00002042  0000              add [bx+si],al
00002044  0000              add [bx+si],al
00002046  0000              add [bx+si],al
00002048  0000              add [bx+si],al
0000204A  0000              add [bx+si],al
0000204C  0000              add [bx+si],al
0000204E  0000              add [bx+si],al
00002050  0000              add [bx+si],al
00002052  0000              add [bx+si],al
00002054  0000              add [bx+si],al
00002056  0000              add [bx+si],al
00002058  0000              add [bx+si],al
0000205A  0000              add [bx+si],al
0000205C  0000              add [bx+si],al
0000205E  0000              add [bx+si],al
00002060  0000              add [bx+si],al
00002062  0000              add [bx+si],al
00002064  0000              add [bx+si],al
00002066  0000              add [bx+si],al
00002068  0000              add [bx+si],al
0000206A  0000              add [bx+si],al
0000206C  0000              add [bx+si],al
0000206E  0000              add [bx+si],al
00002070  0000              add [bx+si],al
00002072  0000              add [bx+si],al
00002074  0000              add [bx+si],al
00002076  0000              add [bx+si],al
00002078  0000              add [bx+si],al
0000207A  0000              add [bx+si],al
0000207C  0000              add [bx+si],al
0000207E  0000              add [bx+si],al
00002080  0000              add [bx+si],al
00002082  0000              add [bx+si],al
00002084  0000              add [bx+si],al
00002086  0000              add [bx+si],al
00002088  0000              add [bx+si],al
0000208A  0000              add [bx+si],al
0000208C  0000              add [bx+si],al
0000208E  0000              add [bx+si],al
00002090  0000              add [bx+si],al
00002092  0000              add [bx+si],al
00002094  0000              add [bx+si],al
00002096  0000              add [bx+si],al
00002098  0000              add [bx+si],al
0000209A  0000              add [bx+si],al
0000209C  0000              add [bx+si],al
0000209E  0000              add [bx+si],al
000020A0  0000              add [bx+si],al
000020A2  0000              add [bx+si],al
000020A4  0000              add [bx+si],al
000020A6  0000              add [bx+si],al
000020A8  0000              add [bx+si],al
000020AA  0000              add [bx+si],al
000020AC  0000              add [bx+si],al
000020AE  0000              add [bx+si],al
000020B0  0000              add [bx+si],al
000020B2  0000              add [bx+si],al
000020B4  0000              add [bx+si],al
000020B6  0000              add [bx+si],al
000020B8  0000              add [bx+si],al
000020BA  0000              add [bx+si],al
000020BC  0000              add [bx+si],al
000020BE  0000              add [bx+si],al
000020C0  0000              add [bx+si],al
000020C2  0000              add [bx+si],al
000020C4  0000              add [bx+si],al
000020C6  0000              add [bx+si],al
000020C8  0000              add [bx+si],al
000020CA  0000              add [bx+si],al
000020CC  0000              add [bx+si],al
000020CE  0000              add [bx+si],al
000020D0  0000              add [bx+si],al
000020D2  0000              add [bx+si],al
000020D4  0000              add [bx+si],al
000020D6  0000              add [bx+si],al
000020D8  0000              add [bx+si],al
000020DA  0000              add [bx+si],al
000020DC  0000              add [bx+si],al
000020DE  0000              add [bx+si],al
000020E0  0000              add [bx+si],al
000020E2  0000              add [bx+si],al
000020E4  0000              add [bx+si],al
000020E6  0000              add [bx+si],al
000020E8  0000              add [bx+si],al
000020EA  0000              add [bx+si],al
000020EC  0000              add [bx+si],al
000020EE  0000              add [bx+si],al
000020F0  0000              add [bx+si],al
000020F2  0000              add [bx+si],al
000020F4  0000              add [bx+si],al
000020F6  0000              add [bx+si],al
000020F8  0000              add [bx+si],al
000020FA  0000              add [bx+si],al
000020FC  0000              add [bx+si],al
000020FE  0000              add [bx+si],al
00002100  0000              add [bx+si],al
00002102  0000              add [bx+si],al
00002104  0000              add [bx+si],al
00002106  0000              add [bx+si],al
00002108  0000              add [bx+si],al
0000210A  0000              add [bx+si],al
0000210C  0000              add [bx+si],al
0000210E  0000              add [bx+si],al
00002110  0000              add [bx+si],al
00002112  0000              add [bx+si],al
00002114  0000              add [bx+si],al
00002116  0000              add [bx+si],al
00002118  0000              add [bx+si],al
0000211A  0000              add [bx+si],al
0000211C  0000              add [bx+si],al
0000211E  0000              add [bx+si],al
00002120  0000              add [bx+si],al
00002122  0000              add [bx+si],al
00002124  0000              add [bx+si],al
00002126  0000              add [bx+si],al
00002128  0000              add [bx+si],al
0000212A  0000              add [bx+si],al
0000212C  0000              add [bx+si],al
0000212E  0000              add [bx+si],al
00002130  0000              add [bx+si],al
00002132  0000              add [bx+si],al
00002134  0000              add [bx+si],al
00002136  0000              add [bx+si],al
00002138  0000              add [bx+si],al
0000213A  0000              add [bx+si],al
0000213C  0000              add [bx+si],al
0000213E  0000              add [bx+si],al
00002140  0000              add [bx+si],al
00002142  0000              add [bx+si],al
00002144  0000              add [bx+si],al
00002146  0000              add [bx+si],al
00002148  0000              add [bx+si],al
0000214A  0000              add [bx+si],al
0000214C  0000              add [bx+si],al
0000214E  0000              add [bx+si],al
00002150  0000              add [bx+si],al
00002152  0000              add [bx+si],al
00002154  0000              add [bx+si],al
00002156  0000              add [bx+si],al
00002158  0000              add [bx+si],al
0000215A  0000              add [bx+si],al
0000215C  0000              add [bx+si],al
0000215E  0000              add [bx+si],al
00002160  0000              add [bx+si],al
00002162  0000              add [bx+si],al
00002164  0000              add [bx+si],al
00002166  0000              add [bx+si],al
00002168  0000              add [bx+si],al
0000216A  0000              add [bx+si],al
0000216C  0000              add [bx+si],al
0000216E  0000              add [bx+si],al
00002170  0000              add [bx+si],al
00002172  0000              add [bx+si],al
00002174  0000              add [bx+si],al
00002176  0000              add [bx+si],al
00002178  0000              add [bx+si],al
0000217A  0000              add [bx+si],al
0000217C  0000              add [bx+si],al
0000217E  0000              add [bx+si],al
00002180  0000              add [bx+si],al
00002182  0000              add [bx+si],al
00002184  0000              add [bx+si],al
00002186  0000              add [bx+si],al
00002188  0000              add [bx+si],al
0000218A  0000              add [bx+si],al
0000218C  0000              add [bx+si],al
0000218E  0000              add [bx+si],al
00002190  0000              add [bx+si],al
00002192  0000              add [bx+si],al
00002194  0000              add [bx+si],al
00002196  0000              add [bx+si],al
00002198  0000              add [bx+si],al
0000219A  0000              add [bx+si],al
0000219C  0000              add [bx+si],al
0000219E  0000              add [bx+si],al
000021A0  0000              add [bx+si],al
000021A2  0000              add [bx+si],al
000021A4  0000              add [bx+si],al
000021A6  0000              add [bx+si],al
000021A8  0000              add [bx+si],al
000021AA  0000              add [bx+si],al
000021AC  0000              add [bx+si],al
000021AE  0000              add [bx+si],al
000021B0  0000              add [bx+si],al
000021B2  0000              add [bx+si],al
000021B4  0000              add [bx+si],al
000021B6  0000              add [bx+si],al
000021B8  0000              add [bx+si],al
000021BA  0000              add [bx+si],al
000021BC  0000              add [bx+si],al
000021BE  0000              add [bx+si],al
000021C0  0000              add [bx+si],al
000021C2  0000              add [bx+si],al
000021C4  0000              add [bx+si],al
000021C6  0000              add [bx+si],al
000021C8  0000              add [bx+si],al
000021CA  0000              add [bx+si],al
000021CC  0000              add [bx+si],al
000021CE  0000              add [bx+si],al
000021D0  0000              add [bx+si],al
000021D2  0000              add [bx+si],al
000021D4  0000              add [bx+si],al
000021D6  0000              add [bx+si],al
000021D8  0000              add [bx+si],al
000021DA  0000              add [bx+si],al
000021DC  0000              add [bx+si],al
000021DE  0000              add [bx+si],al
000021E0  0000              add [bx+si],al
000021E2  0000              add [bx+si],al
000021E4  0000              add [bx+si],al
000021E6  0000              add [bx+si],al
000021E8  0000              add [bx+si],al
000021EA  0000              add [bx+si],al
000021EC  0000              add [bx+si],al
000021EE  0000              add [bx+si],al
000021F0  0000              add [bx+si],al
000021F2  0000              add [bx+si],al
000021F4  0000              add [bx+si],al
000021F6  0000              add [bx+si],al
000021F8  0000              add [bx+si],al
000021FA  0000              add [bx+si],al
000021FC  0000              add [bx+si],al
000021FE  0000              add [bx+si],al
00002200  0000              add [bx+si],al
00002202  0000              add [bx+si],al
00002204  0000              add [bx+si],al
00002206  0000              add [bx+si],al
00002208  0000              add [bx+si],al
0000220A  0000              add [bx+si],al
0000220C  0000              add [bx+si],al
0000220E  0000              add [bx+si],al
00002210  0000              add [bx+si],al
00002212  0000              add [bx+si],al
00002214  0000              add [bx+si],al
00002216  0000              add [bx+si],al
00002218  0000              add [bx+si],al
0000221A  0000              add [bx+si],al
0000221C  0000              add [bx+si],al
0000221E  0000              add [bx+si],al
00002220  0000              add [bx+si],al
00002222  0000              add [bx+si],al
00002224  0000              add [bx+si],al
00002226  0000              add [bx+si],al
00002228  0000              add [bx+si],al
0000222A  0000              add [bx+si],al
0000222C  0000              add [bx+si],al
0000222E  0000              add [bx+si],al
00002230  0000              add [bx+si],al
00002232  0000              add [bx+si],al
00002234  0000              add [bx+si],al
00002236  0000              add [bx+si],al
00002238  0000              add [bx+si],al
0000223A  0000              add [bx+si],al
0000223C  0000              add [bx+si],al
0000223E  0000              add [bx+si],al
00002240  0000              add [bx+si],al
00002242  0000              add [bx+si],al
00002244  0000              add [bx+si],al
00002246  0000              add [bx+si],al
00002248  0000              add [bx+si],al
0000224A  0000              add [bx+si],al
0000224C  0000              add [bx+si],al
0000224E  0000              add [bx+si],al
00002250  0000              add [bx+si],al
00002252  0000              add [bx+si],al
00002254  0000              add [bx+si],al
00002256  0000              add [bx+si],al
00002258  0000              add [bx+si],al
0000225A  0000              add [bx+si],al
0000225C  0000              add [bx+si],al
0000225E  0000              add [bx+si],al
00002260  0000              add [bx+si],al
00002262  0000              add [bx+si],al
00002264  0000              add [bx+si],al
00002266  0000              add [bx+si],al
00002268  0000              add [bx+si],al
0000226A  0000              add [bx+si],al
0000226C  0000              add [bx+si],al
0000226E  0000              add [bx+si],al
00002270  0000              add [bx+si],al
00002272  0000              add [bx+si],al
00002274  0000              add [bx+si],al
00002276  0000              add [bx+si],al
00002278  0000              add [bx+si],al
0000227A  0000              add [bx+si],al
0000227C  0000              add [bx+si],al
0000227E  0000              add [bx+si],al
00002280  0000              add [bx+si],al
00002282  0000              add [bx+si],al
00002284  0000              add [bx+si],al
00002286  0000              add [bx+si],al
00002288  0000              add [bx+si],al
0000228A  0000              add [bx+si],al
0000228C  0000              add [bx+si],al
0000228E  0000              add [bx+si],al
00002290  0000              add [bx+si],al
00002292  0000              add [bx+si],al
00002294  0000              add [bx+si],al
00002296  0000              add [bx+si],al
00002298  0000              add [bx+si],al
0000229A  0000              add [bx+si],al
0000229C  0000              add [bx+si],al
0000229E  0000              add [bx+si],al
000022A0  0000              add [bx+si],al
000022A2  0000              add [bx+si],al
000022A4  0000              add [bx+si],al
000022A6  0000              add [bx+si],al
000022A8  0000              add [bx+si],al
000022AA  0000              add [bx+si],al
000022AC  0000              add [bx+si],al
000022AE  0000              add [bx+si],al
000022B0  0000              add [bx+si],al
000022B2  0000              add [bx+si],al
000022B4  0000              add [bx+si],al
000022B6  0000              add [bx+si],al
000022B8  0000              add [bx+si],al
000022BA  0000              add [bx+si],al
000022BC  0000              add [bx+si],al
000022BE  0000              add [bx+si],al
000022C0  0000              add [bx+si],al
000022C2  0000              add [bx+si],al
000022C4  0000              add [bx+si],al
000022C6  0000              add [bx+si],al
000022C8  0000              add [bx+si],al
000022CA  0000              add [bx+si],al
000022CC  0000              add [bx+si],al
000022CE  0000              add [bx+si],al
000022D0  0000              add [bx+si],al
000022D2  0000              add [bx+si],al
000022D4  0000              add [bx+si],al
000022D6  0000              add [bx+si],al
000022D8  0000              add [bx+si],al
000022DA  0000              add [bx+si],al
000022DC  0000              add [bx+si],al
000022DE  0000              add [bx+si],al
000022E0  0000              add [bx+si],al
000022E2  0000              add [bx+si],al
000022E4  0000              add [bx+si],al
000022E6  0000              add [bx+si],al
000022E8  0000              add [bx+si],al
000022EA  0000              add [bx+si],al
000022EC  0000              add [bx+si],al
000022EE  0000              add [bx+si],al
000022F0  0000              add [bx+si],al
000022F2  0000              add [bx+si],al
000022F4  0000              add [bx+si],al
000022F6  0000              add [bx+si],al
000022F8  0000              add [bx+si],al
000022FA  0000              add [bx+si],al
000022FC  0000              add [bx+si],al
000022FE  0000              add [bx+si],al
00002300  0000              add [bx+si],al
00002302  0000              add [bx+si],al
00002304  0000              add [bx+si],al
00002306  0000              add [bx+si],al
00002308  0000              add [bx+si],al
0000230A  0000              add [bx+si],al
0000230C  0000              add [bx+si],al
0000230E  0000              add [bx+si],al
00002310  0000              add [bx+si],al
00002312  0000              add [bx+si],al
00002314  0000              add [bx+si],al
00002316  0000              add [bx+si],al
00002318  0000              add [bx+si],al
0000231A  0000              add [bx+si],al
0000231C  0000              add [bx+si],al
0000231E  07                pop es
0000231F  0000              add [bx+si],al
00002321  0000              add [bx+si],al
00002323  0000              add [bx+si],al
00002325  0000              add [bx+si],al
00002327  0000              add [bx+si],al
00002329  0000              add [bx+si],al
0000232B  0000              add [bx+si],al
0000232D  0000              add [bx+si],al
0000232F  0000              add [bx+si],al
00002331  0000              add [bx+si],al
00002333  0000              add [bx+si],al
00002335  0000              add [bx+si],al
00002337  0000              add [bx+si],al
00002339  0000              add [bx+si],al
0000233B  0000              add [bx+si],al
0000233D  0000              add [bx+si],al
0000233F  0031              add [bx+di],dh
00002341  3233              xor dh,[bp+di]
00002343  3435              xor al,0x35
00002345  3637              ss aaa
00002347  3839              cmp [bx+di],bh
00002349  302D              xor [di],ch
0000234B  3D0809            cmp ax,0x908
0000234E  7177              jno 0x23c7
00002350  657274            gs jc 0x23c7
00002353  7975              jns 0x23ca
00002355  696F705B5D        imul bp,[bx+0x70],word 0x5d5b
0000235A  0A00              or al,[bx+si]
0000235C  61                popa
0000235D  7364              jnc 0x23c3
0000235F  6667686A6B6C3B    push dword 0x3b6c6b6a
00002366  27                daa
00002367  60                pusha
00002368  005C7A            add [si+0x7a],bl
0000236B  7863              js 0x23d0
0000236D  7662              jna 0x23d1
0000236F  6E                outsb
00002370  6D                insw
00002371  2C2E              sub al,0x2e
00002373  2F                das
00002374  0000              add [bx+si],al
00002376  0000              add [bx+si],al
00002378  0000              add [bx+si],al
0000237A  0000              add [bx+si],al
0000237C  0000              add [bx+si],al
0000237E  0000              add [bx+si],al
00002380  0000              add [bx+si],al
00002382  0000              add [bx+si],al
00002384  0000              add [bx+si],al
00002386  0000              add [bx+si],al
00002388  0000              add [bx+si],al
0000238A  0000              add [bx+si],al
0000238C  0000              add [bx+si],al
0000238E  0000              add [bx+si],al
00002390  0000              add [bx+si],al
00002392  0000              add [bx+si],al
00002394  0000              add [bx+si],al
00002396  0000              add [bx+si],al
00002398  0000              add [bx+si],al
0000239A  0000              add [bx+si],al
0000239C  0000              add [bx+si],al
0000239E  0000              add [bx+si],al
000023A0  0000              add [bx+si],al
000023A2  0000              add [bx+si],al
000023A4  0000              add [bx+si],al
000023A6  0000              add [bx+si],al
000023A8  0000              add [bx+si],al
000023AA  0000              add [bx+si],al
000023AC  0000              add [bx+si],al
000023AE  0000              add [bx+si],al
000023B0  0000              add [bx+si],al
000023B2  0000              add [bx+si],al
000023B4  0000              add [bx+si],al
000023B6  0000              add [bx+si],al
000023B8  0000              add [bx+si],al
000023BA  0000              add [bx+si],al
000023BC  0000              add [bx+si],al
000023BE  0000              add [bx+si],al
000023C0  0000              add [bx+si],al
000023C2  0000              add [bx+si],al
000023C4  0000              add [bx+si],al
000023C6  0000              add [bx+si],al
000023C8  0000              add [bx+si],al
000023CA  0000              add [bx+si],al
000023CC  0000              add [bx+si],al
000023CE  0000              add [bx+si],al
000023D0  0000              add [bx+si],al
000023D2  0000              add [bx+si],al
000023D4  0000              add [bx+si],al
000023D6  0000              add [bx+si],al
000023D8  0000              add [bx+si],al
000023DA  0000              add [bx+si],al
000023DC  0000              add [bx+si],al
000023DE  0000              add [bx+si],al
000023E0  0000              add [bx+si],al
000023E2  0000              add [bx+si],al
000023E4  0000              add [bx+si],al
000023E6  0000              add [bx+si],al
000023E8  0000              add [bx+si],al
000023EA  0000              add [bx+si],al
000023EC  0000              add [bx+si],al
000023EE  0000              add [bx+si],al
000023F0  0000              add [bx+si],al
000023F2  0000              add [bx+si],al
000023F4  0000              add [bx+si],al
000023F6  0000              add [bx+si],al
000023F8  0000              add [bx+si],al
000023FA  0000              add [bx+si],al
000023FC  0000              add [bx+si],al
000023FE  0000              add [bx+si],al
00002400  0000              add [bx+si],al
00002402  0000              add [bx+si],al
00002404  0000              add [bx+si],al
00002406  0000              add [bx+si],al
00002408  0000              add [bx+si],al
0000240A  0000              add [bx+si],al
0000240C  0000              add [bx+si],al
0000240E  0000              add [bx+si],al
00002410  0000              add [bx+si],al
00002412  0000              add [bx+si],al
00002414  0000              add [bx+si],al
00002416  0000              add [bx+si],al
00002418  0000              add [bx+si],al
0000241A  0000              add [bx+si],al
0000241C  0000              add [bx+si],al
0000241E  0000              add [bx+si],al
00002420  0000              add [bx+si],al
00002422  0000              add [bx+si],al
00002424  0000              add [bx+si],al
00002426  0000              add [bx+si],al
00002428  0000              add [bx+si],al
0000242A  0000              add [bx+si],al
0000242C  0000              add [bx+si],al
0000242E  0000              add [bx+si],al
00002430  0000              add [bx+si],al
00002432  0000              add [bx+si],al
00002434  0000              add [bx+si],al
00002436  0000              add [bx+si],al
00002438  0000              add [bx+si],al
0000243A  0000              add [bx+si],al
0000243C  0000              add [bx+si],al
0000243E  0000              add [bx+si],al
00002440  214023            and [bx+si+0x23],ax
00002443  2425              and al,0x25
00002445  5E                pop si
00002446  262A28            sub ch,[es:bx+si]
00002449  295F2B            sub [bx+0x2b],bx
0000244C  0809              or [bx+di],cl
0000244E  51                push cx
0000244F  57                push di
00002450  45                inc bp
00002451  52                push dx
00002452  54                push sp
00002453  59                pop cx
00002454  55                push bp
00002455  49                dec cx
00002456  4F                dec di
00002457  50                push ax
00002458  7B7D              jpo 0x24d7
0000245A  0A00              or al,[bx+si]
0000245C  41                inc cx
0000245D  53                push bx
0000245E  44                inc sp
0000245F  46                inc si
00002460  47                inc di
00002461  48                dec ax
00002462  4A                dec dx
00002463  4B                dec bx
00002464  4C                dec sp
00002465  3A22              cmp ah,[bp+si]
00002467  7E00              jng 0x2469
00002469  7C5A              jl 0x24c5
0000246B  58                pop ax
0000246C  43                inc bx
0000246D  56                push si
0000246E  42                inc dx
0000246F  4E                dec si
00002470  4D                dec bp
00002471  3C3E              cmp al,0x3e
00002473  3F                aas
00002474  0000              add [bx+si],al
00002476  0000              add [bx+si],al
00002478  0000              add [bx+si],al
0000247A  0000              add [bx+si],al
0000247C  0000              add [bx+si],al
0000247E  0000              add [bx+si],al
00002480  0000              add [bx+si],al
00002482  0000              add [bx+si],al
00002484  0000              add [bx+si],al
00002486  0000              add [bx+si],al
00002488  0000              add [bx+si],al
0000248A  0000              add [bx+si],al
0000248C  0000              add [bx+si],al
0000248E  0000              add [bx+si],al
00002490  0000              add [bx+si],al
00002492  0000              add [bx+si],al
00002494  0000              add [bx+si],al
00002496  0000              add [bx+si],al
00002498  0000              add [bx+si],al
0000249A  0000              add [bx+si],al
0000249C  0000              add [bx+si],al
0000249E  0000              add [bx+si],al
000024A0  0000              add [bx+si],al
000024A2  0000              add [bx+si],al
000024A4  0000              add [bx+si],al
000024A6  0000              add [bx+si],al
000024A8  0000              add [bx+si],al
000024AA  0000              add [bx+si],al
000024AC  0000              add [bx+si],al
000024AE  0000              add [bx+si],al
000024B0  0000              add [bx+si],al
000024B2  0000              add [bx+si],al
000024B4  0000              add [bx+si],al
000024B6  0000              add [bx+si],al
000024B8  0000              add [bx+si],al
000024BA  0000              add [bx+si],al
000024BC  0000              add [bx+si],al
000024BE  0000              add [bx+si],al
000024C0  0000              add [bx+si],al
000024C2  0000              add [bx+si],al
000024C4  0000              add [bx+si],al
000024C6  0000              add [bx+si],al
000024C8  0000              add [bx+si],al
000024CA  0000              add [bx+si],al
000024CC  0000              add [bx+si],al
000024CE  0000              add [bx+si],al
000024D0  0000              add [bx+si],al
000024D2  0000              add [bx+si],al
000024D4  0000              add [bx+si],al
000024D6  0000              add [bx+si],al
000024D8  0000              add [bx+si],al
000024DA  0000              add [bx+si],al
000024DC  0000              add [bx+si],al
000024DE  0000              add [bx+si],al
000024E0  0000              add [bx+si],al
000024E2  0000              add [bx+si],al
000024E4  0000              add [bx+si],al
000024E6  0000              add [bx+si],al
000024E8  0000              add [bx+si],al
000024EA  0000              add [bx+si],al
000024EC  0000              add [bx+si],al
000024EE  0000              add [bx+si],al
000024F0  0000              add [bx+si],al
000024F2  0000              add [bx+si],al
000024F4  0000              add [bx+si],al
000024F6  0000              add [bx+si],al
000024F8  0000              add [bx+si],al
000024FA  0000              add [bx+si],al
000024FC  0000              add [bx+si],al
000024FE  0000              add [bx+si],al
00002500  0000              add [bx+si],al
00002502  0000              add [bx+si],al
00002504  0000              add [bx+si],al
00002506  0000              add [bx+si],al
00002508  0000              add [bx+si],al
0000250A  0000              add [bx+si],al
0000250C  0000              add [bx+si],al
0000250E  0000              add [bx+si],al
00002510  0000              add [bx+si],al
00002512  0000              add [bx+si],al
00002514  0000              add [bx+si],al
00002516  0000              add [bx+si],al
00002518  0000              add [bx+si],al
0000251A  0000              add [bx+si],al
0000251C  0000              add [bx+si],al
0000251E  0000              add [bx+si],al
00002520  0000              add [bx+si],al
00002522  0000              add [bx+si],al
00002524  0000              add [bx+si],al
00002526  0000              add [bx+si],al
00002528  0000              add [bx+si],al
0000252A  0000              add [bx+si],al
0000252C  0000              add [bx+si],al
0000252E  0000              add [bx+si],al
00002530  0000              add [bx+si],al
00002532  0000              add [bx+si],al
00002534  0000              add [bx+si],al
00002536  0000              add [bx+si],al
00002538  0000              add [bx+si],al
0000253A  0000              add [bx+si],al
0000253C  0000              add [bx+si],al
