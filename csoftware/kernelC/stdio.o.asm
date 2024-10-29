
stdio.o:     file format elf32-i386


Disassembly of section .text:

00000000 <outb>:
   0:	55                   	push   bp
   1:	89 e5                	mov    bp,sp
   3:	0f b7 55 08          	movzx  dx,WORD PTR [di+0x8]
   7:	0f b6 45 0c          	movzx  ax,BYTE PTR [di+0xc]
   b:	ee                   	out    dx,al
   c:	5d                   	pop    bp
   d:	c3                   	ret
   e:	66 90                	xchg   eax,eax

00000010 <inb>:
  10:	55                   	push   bp
  11:	89 e5                	mov    bp,sp
  13:	8b 55 08             	mov    dx,WORD PTR [di+0x8]
  16:	ec                   	in     al,dx
  17:	5d                   	pop    bp
  18:	c3                   	ret
  19:	8d b4 26 00          	lea    si,[si+0x26]
  1d:	00 00                	add    BYTE PTR [bx+si],al
	...

00000020 <moveCursor>:
  20:	55                   	push   bp
  21:	b8 0f 00             	mov    ax,0xf
  24:	00 00                	add    BYTE PTR [bx+si],al
  26:	89 e5                	mov    bp,sp
  28:	56                   	push   si
  29:	be d4 03             	mov    si,0x3d4
  2c:	00 00                	add    BYTE PTR [bx+si],al
  2e:	53                   	push   bx
  2f:	8b 4d 0c             	mov    cx,WORD PTR [di+0xc]
  32:	89 f2                	mov    dx,si
  34:	8b 5d 08             	mov    bx,WORD PTR [di+0x8]
  37:	88 0d                	mov    BYTE PTR [di],cl
  39:	00 00                	add    BYTE PTR [bx+si],al
  3b:	00 00                	add    BYTE PTR [bx+si],al
  3d:	88 1d                	mov    BYTE PTR [di],bl
  3f:	01 00                	add    WORD PTR [bx+si],ax
  41:	00 00                	add    BYTE PTR [bx+si],al
  43:	ee                   	out    dx,al
  44:	8d 0c                	lea    cx,[si]
  46:	89 c1                	mov    cx,ax
  48:	e1 04                	loope  4e <moveCursor+0x2e>
  4a:	8d 04                	lea    ax,[si]
  4c:	19 bb d5 03          	sbb    WORD PTR [bp+di+0x3d5],di
  50:	00 00                	add    BYTE PTR [bx+si],al
  52:	89 da                	mov    dx,bx
  54:	ee                   	out    dx,al
  55:	b8 0e 00             	mov    ax,0xe
  58:	00 00                	add    BYTE PTR [bx+si],al
  5a:	89 f2                	mov    dx,si
  5c:	ee                   	out    dx,al
  5d:	89 c8                	mov    ax,cx
  5f:	89 da                	mov    dx,bx
  61:	ee                   	out    dx,al
  62:	5b                   	pop    bx
  63:	5e                   	pop    si
  64:	5d                   	pop    bp
  65:	c3                   	ret
  66:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
  6b:	00 00                	add    BYTE PTR [bx+si],al
  6d:	00 66 90             	add    BYTE PTR [bp-0x70],ah

00000070 <printChar>:
  70:	55                   	push   bp
  71:	0f be 15             	movsx  dx,BYTE PTR [di]
  74:	00 00                	add    BYTE PTR [bx+si],al
  76:	00 00                	add    BYTE PTR [bx+si],al
  78:	0f be 0d             	movsx  cx,BYTE PTR [di]
  7b:	01 00                	add    WORD PTR [bx+si],ax
  7d:	00 00                	add    BYTE PTR [bx+si],al
  7f:	89 d0                	mov    ax,dx
  81:	8d 14                	lea    dx,[si]
  83:	92                   	xchg   dx,ax
  84:	89 e5                	mov    bp,sp
  86:	c1 e2 04             	shl    dx,0x4
  89:	56                   	push   si
  8a:	01 ca                	add    dx,cx
  8c:	53                   	push   bx
  8d:	8b 75 0c             	mov    si,WORD PTR [di+0xc]
  90:	89 cb                	mov    bx,cx
  92:	8b 4d 08             	mov    cx,WORD PTR [di+0x8]
  95:	01 d2                	add    dx,dx
  97:	83 c3 01             	add    bx,0x1
  9a:	88 1d                	mov    BYTE PTR [di],bl
  9c:	01 00                	add    WORD PTR [bx+si],ax
  9e:	00 00                	add    BYTE PTR [bx+si],al
  a0:	88 8a 00 80          	mov    BYTE PTR [bp+si-0x8000],cl
  a4:	0b 00                	or     ax,WORD PTR [bx+si]
  a6:	89 f1                	mov    cx,si
  a8:	88 8a 01 80          	mov    BYTE PTR [bp+si-0x7fff],cl
  ac:	0b 00                	or     ax,WORD PTR [bx+si]
  ae:	80 fb 4f             	cmp    bl,0x4f
  b1:	75 11                	jne    c4 <printChar+0x54>
  b3:	83 c0 01             	add    ax,0x1
  b6:	c6 05 01             	mov    BYTE PTR [di],0x1
  b9:	00 00                	add    BYTE PTR [bx+si],al
  bb:	00 00                	add    BYTE PTR [bx+si],al
  bd:	31 db                	xor    bx,bx
  bf:	a2 00 00             	mov    ds:0x0,al
  c2:	00 00                	add    BYTE PTR [bx+si],al
  c4:	3c 19                	cmp    al,0x19
  c6:	74 2f                	je     f7 <printChar+0x87>
  c8:	8d 0c                	lea    cx,[si]
  ca:	80 c1 e1             	add    cl,0xe1
  cd:	04 be                	add    al,0xbe
  cf:	d4 03                	aam    0x3
  d1:	00 00                	add    BYTE PTR [bx+si],al
  d3:	b8 0f 00             	mov    ax,0xf
  d6:	00 00                	add    BYTE PTR [bx+si],al
  d8:	89 f2                	mov    dx,si
  da:	ee                   	out    dx,al
  db:	8d 04                	lea    ax,[si]
  dd:	0b bb d5 03          	or     di,WORD PTR [bp+di+0x3d5]
  e1:	00 00                	add    BYTE PTR [bx+si],al
  e3:	89 da                	mov    dx,bx
  e5:	ee                   	out    dx,al
  e6:	b8 0e 00             	mov    ax,0xe
  e9:	00 00                	add    BYTE PTR [bx+si],al
  eb:	89 f2                	mov    dx,si
  ed:	ee                   	out    dx,al
  ee:	89 c8                	mov    ax,cx
  f0:	89 da                	mov    dx,bx
  f2:	ee                   	out    dx,al
  f3:	5b                   	pop    bx
  f4:	5e                   	pop    si
  f5:	5d                   	pop    bp
  f6:	c3                   	ret
  f7:	ba a0 80             	mov    dx,0x80a0
  fa:	0b 00                	or     ax,WORD PTR [bx+si]
  fc:	8d 74 26             	lea    si,[si+0x26]
  ff:	00 0f                	add    BYTE PTR [bx],cl
 101:	b6 0a                	mov    dh,0xa
 103:	83 c2 01             	add    dx,0x1
 106:	88 8a 5f ff          	mov    BYTE PTR [bp+si-0xa1],cl
 10a:	ff                   	(bad)
 10b:	ff 81 fa 40          	inc    WORD PTR [bx+di+0x40fa]
 10f:	90                   	nop
 110:	0b 00                	or     ax,WORD PTR [bx+si]
 112:	75 ec                	jne    100 <printChar+0x90>
 114:	c6 05 00             	mov    BYTE PTR [di],0x0
 117:	00 00                	add    BYTE PTR [bx+si],al
 119:	00 18                	add    BYTE PTR [bx+si],bl
 11b:	b9 80 ff             	mov    cx,0xff80
 11e:	ff                   	(bad)
 11f:	ff                   	jmp    (bad)
 120:	eb ac                	jmp    ce <printChar+0x5e>
 122:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
 127:	00 00                	add    BYTE PTR [bx+si],al
 129:	00 8d b6 00          	add    BYTE PTR [di+0xb6],cl
 12d:	00 00                	add    BYTE PTR [bx+si],al
	...

00000130 <print>:
 130:	55                   	push   bp
 131:	89 e5                	mov    bp,sp
 133:	56                   	push   si
 134:	8b 75 08             	mov    si,WORD PTR [di+0x8]
 137:	53                   	push   bx
 138:	0f b6 5d 0c          	movzx  bx,BYTE PTR [di+0xc]
 13c:	0f be 06 84 c0       	movsx  ax,BYTE PTR ds:0xc084
 141:	74 24                	je     167 <print+0x37>
 143:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
 148:	00 00                	add    BYTE PTR [bx+si],al
 14a:	00 2e 8d 74          	add    BYTE PTR ds:0x748d,ch
 14e:	26 00 83 ec 08       	add    BYTE PTR es:[bp+di+0x8ec],al
 153:	83 c6 01             	add    si,0x1
 156:	53                   	push   bx
 157:	50                   	push   ax
 158:	e8 fc ff             	call   157 <print+0x27>
 15b:	ff                   	(bad)
 15c:	ff 0f                	dec    WORD PTR [bx]
 15e:	be 06 83             	mov    si,0x8306
 161:	c4 10                	les    dx,DWORD PTR [bx+si]
 163:	84 c0                	test   al,al
 165:	75 e9                	jne    150 <print+0x20>
 167:	8d 65 f8             	lea    sp,[di-0x8]
 16a:	5b                   	pop    bx
 16b:	5e                   	pop    si
 16c:	5d                   	pop    bp
 16d:	c3                   	ret
 16e:	66 90                	xchg   eax,eax

00000170 <clearScreen>:
 170:	b8 00 80             	mov    ax,0x8000
 173:	0b 00                	or     ax,WORD PTR [bx+si]
 175:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
 17a:	00 00                	add    BYTE PTR [bx+si],al
 17c:	00 8d 76 00          	add    BYTE PTR [di+0x76],cl
 180:	ba 20 07             	mov    dx,0x720
 183:	00 00                	add    BYTE PTR [bx+si],al
 185:	66 89 10             	mov    DWORD PTR [bx+si],edx
 188:	89 c2                	mov    dx,ax
 18a:	83 c0 02             	add    ax,0x2
 18d:	81 fa 9e 8f          	cmp    dx,0x8f9e
 191:	0b 00                	or     ax,WORD PTR [bx+si]
 193:	75 eb                	jne    180 <clearScreen+0x10>
 195:	c3                   	ret
 196:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
 19b:	00 00                	add    BYTE PTR [bx+si],al
 19d:	00 66 90             	add    BYTE PTR [bp-0x70],ah

000001a0 <moveBuffer>:
 1a0:	b8 a0 80             	mov    ax,0x80a0
 1a3:	0b 00                	or     ax,WORD PTR [bx+si]
 1a5:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
 1aa:	00 00                	add    BYTE PTR [bx+si],al
 1ac:	00 8d 76 00          	add    BYTE PTR [di+0x76],cl
 1b0:	0f b6 10             	movzx  dx,BYTE PTR [bx+si]
 1b3:	83 c0 01             	add    ax,0x1
 1b6:	88 90 5f ff          	mov    BYTE PTR [bx+si-0xa1],dl
 1ba:	ff                   	(bad)
 1bb:	ff                   	(bad)
 1bc:	3d 40 90             	cmp    ax,0x9040
 1bf:	0b 00                	or     ax,WORD PTR [bx+si]
 1c1:	75 ed                	jne    1b0 <moveBuffer+0x10>
 1c3:	c3                   	ret
