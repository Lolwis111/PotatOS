
stdio.o:     file format elf32-i386


Disassembly of section .text:

00000000 <setColor>:

uint8_t screenX = 0, screenY = 0;
char global_color = 0x07;

void setColor(uint8_t c)
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 14             	sub    esp,0x14
   6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
   9:	88 45 ec             	mov    BYTE PTR [ebp-0x14],al
    uint8_t l = c & 0xF;
   c:	0f b6 45 ec          	movzx  eax,BYTE PTR [ebp-0x14]
  10:	83 e0 0f             	and    eax,0xf
  13:	88 45 ff             	mov    BYTE PTR [ebp-0x1],al
    uint8_t h = (c >> 4) & 0xF;
  16:	0f b6 45 ec          	movzx  eax,BYTE PTR [ebp-0x14]
  1a:	c0 e8 04             	shr    al,0x4
  1d:	88 45 fe             	mov    BYTE PTR [ebp-0x2],al

    if(l != h) global_color = c;
  20:	0f b6 45 ff          	movzx  eax,BYTE PTR [ebp-0x1]
  24:	3a 45 fe             	cmp    al,BYTE PTR [ebp-0x2]
  27:	74 09                	je     32 <setColor+0x32>
  29:	0f b6 45 ec          	movzx  eax,BYTE PTR [ebp-0x14]
  2d:	a2 00 00 00 00       	mov    ds:0x0,al
}
  32:	90                   	nop
  33:	c9                   	leave
  34:	c3                   	ret

00000035 <_asm_moveBuffer>:

void _asm_moveBuffer()
{
  35:	55                   	push   ebp
  36:	89 e5                	mov    ebp,esp
  38:	83 ec 10             	sub    esp,0x10
    char* dest = (char*)0x000B8000;
  3b:	c7 45 fc 00 80 0b 00 	mov    DWORD PTR [ebp-0x4],0xb8000
    char* src = dest + (screenX * 2);
  42:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  49:	0f b6 c0             	movzx  eax,al
  4c:	01 c0                	add    eax,eax
  4e:	89 c2                	mov    edx,eax
  50:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
  53:	01 d0                	add    eax,edx
  55:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax

    uint32_t size = (screenX * screenY * 2) - (screenX * 2);
  58:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  5f:	0f b6 d0             	movzx  edx,al
  62:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  69:	0f b6 c0             	movzx  eax,al
  6c:	0f af c2             	imul   eax,edx
  6f:	0f b6 15 00 00 00 00 	movzx  edx,BYTE PTR ds:0x0
  76:	0f b6 d2             	movzx  edx,dl
  79:	29 d0                	sub    eax,edx
  7b:	01 c0                	add    eax,eax
  7d:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax

    for(uint32_t i = 0; i < size; i++)
  80:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
  87:	eb 17                	jmp    a0 <_asm_moveBuffer+0x6b>
    {
        *dest = *src;
  89:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
  8c:	0f b6 10             	movzx  edx,BYTE PTR [eax]
  8f:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
  92:	88 10                	mov    BYTE PTR [eax],dl
        src++;
  94:	83 45 f8 01          	add    DWORD PTR [ebp-0x8],0x1
        dest++;
  98:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
    for(uint32_t i = 0; i < size; i++)
  9c:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1
  a0:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
  a3:	3b 45 f0             	cmp    eax,DWORD PTR [ebp-0x10]
  a6:	72 e1                	jb     89 <_asm_moveBuffer+0x54>
    }

    screenY = 23;
  a8:	c6 05 00 00 00 00 17 	mov    BYTE PTR ds:0x0,0x17
}
  af:	90                   	nop
  b0:	c9                   	leave
  b1:	c3                   	ret

000000b2 <_putchar>:

void _putchar(char c, uint8_t color)
{
  b2:	55                   	push   ebp
  b3:	89 e5                	mov    ebp,esp
  b5:	83 ec 18             	sub    esp,0x18
  b8:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
  bb:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  be:	88 55 ec             	mov    BYTE PTR [ebp-0x14],dl
  c1:	88 45 e8             	mov    BYTE PTR [ebp-0x18],al
    uint32_t offset = (screenY * 160) + (screenX * 2);
  c4:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  cb:	0f b6 d0             	movzx  edx,al
  ce:	89 d0                	mov    eax,edx
  d0:	c1 e0 02             	shl    eax,0x2
  d3:	01 d0                	add    eax,edx
  d5:	c1 e0 04             	shl    eax,0x4
  d8:	89 c2                	mov    edx,eax
  da:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
  e1:	0f b6 c0             	movzx  eax,al
  e4:	01 d0                	add    eax,edx
  e6:	01 c0                	add    eax,eax
  e8:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax
    uint32_t addr = 0x000B8000;
  eb:	c7 45 f8 00 80 0b 00 	mov    DWORD PTR [ebp-0x8],0xb8000

    switch(c)
  f2:	0f be 45 ec          	movsx  eax,BYTE PTR [ebp-0x14]
  f6:	83 f8 0a             	cmp    eax,0xa
  f9:	74 0e                	je     109 <_putchar+0x57>
  fb:	83 f8 0d             	cmp    eax,0xd
  fe:	75 1a                	jne    11a <_putchar+0x68>
    {
        case '\r':
        {
            screenX = 0;
 100:	c6 05 00 00 00 00 00 	mov    BYTE PTR ds:0x0,0x0
            break;
 107:	eb 41                	jmp    14a <_putchar+0x98>
        }
        case '\n':
        {
            screenY++;
 109:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 110:	83 c0 01             	add    eax,0x1
 113:	a2 00 00 00 00       	mov    ds:0x0,al
            break;
 118:	eb 30                	jmp    14a <_putchar+0x98>
        }
        default:
        {
            char* ptr = (char*)(addr+offset);
 11a:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
 11d:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 120:	01 d0                	add    eax,edx
 122:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
            *ptr = c;
 125:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 128:	0f b6 55 ec          	movzx  edx,BYTE PTR [ebp-0x14]
 12c:	88 10                	mov    BYTE PTR [eax],dl
            *(ptr+1) = color;
 12e:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 131:	8d 50 01             	lea    edx,[eax+0x1]
 134:	0f b6 45 e8          	movzx  eax,BYTE PTR [ebp-0x18]
 138:	88 02                	mov    BYTE PTR [edx],al

            screenX++;
 13a:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 141:	83 c0 01             	add    eax,0x1
 144:	a2 00 00 00 00       	mov    ds:0x0,al

            break;
 149:	90                   	nop
        }
    }

    if(screenX == 80)
 14a:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 151:	3c 50                	cmp    al,0x50
 153:	75 16                	jne    16b <_putchar+0xb9>
    {
        screenX = 0;
 155:	c6 05 00 00 00 00 00 	mov    BYTE PTR ds:0x0,0x0
        screenY++;
 15c:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 163:	83 c0 01             	add    eax,0x1
 166:	a2 00 00 00 00       	mov    ds:0x0,al
    }

    if(screenY >= 23)
 16b:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 172:	3c 16                	cmp    al,0x16
 174:	76 0c                	jbe    182 <_putchar+0xd0>
    {
        screenY = 23;
 176:	c6 05 00 00 00 00 17 	mov    BYTE PTR ds:0x0,0x17
        _asm_moveBuffer();
 17d:	e8 fc ff ff ff       	call   17e <_putchar+0xcc>
    }
}
 182:	90                   	nop
 183:	c9                   	leave
 184:	c3                   	ret

00000185 <putchar>:

void putchar(char c, uint8_t color)
{
 185:	55                   	push   ebp
 186:	89 e5                	mov    ebp,esp
 188:	83 ec 18             	sub    esp,0x18
 18b:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
 18e:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 191:	88 55 f4             	mov    BYTE PTR [ebp-0xc],dl
 194:	88 45 f0             	mov    BYTE PTR [ebp-0x10],al
    _putchar(c, color);
 197:	0f b6 55 f0          	movzx  edx,BYTE PTR [ebp-0x10]
 19b:	0f be 45 f4          	movsx  eax,BYTE PTR [ebp-0xc]
 19f:	52                   	push   edx
 1a0:	50                   	push   eax
 1a1:	e8 fc ff ff ff       	call   1a2 <putchar+0x1d>
 1a6:	83 c4 08             	add    esp,0x8

    setCursorPosition(screenX, screenY);
 1a9:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 1b0:	0f b6 d0             	movzx  edx,al
 1b3:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 1ba:	0f b6 c0             	movzx  eax,al
 1bd:	83 ec 08             	sub    esp,0x8
 1c0:	52                   	push   edx
 1c1:	50                   	push   eax
 1c2:	e8 fc ff ff ff       	call   1c3 <putchar+0x3e>
 1c7:	83 c4 10             	add    esp,0x10
}
 1ca:	90                   	nop
 1cb:	c9                   	leave
 1cc:	c3                   	ret

000001cd <printstring>:


static int printstring(const char* str)
{
 1cd:	55                   	push   ebp
 1ce:	89 e5                	mov    ebp,esp
 1d0:	83 ec 18             	sub    esp,0x18
    int i = 0;
 1d3:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
    while(*str)
 1da:	eb 25                	jmp    201 <printstring+0x34>
    {
        _putchar(*str, global_color);
 1dc:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 1e3:	0f b6 d0             	movzx  edx,al
 1e6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1e9:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 1ec:	0f be c0             	movsx  eax,al
 1ef:	52                   	push   edx
 1f0:	50                   	push   eax
 1f1:	e8 fc ff ff ff       	call   1f2 <printstring+0x25>
 1f6:	83 c4 08             	add    esp,0x8
        str++;
 1f9:	83 45 08 01          	add    DWORD PTR [ebp+0x8],0x1
        i++;
 1fd:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1
    while(*str)
 201:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 204:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 207:	84 c0                	test   al,al
 209:	75 d1                	jne    1dc <printstring+0xf>
    }
    setCursorPosition(screenX, screenY);
 20b:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 212:	0f b6 d0             	movzx  edx,al
 215:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 21c:	0f b6 c0             	movzx  eax,al
 21f:	83 ec 08             	sub    esp,0x8
 222:	52                   	push   edx
 223:	50                   	push   eax
 224:	e8 fc ff ff ff       	call   225 <printstring+0x58>
 229:	83 c4 10             	add    esp,0x10

    return i;
 22c:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
}
 22f:	c9                   	leave
 230:	c3                   	ret

00000231 <puts>:

int puts(const char* str)
{
 231:	55                   	push   ebp
 232:	89 e5                	mov    ebp,esp
 234:	83 ec 18             	sub    esp,0x18
    int i = printstring(str);
 237:	83 ec 0c             	sub    esp,0xc
 23a:	ff 75 08             	push   DWORD PTR [ebp+0x8]
 23d:	e8 8b ff ff ff       	call   1cd <printstring>
 242:	83 c4 10             	add    esp,0x10
 245:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax
    putchar('\r', global_color);
 248:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 24f:	0f b6 c0             	movzx  eax,al
 252:	83 ec 08             	sub    esp,0x8
 255:	50                   	push   eax
 256:	6a 0d                	push   0xd
 258:	e8 fc ff ff ff       	call   259 <puts+0x28>
 25d:	83 c4 10             	add    esp,0x10
    putchar('\n', global_color);
 260:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 267:	0f b6 c0             	movzx  eax,al
 26a:	83 ec 08             	sub    esp,0x8
 26d:	50                   	push   eax
 26e:	6a 0a                	push   0xa
 270:	e8 fc ff ff ff       	call   271 <puts+0x40>
 275:	83 c4 10             	add    esp,0x10
    return i+2;
 278:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 27b:	83 c0 02             	add    eax,0x2
}
 27e:	c9                   	leave
 27f:	c3                   	ret

00000280 <itoa>:


static void itoa(int num, char* buf, int base)
{
 280:	55                   	push   ebp
 281:	89 e5                	mov    ebp,esp
 283:	83 ec 20             	sub    esp,0x20
    int neg = 0;
 286:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
    int i = 0;
 28d:	c7 45 f8 00 00 00 00 	mov    DWORD PTR [ebp-0x8],0x0

    if (num == 0)
 294:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
 298:	75 14                	jne    2ae <itoa+0x2e>
    {
        buf[0] = '0';
 29a:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 29d:	c6 00 30             	mov    BYTE PTR [eax],0x30
        buf[1] = 0;
 2a0:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 2a3:	83 c0 01             	add    eax,0x1
 2a6:	c6 00 00             	mov    BYTE PTR [eax],0x0
        return;
 2a9:	e9 cf 00 00 00       	jmp    37d <itoa+0xfd>
    }

    if(num < 0 && base == 10)
 2ae:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
 2b2:	79 50                	jns    304 <itoa+0x84>
 2b4:	83 7d 10 0a          	cmp    DWORD PTR [ebp+0x10],0xa
 2b8:	75 4a                	jne    304 <itoa+0x84>
    {
        num = -num;
 2ba:	f7 5d 08             	neg    DWORD PTR [ebp+0x8]
        neg = 1;
 2bd:	c7 45 fc 01 00 00 00 	mov    DWORD PTR [ebp-0x4],0x1
    }

    while(num != 0)
 2c4:	eb 3e                	jmp    304 <itoa+0x84>
    {
        int r = num % base;
 2c6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2c9:	99                   	cdq
 2ca:	f7 7d 10             	idiv   DWORD PTR [ebp+0x10]
 2cd:	89 55 e8             	mov    DWORD PTR [ebp-0x18],edx
        buf[i++] = (r > 9) ? (r - 10) + 'a' : r + '0';
 2d0:	83 7d e8 09          	cmp    DWORD PTR [ebp-0x18],0x9
 2d4:	7e 0a                	jle    2e0 <itoa+0x60>
 2d6:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 2d9:	83 c0 57             	add    eax,0x57
 2dc:	89 c1                	mov    ecx,eax
 2de:	eb 08                	jmp    2e8 <itoa+0x68>
 2e0:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 2e3:	83 c0 30             	add    eax,0x30
 2e6:	89 c1                	mov    ecx,eax
 2e8:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
 2eb:	8d 50 01             	lea    edx,[eax+0x1]
 2ee:	89 55 f8             	mov    DWORD PTR [ebp-0x8],edx
 2f1:	89 c2                	mov    edx,eax
 2f3:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 2f6:	01 d0                	add    eax,edx
 2f8:	88 08                	mov    BYTE PTR [eax],cl
        num = num / base;
 2fa:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2fd:	99                   	cdq
 2fe:	f7 7d 10             	idiv   DWORD PTR [ebp+0x10]
 301:	89 45 08             	mov    DWORD PTR [ebp+0x8],eax
    while(num != 0)
 304:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
 308:	75 bc                	jne    2c6 <itoa+0x46>
    }

    if(neg > 0)
 30a:	83 7d fc 00          	cmp    DWORD PTR [ebp-0x4],0x0
 30e:	7e 0f                	jle    31f <itoa+0x9f>
    {
        buf[i] = '-';
 310:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
 313:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 316:	01 d0                	add    eax,edx
 318:	c6 00 2d             	mov    BYTE PTR [eax],0x2d
        i++;
 31b:	83 45 f8 01          	add    DWORD PTR [ebp-0x8],0x1
    }

    int start = 0;
 31f:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
    int end = i - 1;
 326:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
 329:	83 e8 01             	sub    eax,0x1
 32c:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax
    while(start < end)
 32f:	eb 39                	jmp    36a <itoa+0xea>
    {
        char t = buf[start];
 331:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 334:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 337:	01 d0                	add    eax,edx
 339:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 33c:	88 45 ef             	mov    BYTE PTR [ebp-0x11],al
        buf[start] = buf[end];
 33f:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]
 342:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 345:	01 d0                	add    eax,edx
 347:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
 34a:	8b 55 0c             	mov    edx,DWORD PTR [ebp+0xc]
 34d:	01 ca                	add    edx,ecx
 34f:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 352:	88 02                	mov    BYTE PTR [edx],al
        buf[end] = t;
 354:	8b 55 f0             	mov    edx,DWORD PTR [ebp-0x10]
 357:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 35a:	01 c2                	add    edx,eax
 35c:	0f b6 45 ef          	movzx  eax,BYTE PTR [ebp-0x11]
 360:	88 02                	mov    BYTE PTR [edx],al
        end--;
 362:	83 6d f0 01          	sub    DWORD PTR [ebp-0x10],0x1
        start++;
 366:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1
    while(start < end)
 36a:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 36d:	3b 45 f0             	cmp    eax,DWORD PTR [ebp-0x10]
 370:	7c bf                	jl     331 <itoa+0xb1>
    }

    buf[i] = 0;
 372:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
 375:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 378:	01 d0                	add    eax,edx
 37a:	c6 00 00             	mov    BYTE PTR [eax],0x0
}
 37d:	c9                   	leave
 37e:	c3                   	ret

0000037f <vsprintf>:

int vsprintf(char* dest, const char* format, __builtin_va_list val)
{
 37f:	55                   	push   ebp
 380:	89 e5                	mov    ebp,esp
 382:	83 ec 48             	sub    esp,0x48
    size_t len = 0;
 385:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
    char buffer[20];

    char* ptr = dest;
 38c:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 38f:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax

    while(*format)
 392:	e9 87 02 00 00       	jmp    61e <vsprintf+0x29f>
    {
        if(*format == '%')
 397:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 39a:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 39d:	3c 25                	cmp    al,0x25
 39f:	0f 85 3a 02 00 00    	jne    5df <vsprintf+0x260>
        {
            format++;
 3a5:	83 45 0c 01          	add    DWORD PTR [ebp+0xc],0x1

            int align = 0;
 3a9:	c7 45 ec 00 00 00 00 	mov    DWORD PTR [ebp-0x14],0x0
            while(*format >= '0' && *format <= '9')
 3b0:	eb 1e                	jmp    3d0 <vsprintf+0x51>
            {
                align *= 10;
 3b2:	8b 55 ec             	mov    edx,DWORD PTR [ebp-0x14]
 3b5:	89 d0                	mov    eax,edx
 3b7:	c1 e0 02             	shl    eax,0x2
 3ba:	01 d0                	add    eax,edx
 3bc:	01 c0                	add    eax,eax
 3be:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax
                align += (*format) - '0';
 3c1:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 3c4:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 3c7:	0f be c0             	movsx  eax,al
 3ca:	83 e8 30             	sub    eax,0x30
 3cd:	01 45 ec             	add    DWORD PTR [ebp-0x14],eax
            while(*format >= '0' && *format <= '9')
 3d0:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 3d3:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 3d6:	3c 2f                	cmp    al,0x2f
 3d8:	7e 0a                	jle    3e4 <vsprintf+0x65>
 3da:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 3dd:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 3e0:	3c 39                	cmp    al,0x39
 3e2:	7e ce                	jle    3b2 <vsprintf+0x33>
            }

            switch (*format)
 3e4:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 3e7:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 3ea:	0f be c0             	movsx  eax,al
 3ed:	83 f8 25             	cmp    eax,0x25
 3f0:	0f 84 ab 01 00 00    	je     5a1 <vsprintf+0x222>
 3f6:	83 f8 25             	cmp    eax,0x25
 3f9:	0f 8c 1b 02 00 00    	jl     61a <vsprintf+0x29b>
 3ff:	83 f8 78             	cmp    eax,0x78
 402:	0f 8f 12 02 00 00    	jg     61a <vsprintf+0x29b>
 408:	83 f8 63             	cmp    eax,0x63
 40b:	0f 8c 09 02 00 00    	jl     61a <vsprintf+0x29b>
 411:	83 e8 63             	sub    eax,0x63
 414:	83 f8 15             	cmp    eax,0x15
 417:	0f 87 fd 01 00 00    	ja     61a <vsprintf+0x29b>
 41d:	8b 04 85 00 00 00 00 	mov    eax,DWORD PTR [eax*4+0x0]
 424:	ff e0                	jmp    eax
            {
                case 'd':
                case 'i':
                {
                    int i = __builtin_va_arg(val, int);
 426:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
 429:	8d 50 04             	lea    edx,[eax+0x4]
 42c:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
 42f:	8b 00                	mov    eax,DWORD PTR [eax]
 431:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax

                    itoa(i, buffer, 10);
 434:	6a 0a                	push   0xa
 436:	8d 45 c7             	lea    eax,[ebp-0x39]
 439:	50                   	push   eax
 43a:	ff 75 dc             	push   DWORD PTR [ebp-0x24]
 43d:	e8 3e fe ff ff       	call   280 <itoa>
 442:	83 c4 0c             	add    esp,0xc

                    len += strlen(buffer);
 445:	83 ec 0c             	sub    esp,0xc
 448:	8d 45 c7             	lea    eax,[ebp-0x39]
 44b:	50                   	push   eax
 44c:	e8 fc ff ff ff       	call   44d <vsprintf+0xce>
 451:	83 c4 10             	add    esp,0x10
 454:	01 45 f4             	add    DWORD PTR [ebp-0xc],eax

                    if(ptr != NULL) strcat(ptr, buffer);
 457:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 45b:	0f 84 a9 01 00 00    	je     60a <vsprintf+0x28b>
 461:	83 ec 08             	sub    esp,0x8
 464:	8d 45 c7             	lea    eax,[ebp-0x39]
 467:	50                   	push   eax
 468:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 46b:	e8 fc ff ff ff       	call   46c <vsprintf+0xed>
 470:	83 c4 10             	add    esp,0x10
                    break;
 473:	e9 92 01 00 00       	jmp    60a <vsprintf+0x28b>
                }
                case 'o':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);
 478:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
 47b:	8d 50 04             	lea    edx,[eax+0x4]
 47e:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
 481:	8b 00                	mov    eax,DWORD PTR [eax]
 483:	89 45 e0             	mov    DWORD PTR [ebp-0x20],eax

                    itoa(i, buffer, 8);
 486:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
 489:	83 ec 04             	sub    esp,0x4
 48c:	6a 08                	push   0x8
 48e:	8d 55 c7             	lea    edx,[ebp-0x39]
 491:	52                   	push   edx
 492:	50                   	push   eax
 493:	e8 e8 fd ff ff       	call   280 <itoa>
 498:	83 c4 10             	add    esp,0x10

                    len += strlen(buffer);
 49b:	83 ec 0c             	sub    esp,0xc
 49e:	8d 45 c7             	lea    eax,[ebp-0x39]
 4a1:	50                   	push   eax
 4a2:	e8 fc ff ff ff       	call   4a3 <vsprintf+0x124>
 4a7:	83 c4 10             	add    esp,0x10
 4aa:	01 45 f4             	add    DWORD PTR [ebp-0xc],eax

                    if(ptr != NULL) strcat(ptr, buffer);
 4ad:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 4b1:	0f 84 56 01 00 00    	je     60d <vsprintf+0x28e>
 4b7:	83 ec 08             	sub    esp,0x8
 4ba:	8d 45 c7             	lea    eax,[ebp-0x39]
 4bd:	50                   	push   eax
 4be:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 4c1:	e8 fc ff ff ff       	call   4c2 <vsprintf+0x143>
 4c6:	83 c4 10             	add    esp,0x10
                    break;
 4c9:	e9 3f 01 00 00       	jmp    60d <vsprintf+0x28e>
                }
                case 'x':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);
 4ce:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
 4d1:	8d 50 04             	lea    edx,[eax+0x4]
 4d4:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
 4d7:	8b 00                	mov    eax,DWORD PTR [eax]
 4d9:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax

                    itoa(i, buffer, 16);
 4dc:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 4df:	83 ec 04             	sub    esp,0x4
 4e2:	6a 10                	push   0x10
 4e4:	8d 55 c7             	lea    edx,[ebp-0x39]
 4e7:	52                   	push   edx
 4e8:	50                   	push   eax
 4e9:	e8 92 fd ff ff       	call   280 <itoa>
 4ee:	83 c4 10             	add    esp,0x10

                    len += strlen(buffer);
 4f1:	83 ec 0c             	sub    esp,0xc
 4f4:	8d 45 c7             	lea    eax,[ebp-0x39]
 4f7:	50                   	push   eax
 4f8:	e8 fc ff ff ff       	call   4f9 <vsprintf+0x17a>
 4fd:	83 c4 10             	add    esp,0x10
 500:	01 45 f4             	add    DWORD PTR [ebp-0xc],eax

                    if(ptr != NULL) strcat(ptr, buffer);
 503:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 507:	0f 84 03 01 00 00    	je     610 <vsprintf+0x291>
 50d:	83 ec 08             	sub    esp,0x8
 510:	8d 45 c7             	lea    eax,[ebp-0x39]
 513:	50                   	push   eax
 514:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 517:	e8 fc ff ff ff       	call   518 <vsprintf+0x199>
 51c:	83 c4 10             	add    esp,0x10
                    break;
 51f:	e9 ec 00 00 00       	jmp    610 <vsprintf+0x291>
                }
                case 's':
                {
                    char* str = __builtin_va_arg(val, char*);
 524:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
 527:	8d 50 04             	lea    edx,[eax+0x4]
 52a:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
 52d:	8b 00                	mov    eax,DWORD PTR [eax]
 52f:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax

                    len += strlen(str);
 532:	83 ec 0c             	sub    esp,0xc
 535:	ff 75 e4             	push   DWORD PTR [ebp-0x1c]
 538:	e8 fc ff ff ff       	call   539 <vsprintf+0x1ba>
 53d:	83 c4 10             	add    esp,0x10
 540:	01 45 f4             	add    DWORD PTR [ebp-0xc],eax

                    if(ptr != NULL) strcat(ptr, str);
 543:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 547:	0f 84 c6 00 00 00    	je     613 <vsprintf+0x294>
 54d:	83 ec 08             	sub    esp,0x8
 550:	ff 75 e4             	push   DWORD PTR [ebp-0x1c]
 553:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 556:	e8 fc ff ff ff       	call   557 <vsprintf+0x1d8>
 55b:	83 c4 10             	add    esp,0x10
                    break;
 55e:	e9 b0 00 00 00       	jmp    613 <vsprintf+0x294>
                }
                case 'c':
                {
                    char c = (char)__builtin_va_arg(val, int);
 563:	8b 45 10             	mov    eax,DWORD PTR [ebp+0x10]
 566:	8d 50 04             	lea    edx,[eax+0x4]
 569:	89 55 10             	mov    DWORD PTR [ebp+0x10],edx
 56c:	8b 00                	mov    eax,DWORD PTR [eax]
 56e:	88 45 db             	mov    BYTE PTR [ebp-0x25],al
                    // putchar(c, global_color);

                    buffer[0] = c;
 571:	0f b6 45 db          	movzx  eax,BYTE PTR [ebp-0x25]
 575:	88 45 c7             	mov    BYTE PTR [ebp-0x39],al
                    buffer[1] = '\0';
 578:	c6 45 c8 00          	mov    BYTE PTR [ebp-0x38],0x0

                    len++;
 57c:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1

                    if(ptr != NULL) ptr = strcat(ptr, buffer);
 580:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 584:	0f 84 8c 00 00 00    	je     616 <vsprintf+0x297>
 58a:	83 ec 08             	sub    esp,0x8
 58d:	8d 45 c7             	lea    eax,[ebp-0x39]
 590:	50                   	push   eax
 591:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 594:	e8 fc ff ff ff       	call   595 <vsprintf+0x216>
 599:	83 c4 10             	add    esp,0x10
 59c:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax

                    break;
 59f:	eb 75                	jmp    616 <vsprintf+0x297>
                }
                case '%':
                {
                    putchar('%', global_color);
 5a1:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 5a8:	0f b6 c0             	movzx  eax,al
 5ab:	83 ec 08             	sub    esp,0x8
 5ae:	50                   	push   eax
 5af:	6a 25                	push   0x25
 5b1:	e8 fc ff ff ff       	call   5b2 <vsprintf+0x233>
 5b6:	83 c4 10             	add    esp,0x10
                    buffer[0] = '%';
 5b9:	c6 45 c7 25          	mov    BYTE PTR [ebp-0x39],0x25
                    buffer[1] = '\0';
 5bd:	c6 45 c8 00          	mov    BYTE PTR [ebp-0x38],0x0

                    len++;
 5c1:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1

                    if(ptr != NULL) strcat(ptr, buffer);
 5c5:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 5c9:	74 4e                	je     619 <vsprintf+0x29a>
 5cb:	83 ec 08             	sub    esp,0x8
 5ce:	8d 45 c7             	lea    eax,[ebp-0x39]
 5d1:	50                   	push   eax
 5d2:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 5d5:	e8 fc ff ff ff       	call   5d6 <vsprintf+0x257>
 5da:	83 c4 10             	add    esp,0x10

                    break;
 5dd:	eb 3a                	jmp    619 <vsprintf+0x29a>
                
            }
        }
        else
        {
            buffer[0] = *format;
 5df:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 5e2:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 5e5:	88 45 c7             	mov    BYTE PTR [ebp-0x39],al
            buffer[1] = '\0';
 5e8:	c6 45 c8 00          	mov    BYTE PTR [ebp-0x38],0x0

            len++;
 5ec:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1

            if(ptr != NULL) strcat(ptr, buffer);
 5f0:	83 7d f0 00          	cmp    DWORD PTR [ebp-0x10],0x0
 5f4:	74 24                	je     61a <vsprintf+0x29b>
 5f6:	83 ec 08             	sub    esp,0x8
 5f9:	8d 45 c7             	lea    eax,[ebp-0x39]
 5fc:	50                   	push   eax
 5fd:	ff 75 f0             	push   DWORD PTR [ebp-0x10]
 600:	e8 fc ff ff ff       	call   601 <vsprintf+0x282>
 605:	83 c4 10             	add    esp,0x10
 608:	eb 10                	jmp    61a <vsprintf+0x29b>
                    break;
 60a:	90                   	nop
 60b:	eb 0d                	jmp    61a <vsprintf+0x29b>
                    break;
 60d:	90                   	nop
 60e:	eb 0a                	jmp    61a <vsprintf+0x29b>
                    break;
 610:	90                   	nop
 611:	eb 07                	jmp    61a <vsprintf+0x29b>
                    break;
 613:	90                   	nop
 614:	eb 04                	jmp    61a <vsprintf+0x29b>
                    break;
 616:	90                   	nop
 617:	eb 01                	jmp    61a <vsprintf+0x29b>
                    break;
 619:	90                   	nop
        }

        format++;
 61a:	83 45 0c 01          	add    DWORD PTR [ebp+0xc],0x1
    while(*format)
 61e:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 621:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 624:	84 c0                	test   al,al
 626:	0f 85 6b fd ff ff    	jne    397 <vsprintf+0x18>
    }

    return len;
 62c:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
}
 62f:	c9                   	leave
 630:	c3                   	ret

00000631 <sprintf>:

int sprintf(char* dest, const char* format, ...)
{
 631:	55                   	push   ebp
 632:	89 e5                	mov    ebp,esp
 634:	83 ec 18             	sub    esp,0x18
    __builtin_va_list val;

    __builtin_va_start(val, format);
 637:	8d 45 10             	lea    eax,[ebp+0x10]
 63a:	89 45 f0             	mov    DWORD PTR [ebp-0x10],eax

   int l = vsprintf(dest, format, val);
 63d:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
 640:	83 ec 04             	sub    esp,0x4
 643:	50                   	push   eax
 644:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
 647:	ff 75 08             	push   DWORD PTR [ebp+0x8]
 64a:	e8 fc ff ff ff       	call   64b <sprintf+0x1a>
 64f:	83 c4 10             	add    esp,0x10
 652:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

    __builtin_va_end(val);

    return l;
 655:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
}
 658:	c9                   	leave
 659:	c3                   	ret

0000065a <printf>:

int printf(const char* format, ...)
{
 65a:	55                   	push   ebp
 65b:	89 e5                	mov    ebp,esp
 65d:	53                   	push   ebx
 65e:	83 ec 14             	sub    esp,0x14
 661:	89 e0                	mov    eax,esp
 663:	89 c3                	mov    ebx,eax
    __builtin_va_list val;

    __builtin_va_start(val, format);
 665:	8d 45 0c             	lea    eax,[ebp+0xc]
 668:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax

    int l = vsprintf(NULL, format, val);
 66b:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 66e:	83 ec 04             	sub    esp,0x4
 671:	50                   	push   eax
 672:	ff 75 08             	push   DWORD PTR [ebp+0x8]
 675:	6a 00                	push   0x0
 677:	e8 fc ff ff ff       	call   678 <printf+0x1e>
 67c:	83 c4 10             	add    esp,0x10
 67f:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

    char buffer[l + 1];
 682:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 685:	83 c0 01             	add    eax,0x1
 688:	8d 50 ff             	lea    edx,[eax-0x1]
 68b:	89 55 f0             	mov    DWORD PTR [ebp-0x10],edx
 68e:	89 c2                	mov    edx,eax
 690:	b8 10 00 00 00       	mov    eax,0x10
 695:	83 e8 01             	sub    eax,0x1
 698:	01 d0                	add    eax,edx
 69a:	b9 10 00 00 00       	mov    ecx,0x10
 69f:	ba 00 00 00 00       	mov    edx,0x0
 6a4:	f7 f1                	div    ecx
 6a6:	6b c0 10             	imul   eax,eax,0x10
 6a9:	29 c4                	sub    esp,eax
 6ab:	89 e0                	mov    eax,esp
 6ad:	83 c0 00             	add    eax,0x0
 6b0:	89 45 ec             	mov    DWORD PTR [ebp-0x14],eax

    l = vsprintf(buffer, format, val);
 6b3:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 6b6:	83 ec 04             	sub    esp,0x4
 6b9:	50                   	push   eax
 6ba:	ff 75 08             	push   DWORD PTR [ebp+0x8]
 6bd:	ff 75 ec             	push   DWORD PTR [ebp-0x14]
 6c0:	e8 fc ff ff ff       	call   6c1 <printf+0x67>
 6c5:	83 c4 10             	add    esp,0x10
 6c8:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

    printstring(buffer);
 6cb:	83 ec 0c             	sub    esp,0xc
 6ce:	ff 75 ec             	push   DWORD PTR [ebp-0x14]
 6d1:	e8 f7 fa ff ff       	call   1cd <printstring>
 6d6:	83 c4 10             	add    esp,0x10

    __builtin_va_end(val);

    return l;
 6d9:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 6dc:	89 dc                	mov    esp,ebx
}
 6de:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
 6e1:	c9                   	leave
 6e2:	c3                   	ret

000006e3 <readkey>:

uint8_t readkey()
{
 6e3:	55                   	push   ebp
 6e4:	89 e5                	mov    ebp,esp
 6e6:	83 ec 08             	sub    esp,0x8
    while ((inportb(STATUS_PORT) & 0x01) == 0) writeSerial('!');
 6e9:	eb 0d                	jmp    6f8 <readkey+0x15>
 6eb:	83 ec 0c             	sub    esp,0xc
 6ee:	6a 21                	push   0x21
 6f0:	e8 fc ff ff ff       	call   6f1 <readkey+0xe>
 6f5:	83 c4 10             	add    esp,0x10
 6f8:	83 ec 0c             	sub    esp,0xc
 6fb:	6a 64                	push   0x64
 6fd:	e8 fc ff ff ff       	call   6fe <readkey+0x1b>
 702:	83 c4 10             	add    esp,0x10
 705:	0f b6 c0             	movzx  eax,al
 708:	83 e0 01             	and    eax,0x1
 70b:	85 c0                	test   eax,eax
 70d:	74 dc                	je     6eb <readkey+0x8>

    return inportb(DATA_PORT);
 70f:	83 ec 0c             	sub    esp,0xc
 712:	6a 60                	push   0x60
 714:	e8 fc ff ff ff       	call   715 <readkey+0x32>
 719:	83 c4 10             	add    esp,0x10
}
 71c:	c9                   	leave
 71d:	c3                   	ret

0000071e <sendPS2Command>:

static void sendPS2Command(uint8_t command)
{
 71e:	55                   	push   ebp
 71f:	89 e5                	mov    ebp,esp
 721:	83 ec 18             	sub    esp,0x18
 724:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 727:	88 45 f4             	mov    BYTE PTR [ebp-0xc],al
    while ((inportb(STATUS_PORT) & 0x02) > 0);
 72a:	90                   	nop
 72b:	83 ec 0c             	sub    esp,0xc
 72e:	6a 64                	push   0x64
 730:	e8 fc ff ff ff       	call   731 <sendPS2Command+0x13>
 735:	83 c4 10             	add    esp,0x10
 738:	0f b6 c0             	movzx  eax,al
 73b:	83 e0 02             	and    eax,0x2
 73e:	85 c0                	test   eax,eax
 740:	7f e9                	jg     72b <sendPS2Command+0xd>

    outportb(COMMAND_PORT, command);
 742:	0f b6 45 f4          	movzx  eax,BYTE PTR [ebp-0xc]
 746:	83 ec 08             	sub    esp,0x8
 749:	50                   	push   eax
 74a:	6a 64                	push   0x64
 74c:	e8 fc ff ff ff       	call   74d <sendPS2Command+0x2f>
 751:	83 c4 10             	add    esp,0x10
}
 754:	90                   	nop
 755:	c9                   	leave
 756:	c3                   	ret

00000757 <initKeyboard>:

void initKeyboard()
{
 757:	55                   	push   ebp
 758:	89 e5                	mov    ebp,esp
 75a:	83 ec 08             	sub    esp,0x8
    sendPS2Command(0xAD);
 75d:	83 ec 0c             	sub    esp,0xc
 760:	68 ad 00 00 00       	push   0xad
 765:	e8 b4 ff ff ff       	call   71e <sendPS2Command>
 76a:	83 c4 10             	add    esp,0x10

    inportb(DATA_PORT);
 76d:	83 ec 0c             	sub    esp,0xc
 770:	6a 60                	push   0x60
 772:	e8 fc ff ff ff       	call   773 <initKeyboard+0x1c>
 777:	83 c4 10             	add    esp,0x10

    sendPS2Command(0xAE);
 77a:	83 ec 0c             	sub    esp,0xc
 77d:	68 ae 00 00 00       	push   0xae
 782:	e8 97 ff ff ff       	call   71e <sendPS2Command>
 787:	83 c4 10             	add    esp,0x10
}
 78a:	90                   	nop
 78b:	c9                   	leave
 78c:	c3                   	ret

0000078d <_readChar>:
    'D','F','G','H','J','K','L',':', 0x22, '~', 0x00, 0x7C, 'Z','X','C',
    'V','B','N','M','<','>','?'
};

static void _readChar(KEY_S* k)
{
 78d:	55                   	push   ebp
 78e:	89 e5                	mov    ebp,esp
 790:	83 ec 18             	sub    esp,0x18
    uint8_t code = readkey();
 793:	e8 fc ff ff ff       	call   794 <_readChar+0x7>
 798:	88 45 f7             	mov    BYTE PTR [ebp-0x9],al

    writeSerial(code);
 79b:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 79f:	0f be c0             	movsx  eax,al
 7a2:	83 ec 0c             	sub    esp,0xc
 7a5:	50                   	push   eax
 7a6:	e8 fc ff ff ff       	call   7a7 <_readChar+0x1a>
 7ab:	83 c4 10             	add    esp,0x10

    k->scancode = code;
 7ae:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 7b1:	0f b6 55 f7          	movzx  edx,BYTE PTR [ebp-0x9]
 7b5:	88 50 01             	mov    BYTE PTR [eax+0x1],dl
    k->ascii = 0;
 7b8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 7bb:	c6 00 00             	mov    BYTE PTR [eax],0x0

    switch (k->scancode)
 7be:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 7c1:	0f b6 40 01          	movzx  eax,BYTE PTR [eax+0x1]
 7c5:	0f b6 c0             	movzx  eax,al
 7c8:	3d b6 00 00 00       	cmp    eax,0xb6
 7cd:	74 35                	je     804 <_readChar+0x77>
 7cf:	3d b6 00 00 00       	cmp    eax,0xb6
 7d4:	7f 42                	jg     818 <_readChar+0x8b>
 7d6:	3d aa 00 00 00       	cmp    eax,0xaa
 7db:	74 27                	je     804 <_readChar+0x77>
 7dd:	3d aa 00 00 00       	cmp    eax,0xaa
 7e2:	7f 34                	jg     818 <_readChar+0x8b>
 7e4:	83 f8 39             	cmp    eax,0x39
 7e7:	74 27                	je     810 <_readChar+0x83>
 7e9:	83 f8 39             	cmp    eax,0x39
 7ec:	7f 2a                	jg     818 <_readChar+0x8b>
 7ee:	83 f8 2a             	cmp    eax,0x2a
 7f1:	74 05                	je     7f8 <_readChar+0x6b>
 7f3:	83 f8 36             	cmp    eax,0x36
 7f6:	75 20                	jne    818 <_readChar+0x8b>
    {
        case LEFT_SHIFT_DOWN:
        case RIGHT_SHIFT_DOWN:
        {
            shift = 1;
 7f8:	c7 05 04 00 00 00 01 	mov    DWORD PTR ds:0x4,0x1
 7ff:	00 00 00 
            break;
 802:	eb 4d                	jmp    851 <_readChar+0xc4>
        }
        case LEFT_SHIFT_UP:
        case RIGHT_SHIFT_UP:
        {
            shift = 0;
 804:	c7 05 04 00 00 00 00 	mov    DWORD PTR ds:0x4,0x0
 80b:	00 00 00 
            break;
 80e:	eb 41                	jmp    851 <_readChar+0xc4>
        }
        case 0x39:
        {
            k->ascii = ' ';
 810:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 813:	c6 00 20             	mov    BYTE PTR [eax],0x20
            break;
 816:	eb 39                	jmp    851 <_readChar+0xc4>
        }
        default:
        {
            if(shift == 1)
 818:	a1 04 00 00 00       	mov    eax,ds:0x4
 81d:	83 f8 01             	cmp    eax,0x1
 820:	75 18                	jne    83a <_readChar+0xad>
            {
                k->ascii = upperCaseMap[k->scancode];
 822:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 825:	0f b6 40 01          	movzx  eax,BYTE PTR [eax+0x1]
 829:	0f b6 c0             	movzx  eax,al
 82c:	0f b6 90 20 01 00 00 	movzx  edx,BYTE PTR [eax+0x120]
 833:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 836:	88 10                	mov    BYTE PTR [eax],dl
            }
            else
            {
                k->ascii = lowerCaseMap[k->scancode];
            }
            break;
 838:	eb 16                	jmp    850 <_readChar+0xc3>
                k->ascii = lowerCaseMap[k->scancode];
 83a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 83d:	0f b6 40 01          	movzx  eax,BYTE PTR [eax+0x1]
 841:	0f b6 c0             	movzx  eax,al
 844:	0f b6 90 20 00 00 00 	movzx  edx,BYTE PTR [eax+0x20]
 84b:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 84e:	88 10                	mov    BYTE PTR [eax],dl
            break;
 850:	90                   	nop
        }
    }
}
 851:	90                   	nop
 852:	c9                   	leave
 853:	c3                   	ret

00000854 <readChar>:

char readChar()
{
 854:	55                   	push   ebp
 855:	89 e5                	mov    ebp,esp
 857:	83 ec 18             	sub    esp,0x18
    KEY_S k = { .ascii = 0, .scancode = 0 };
 85a:	c6 45 f6 00          	mov    BYTE PTR [ebp-0xa],0x0
 85e:	c6 45 f7 00          	mov    BYTE PTR [ebp-0x9],0x0
    _readChar(&k);
 862:	83 ec 0c             	sub    esp,0xc
 865:	8d 45 f6             	lea    eax,[ebp-0xa]
 868:	50                   	push   eax
 869:	e8 1f ff ff ff       	call   78d <_readChar>
 86e:	83 c4 10             	add    esp,0x10
    return k.ascii;
 871:	0f b6 45 f6          	movzx  eax,BYTE PTR [ebp-0xa]
}
 875:	c9                   	leave
 876:	c3                   	ret

00000877 <readLine>:

int readLine(char* buffer, int length)
{
 877:	55                   	push   ebp
 878:	89 e5                	mov    ebp,esp
 87a:	83 ec 18             	sub    esp,0x18
    int counter = 0;
 87d:	c7 45 f4 00 00 00 00 	mov    DWORD PTR [ebp-0xc],0x0
    while(1)
    {
        KEY_S k = { .ascii = 0, .scancode = 0 };
 884:	c6 45 f2 00          	mov    BYTE PTR [ebp-0xe],0x0
 888:	c6 45 f3 00          	mov    BYTE PTR [ebp-0xd],0x0
        _readChar(&k);
 88c:	83 ec 0c             	sub    esp,0xc
 88f:	8d 45 f2             	lea    eax,[ebp-0xe]
 892:	50                   	push   eax
 893:	e8 f5 fe ff ff       	call   78d <_readChar>
 898:	83 c4 10             	add    esp,0x10

        if(k.scancode == KEY_ENTER)
 89b:	0f b6 45 f3          	movzx  eax,BYTE PTR [ebp-0xd]
 89f:	3c 1c                	cmp    al,0x1c
 8a1:	75 13                	jne    8b6 <readLine+0x3f>
        {
            *(buffer+counter) = 0;
 8a3:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 8a6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 8a9:	01 d0                	add    eax,edx
 8ab:	c6 00 00             	mov    BYTE PTR [eax],0x0
            return counter;
 8ae:	8b 45 f4             	mov    eax,DWORD PTR [ebp-0xc]
 8b1:	e9 c9 00 00 00       	jmp    97f <readLine+0x108>
        }

        if(k.scancode == KEY_BACKSPACE)
 8b6:	0f b6 45 f3          	movzx  eax,BYTE PTR [ebp-0xd]
 8ba:	3c 0e                	cmp    al,0xe
 8bc:	75 71                	jne    92f <readLine+0xb8>
        {
            if(counter > 0)
 8be:	83 7d f4 00          	cmp    DWORD PTR [ebp-0xc],0x0
 8c2:	7e c0                	jle    884 <readLine+0xd>
            {
                counter--;
 8c4:	83 6d f4 01          	sub    DWORD PTR [ebp-0xc],0x1
                screenX--;
 8c8:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 8cf:	83 e8 01             	sub    eax,0x1
 8d2:	a2 00 00 00 00       	mov    ds:0x0,al
                putchar(' ', global_color);
 8d7:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 8de:	0f b6 c0             	movzx  eax,al
 8e1:	83 ec 08             	sub    esp,0x8
 8e4:	50                   	push   eax
 8e5:	6a 20                	push   0x20
 8e7:	e8 fc ff ff ff       	call   8e8 <readLine+0x71>
 8ec:	83 c4 10             	add    esp,0x10

                screenX--;
 8ef:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 8f6:	83 e8 01             	sub    eax,0x1
 8f9:	a2 00 00 00 00       	mov    ds:0x0,al
                setCursorPosition(screenX, screenY);
 8fe:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 905:	0f b6 d0             	movzx  edx,al
 908:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 90f:	0f b6 c0             	movzx  eax,al
 912:	83 ec 08             	sub    esp,0x8
 915:	52                   	push   edx
 916:	50                   	push   eax
 917:	e8 fc ff ff ff       	call   918 <readLine+0xa1>
 91c:	83 c4 10             	add    esp,0x10

                *(buffer+counter) = 0;
 91f:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 922:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 925:	01 d0                	add    eax,edx
 927:	c6 00 00             	mov    BYTE PTR [eax],0x0
 92a:	e9 55 ff ff ff       	jmp    884 <readLine+0xd>
            }
        }
        else if(k.ascii == 0)
 92f:	0f b6 45 f2          	movzx  eax,BYTE PTR [ebp-0xe]
 933:	84 c0                	test   al,al
 935:	0f 84 49 ff ff ff    	je     884 <readLine+0xd>
        {
            // ignore
        }
        else 
        {
            if(counter < length-1)
 93b:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 93e:	83 e8 01             	sub    eax,0x1
 941:	39 45 f4             	cmp    DWORD PTR [ebp-0xc],eax
 944:	0f 8d 3a ff ff ff    	jge    884 <readLine+0xd>
            {
                *(buffer+counter) = k.ascii;
 94a:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 94d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 950:	01 c2                	add    edx,eax
 952:	0f b6 45 f2          	movzx  eax,BYTE PTR [ebp-0xe]
 956:	88 02                	mov    BYTE PTR [edx],al
                counter++;
 958:	83 45 f4 01          	add    DWORD PTR [ebp-0xc],0x1
                putchar(k.ascii, global_color);
 95c:	0f b6 05 00 00 00 00 	movzx  eax,BYTE PTR ds:0x0
 963:	0f b6 d0             	movzx  edx,al
 966:	0f b6 45 f2          	movzx  eax,BYTE PTR [ebp-0xe]
 96a:	0f be c0             	movsx  eax,al
 96d:	83 ec 08             	sub    esp,0x8
 970:	52                   	push   edx
 971:	50                   	push   eax
 972:	e8 fc ff ff ff       	call   973 <readLine+0xfc>
 977:	83 c4 10             	add    esp,0x10
    {
 97a:	e9 05 ff ff ff       	jmp    884 <readLine+0xd>
            }
        }
    }

    return 0;
}
 97f:	c9                   	leave
 980:	c3                   	ret

00000981 <setCursorPosition>:

void setCursorPosition(int x, int y)
{
 981:	55                   	push   ebp
 982:	89 e5                	mov    ebp,esp
 984:	83 ec 18             	sub    esp,0x18
    if(x < 0) x = 0;
 987:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
 98b:	79 07                	jns    994 <setCursorPosition+0x13>
 98d:	c7 45 08 00 00 00 00 	mov    DWORD PTR [ebp+0x8],0x0
    if(x > 79) x = 79;
 994:	83 7d 08 4f          	cmp    DWORD PTR [ebp+0x8],0x4f
 998:	7e 07                	jle    9a1 <setCursorPosition+0x20>
 99a:	c7 45 08 4f 00 00 00 	mov    DWORD PTR [ebp+0x8],0x4f
    if(y < 0) y = 0;
 9a1:	83 7d 0c 00          	cmp    DWORD PTR [ebp+0xc],0x0
 9a5:	79 07                	jns    9ae <setCursorPosition+0x2d>
 9a7:	c7 45 0c 00 00 00 00 	mov    DWORD PTR [ebp+0xc],0x0
    if(y > 24) y = 24;
 9ae:	83 7d 0c 18          	cmp    DWORD PTR [ebp+0xc],0x18
 9b2:	7e 07                	jle    9bb <setCursorPosition+0x3a>
 9b4:	c7 45 0c 18 00 00 00 	mov    DWORD PTR [ebp+0xc],0x18

    screenX = x;
 9bb:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 9be:	a2 00 00 00 00       	mov    ds:0x0,al
    screenY = y;
 9c3:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 9c6:	a2 00 00 00 00       	mov    ds:0x0,al

    uint16_t pos = y * 80 + x;
 9cb:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 9ce:	89 c2                	mov    edx,eax
 9d0:	89 d0                	mov    eax,edx
 9d2:	c1 e0 02             	shl    eax,0x2
 9d5:	01 d0                	add    eax,edx
 9d7:	c1 e0 04             	shl    eax,0x4
 9da:	89 c2                	mov    edx,eax
 9dc:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 9df:	01 d0                	add    eax,edx
 9e1:	66 89 45 f6          	mov    WORD PTR [ebp-0xa],ax

    outportb(0x3D4, 0x0F);
 9e5:	83 ec 08             	sub    esp,0x8
 9e8:	6a 0f                	push   0xf
 9ea:	68 d4 03 00 00       	push   0x3d4
 9ef:	e8 fc ff ff ff       	call   9f0 <setCursorPosition+0x6f>
 9f4:	83 c4 10             	add    esp,0x10
    outportb(0x3D5, (unsigned char)(pos & 0xFF));
 9f7:	0f b7 45 f6          	movzx  eax,WORD PTR [ebp-0xa]
 9fb:	0f b6 c0             	movzx  eax,al
 9fe:	83 ec 08             	sub    esp,0x8
 a01:	50                   	push   eax
 a02:	68 d5 03 00 00       	push   0x3d5
 a07:	e8 fc ff ff ff       	call   a08 <setCursorPosition+0x87>
 a0c:	83 c4 10             	add    esp,0x10
    outportb(0x3D4, 0x0E);
 a0f:	83 ec 08             	sub    esp,0x8
 a12:	6a 0e                	push   0xe
 a14:	68 d4 03 00 00       	push   0x3d4
 a19:	e8 fc ff ff ff       	call   a1a <setCursorPosition+0x99>
 a1e:	83 c4 10             	add    esp,0x10
    outportb(0x3D5, (unsigned char)((pos >> 8) & 0xFF));
 a21:	0f b7 45 f6          	movzx  eax,WORD PTR [ebp-0xa]
 a25:	66 c1 e8 08          	shr    ax,0x8
 a29:	0f b6 c0             	movzx  eax,al
 a2c:	83 ec 08             	sub    esp,0x8
 a2f:	50                   	push   eax
 a30:	68 d5 03 00 00       	push   0x3d5
 a35:	e8 fc ff ff ff       	call   a36 <setCursorPosition+0xb5>
 a3a:	83 c4 10             	add    esp,0x10
 a3d:	90                   	nop
 a3e:	c9                   	leave
 a3f:	c3                   	ret
