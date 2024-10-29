
io.o:     file format elf32-i386


Disassembly of section .text:

00000000 <inportb>:
#include "stdint.h"

uint8_t inportb (uint16_t _port)
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 14             	sub    esp,0x14
   6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
   9:	66 89 45 ec          	mov    WORD PTR [ebp-0x14],ax
    uint8_t rv;
    asm volatile("inb %1, %0" : "=a" (rv) : "dN" (_port));
   d:	0f b7 45 ec          	movzx  eax,WORD PTR [ebp-0x14]
  11:	89 c2                	mov    edx,eax
  13:	ec                   	in     al,dx
  14:	88 45 ff             	mov    BYTE PTR [ebp-0x1],al
    return rv;
  17:	0f b6 45 ff          	movzx  eax,BYTE PTR [ebp-0x1]
}
  1b:	c9                   	leave
  1c:	c3                   	ret

0000001d <outportb>:

void outportb (uint16_t _port, uint8_t _data)
{
  1d:	55                   	push   ebp
  1e:	89 e5                	mov    ebp,esp
  20:	83 ec 08             	sub    esp,0x8
  23:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  26:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
  29:	66 89 45 fc          	mov    WORD PTR [ebp-0x4],ax
  2d:	89 d0                	mov    eax,edx
  2f:	88 45 f8             	mov    BYTE PTR [ebp-0x8],al
    asm volatile("outb %1, %0" : : "dN" (_port), "a" (_data));
  32:	0f b7 55 fc          	movzx  edx,WORD PTR [ebp-0x4]
  36:	0f b6 45 f8          	movzx  eax,BYTE PTR [ebp-0x8]
  3a:	ee                   	out    dx,al
  3b:	90                   	nop
  3c:	c9                   	leave
  3d:	c3                   	ret
