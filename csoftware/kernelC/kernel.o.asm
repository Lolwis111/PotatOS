
kernel.o:     file format elf32-i386


Disassembly of section .text.startup:

00000000 <main>:
   0:	8d 4c 24             	lea    cx,[si+0x24]
   3:	04 83                	add    al,0x83
   5:	e4 f0                	in     al,0xf0
   7:	ff 71 fc             	push   WORD PTR [bx+di-0x4]
   a:	55                   	push   bp
   b:	89 e5                	mov    bp,sp
   d:	53                   	push   bx
   e:	bb 20 00             	mov    bx,0x20
  11:	00 00                	add    BYTE PTR [bx+si],al
  13:	51                   	push   cx
  14:	83 ec 08             	sub    sp,0x8
  17:	6a 00                	push   0x0
  19:	6a 00                	push   0x0
  1b:	e8 fc ff             	call   1a <main+0x1a>
  1e:	ff                   	(bad)
  1f:	ff 83 c4 10          	inc    WORD PTR [bp+di+0x10c4]
  23:	2e 8d b4 26 00       	lea    si,cs:[si+0x26]
  28:	00 00                	add    BYTE PTR [bx+si],al
  2a:	00 2e 8d 74          	add    BYTE PTR ds:0x748d,ch
  2e:	26 00 83 ec 08       	add    BYTE PTR es:[bp+di+0x8ec],al
  33:	0f b6 c3             	movzx  ax,bl
  36:	50                   	push   ax
  37:	0f be c3             	movsx  ax,bl
  3a:	83 c3 01             	add    bx,0x1
  3d:	50                   	push   ax
  3e:	e8 fc ff             	call   3d <main+0x3d>
  41:	ff                   	(bad)
  42:	ff 83 c4 10          	inc    WORD PTR [bp+di+0x10c4]
  46:	eb e8                	jmp    30 <main+0x30>
