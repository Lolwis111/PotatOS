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
00000068  E84000            call 0xab
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
000000AD  E84E6F            call 0x6ffe
000000B0  0000              add [bx+si],al
000000B2  EBFE              jmp short 0xb2
