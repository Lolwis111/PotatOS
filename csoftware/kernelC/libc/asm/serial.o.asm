
serial.o:     file format elf32-i386


Disassembly of section .text:

00000000 <initSerial>:
#include "io.h"

#define PORT 0x3f8          // COM1
 
int initSerial() 
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 08             	sub    esp,0x8
    outportb(PORT + 1, 0x00);    // Disable all interrupts
   6:	83 ec 08             	sub    esp,0x8
   9:	6a 00                	push   0x0
   b:	68 f9 03 00 00       	push   0x3f9
  10:	e8 fc ff ff ff       	call   11 <initSerial+0x11>
  15:	83 c4 10             	add    esp,0x10
    outportb(PORT + 3, 0x80);    // Enable DLAB (set baud rate divisor)
  18:	83 ec 08             	sub    esp,0x8
  1b:	68 80 00 00 00       	push   0x80
  20:	68 fb 03 00 00       	push   0x3fb
  25:	e8 fc ff ff ff       	call   26 <initSerial+0x26>
  2a:	83 c4 10             	add    esp,0x10
    outportb(PORT + 0, 0x03);    // Set divisor to 3 (lo byte) 38400 baud
  2d:	83 ec 08             	sub    esp,0x8
  30:	6a 03                	push   0x3
  32:	68 f8 03 00 00       	push   0x3f8
  37:	e8 fc ff ff ff       	call   38 <initSerial+0x38>
  3c:	83 c4 10             	add    esp,0x10
    outportb(PORT + 1, 0x00);    //                  (hi byte)
  3f:	83 ec 08             	sub    esp,0x8
  42:	6a 00                	push   0x0
  44:	68 f9 03 00 00       	push   0x3f9
  49:	e8 fc ff ff ff       	call   4a <initSerial+0x4a>
  4e:	83 c4 10             	add    esp,0x10
    outportb(PORT + 3, 0x03);    // 8 bits, no parity, one stop bit
  51:	83 ec 08             	sub    esp,0x8
  54:	6a 03                	push   0x3
  56:	68 fb 03 00 00       	push   0x3fb
  5b:	e8 fc ff ff ff       	call   5c <initSerial+0x5c>
  60:	83 c4 10             	add    esp,0x10
    outportb(PORT + 2, 0xC7);    // Enable FIFO, clear them, with 14-byte threshold
  63:	83 ec 08             	sub    esp,0x8
  66:	68 c7 00 00 00       	push   0xc7
  6b:	68 fa 03 00 00       	push   0x3fa
  70:	e8 fc ff ff ff       	call   71 <initSerial+0x71>
  75:	83 c4 10             	add    esp,0x10
    outportb(PORT + 4, 0x0B);    // IRQs enabled, RTS/DSR set
  78:	83 ec 08             	sub    esp,0x8
  7b:	6a 0b                	push   0xb
  7d:	68 fc 03 00 00       	push   0x3fc
  82:	e8 fc ff ff ff       	call   83 <initSerial+0x83>
  87:	83 c4 10             	add    esp,0x10
    outportb(PORT + 4, 0x1E);    // Set in loopback mode, test the serial chip
  8a:	83 ec 08             	sub    esp,0x8
  8d:	6a 1e                	push   0x1e
  8f:	68 fc 03 00 00       	push   0x3fc
  94:	e8 fc ff ff ff       	call   95 <initSerial+0x95>
  99:	83 c4 10             	add    esp,0x10
    outportb(PORT + 0, 0xAE);    // Test serial chip (send byte 0xAE and check if serial returns same byte)
  9c:	83 ec 08             	sub    esp,0x8
  9f:	68 ae 00 00 00       	push   0xae
  a4:	68 f8 03 00 00       	push   0x3f8
  a9:	e8 fc ff ff ff       	call   aa <initSerial+0xaa>
  ae:	83 c4 10             	add    esp,0x10

    // Check if serial is faulty (i.e: not same byte as sent)
    if(inportb(PORT + 0) != 0xAE) {
  b1:	83 ec 0c             	sub    esp,0xc
  b4:	68 f8 03 00 00       	push   0x3f8
  b9:	e8 fc ff ff ff       	call   ba <initSerial+0xba>
  be:	83 c4 10             	add    esp,0x10
  c1:	3c ae                	cmp    al,0xae
  c3:	74 07                	je     cc <initSerial+0xcc>
        return 1;
  c5:	b8 01 00 00 00       	mov    eax,0x1
  ca:	eb 17                	jmp    e3 <initSerial+0xe3>
    }

    // If serial is not faulty set it in normal operation mode
    // (not-loopback with IRQs enabled and OUT#1 and OUT#2 bits enabled)
    outportb(PORT + 4, 0x0F);
  cc:	83 ec 08             	sub    esp,0x8
  cf:	6a 0f                	push   0xf
  d1:	68 fc 03 00 00       	push   0x3fc
  d6:	e8 fc ff ff ff       	call   d7 <initSerial+0xd7>
  db:	83 c4 10             	add    esp,0x10
    return 0;
  de:	b8 00 00 00 00       	mov    eax,0x0
}
  e3:	c9                   	leave
  e4:	c3                   	ret

000000e5 <is_transmit_empty>:

int is_transmit_empty()
{
  e5:	55                   	push   ebp
  e6:	89 e5                	mov    ebp,esp
  e8:	83 ec 08             	sub    esp,0x8
    return inportb(PORT + 5) & 0x20;
  eb:	83 ec 0c             	sub    esp,0xc
  ee:	68 fd 03 00 00       	push   0x3fd
  f3:	e8 fc ff ff ff       	call   f4 <is_transmit_empty+0xf>
  f8:	83 c4 10             	add    esp,0x10
  fb:	0f b6 c0             	movzx  eax,al
  fe:	83 e0 20             	and    eax,0x20
}
 101:	c9                   	leave
 102:	c3                   	ret

00000103 <writeSerial>:
 
void writeSerial(char a) 
{
 103:	55                   	push   ebp
 104:	89 e5                	mov    ebp,esp
 106:	83 ec 18             	sub    esp,0x18
 109:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 10c:	88 45 f4             	mov    BYTE PTR [ebp-0xc],al
    while (is_transmit_empty() == 0);
 10f:	90                   	nop
 110:	e8 fc ff ff ff       	call   111 <writeSerial+0xe>
 115:	85 c0                	test   eax,eax
 117:	74 f7                	je     110 <writeSerial+0xd>
 
    outportb(PORT,a);
 119:	0f b6 45 f4          	movzx  eax,BYTE PTR [ebp-0xc]
 11d:	0f b6 c0             	movzx  eax,al
 120:	83 ec 08             	sub    esp,0x8
 123:	50                   	push   eax
 124:	68 f8 03 00 00       	push   0x3f8
 129:	e8 fc ff ff ff       	call   12a <writeSerial+0x27>
 12e:	83 c4 10             	add    esp,0x10
 131:	90                   	nop
 132:	c9                   	leave
 133:	c3                   	ret
