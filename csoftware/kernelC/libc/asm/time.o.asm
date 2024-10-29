
time.o:     file format elf32-i386


Disassembly of section .text:

00000000 <get_update_in_progress_flag>:
#include "string.h"
 
static int century_register = 0x00;

static int get_update_in_progress_flag() 
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
   3:	83 ec 08             	sub    esp,0x8
    outportb(cmos_address, 0x0A);
   6:	83 ec 08             	sub    esp,0x8
   9:	6a 0a                	push   0xa
   b:	6a 70                	push   0x70
   d:	e8 fc ff ff ff       	call   e <get_update_in_progress_flag+0xe>
  12:	83 c4 10             	add    esp,0x10
    return (inportb(cmos_data) & 0x80);
  15:	83 ec 0c             	sub    esp,0xc
  18:	6a 71                	push   0x71
  1a:	e8 fc ff ff ff       	call   1b <get_update_in_progress_flag+0x1b>
  1f:	83 c4 10             	add    esp,0x10
  22:	0f b6 c0             	movzx  eax,al
  25:	25 80 00 00 00       	and    eax,0x80
}
  2a:	c9                   	leave
  2b:	c3                   	ret

0000002c <get_RTC_register>:
 
static unsigned char get_RTC_register(int reg) 
{
  2c:	55                   	push   ebp
  2d:	89 e5                	mov    ebp,esp
  2f:	83 ec 08             	sub    esp,0x8
    outportb(cmos_address, reg);
  32:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  35:	0f b6 c0             	movzx  eax,al
  38:	83 ec 08             	sub    esp,0x8
  3b:	50                   	push   eax
  3c:	6a 70                	push   0x70
  3e:	e8 fc ff ff ff       	call   3f <get_RTC_register+0x13>
  43:	83 c4 10             	add    esp,0x10
    return inportb(cmos_data);
  46:	83 ec 0c             	sub    esp,0xc
  49:	6a 71                	push   0x71
  4b:	e8 fc ff ff ff       	call   4c <get_RTC_register+0x20>
  50:	83 c4 10             	add    esp,0x10
}
  53:	c9                   	leave
  54:	c3                   	ret

00000055 <read_rtc>:

static void read_rtc(tm* time)
{
  55:	55                   	push   ebp
  56:	89 e5                	mov    ebp,esp
  58:	53                   	push   ebx
  59:	83 ec 14             	sub    esp,0x14
    unsigned char century = 20;
  5c:	c6 45 f7 14          	mov    BYTE PTR [ebp-0x9],0x14
    unsigned char registerB;
 
    // Note: This uses the "read registers until you get the same values twice in a row" technique
    //     to avoid getting dodgy/inconsistent values due to RTC updates
 
    while (get_update_in_progress_flag());            // Make sure an update isn't in progress
  60:	90                   	nop
  61:	e8 9a ff ff ff       	call   0 <get_update_in_progress_flag>
  66:	85 c0                	test   eax,eax
  68:	75 f7                	jne    61 <read_rtc+0xc>
    time->tm_sec = get_RTC_register(0x00);
  6a:	83 ec 0c             	sub    esp,0xc
  6d:	6a 00                	push   0x0
  6f:	e8 b8 ff ff ff       	call   2c <get_RTC_register>
  74:	83 c4 10             	add    esp,0x10
  77:	0f b6 d0             	movzx  edx,al
  7a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  7d:	89 10                	mov    DWORD PTR [eax],edx
    time->tm_min = get_RTC_register(0x02);
  7f:	83 ec 0c             	sub    esp,0xc
  82:	6a 02                	push   0x2
  84:	e8 a3 ff ff ff       	call   2c <get_RTC_register>
  89:	83 c4 10             	add    esp,0x10
  8c:	0f b6 d0             	movzx  edx,al
  8f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  92:	89 50 04             	mov    DWORD PTR [eax+0x4],edx
    time->tm_hour = get_RTC_register(0x04);
  95:	83 ec 0c             	sub    esp,0xc
  98:	6a 04                	push   0x4
  9a:	e8 8d ff ff ff       	call   2c <get_RTC_register>
  9f:	83 c4 10             	add    esp,0x10
  a2:	0f b6 d0             	movzx  edx,al
  a5:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  a8:	89 50 08             	mov    DWORD PTR [eax+0x8],edx
    time->tm_wday = get_RTC_register(0x06);
  ab:	83 ec 0c             	sub    esp,0xc
  ae:	6a 06                	push   0x6
  b0:	e8 77 ff ff ff       	call   2c <get_RTC_register>
  b5:	83 c4 10             	add    esp,0x10
  b8:	0f b6 d0             	movzx  edx,al
  bb:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  be:	89 50 18             	mov    DWORD PTR [eax+0x18],edx
    time->tm_mday = get_RTC_register(0x07);
  c1:	83 ec 0c             	sub    esp,0xc
  c4:	6a 07                	push   0x7
  c6:	e8 61 ff ff ff       	call   2c <get_RTC_register>
  cb:	83 c4 10             	add    esp,0x10
  ce:	0f b6 d0             	movzx  edx,al
  d1:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  d4:	89 50 0c             	mov    DWORD PTR [eax+0xc],edx
    time->tm_mon = get_RTC_register(0x08);
  d7:	83 ec 0c             	sub    esp,0xc
  da:	6a 08                	push   0x8
  dc:	e8 4b ff ff ff       	call   2c <get_RTC_register>
  e1:	83 c4 10             	add    esp,0x10
  e4:	0f b6 d0             	movzx  edx,al
  e7:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  ea:	89 50 10             	mov    DWORD PTR [eax+0x10],edx
    time->tm_year = get_RTC_register(0x09);
  ed:	83 ec 0c             	sub    esp,0xc
  f0:	6a 09                	push   0x9
  f2:	e8 35 ff ff ff       	call   2c <get_RTC_register>
  f7:	83 c4 10             	add    esp,0x10
  fa:	0f b6 d0             	movzx  edx,al
  fd:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 100:	89 50 14             	mov    DWORD PTR [eax+0x14],edx
    if(century_register != 0)
 103:	a1 00 00 00 00       	mov    eax,ds:0x0
 108:	85 c0                	test   eax,eax
 10a:	74 14                	je     120 <read_rtc+0xcb>
    {
        century = get_RTC_register(century_register);
 10c:	a1 00 00 00 00       	mov    eax,ds:0x0
 111:	83 ec 0c             	sub    esp,0xc
 114:	50                   	push   eax
 115:	e8 12 ff ff ff       	call   2c <get_RTC_register>
 11a:	83 c4 10             	add    esp,0x10
 11d:	88 45 f7             	mov    BYTE PTR [ebp-0x9],al
    }
 
    do
    {
        last_second = time->tm_sec;
 120:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 123:	8b 00                	mov    eax,DWORD PTR [eax]
 125:	88 45 f6             	mov    BYTE PTR [ebp-0xa],al
        last_minute = time->tm_min;
 128:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 12b:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
 12e:	88 45 f5             	mov    BYTE PTR [ebp-0xb],al
        last_hour = time->tm_hour;
 131:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 134:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 137:	88 45 f4             	mov    BYTE PTR [ebp-0xc],al
        last_day = time->tm_mday;
 13a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 13d:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
 140:	88 45 f3             	mov    BYTE PTR [ebp-0xd],al
        last_wday = time->tm_wday;
 143:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 146:	8b 40 18             	mov    eax,DWORD PTR [eax+0x18]
 149:	88 45 f2             	mov    BYTE PTR [ebp-0xe],al
        last_month = time->tm_mon;
 14c:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 14f:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
 152:	88 45 f1             	mov    BYTE PTR [ebp-0xf],al
        last_year = time->tm_year;
 155:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 158:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 15b:	88 45 f0             	mov    BYTE PTR [ebp-0x10],al
        last_century = century;
 15e:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 162:	88 45 ef             	mov    BYTE PTR [ebp-0x11],al
 
        while (get_update_in_progress_flag()) ;         // Make sure an update isn't in progress
 165:	90                   	nop
 166:	e8 95 fe ff ff       	call   0 <get_update_in_progress_flag>
 16b:	85 c0                	test   eax,eax
 16d:	75 f7                	jne    166 <read_rtc+0x111>

        time->tm_sec = get_RTC_register(0x00);
 16f:	83 ec 0c             	sub    esp,0xc
 172:	6a 00                	push   0x0
 174:	e8 b3 fe ff ff       	call   2c <get_RTC_register>
 179:	83 c4 10             	add    esp,0x10
 17c:	0f b6 d0             	movzx  edx,al
 17f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 182:	89 10                	mov    DWORD PTR [eax],edx
        time->tm_min = get_RTC_register(0x02);
 184:	83 ec 0c             	sub    esp,0xc
 187:	6a 02                	push   0x2
 189:	e8 9e fe ff ff       	call   2c <get_RTC_register>
 18e:	83 c4 10             	add    esp,0x10
 191:	0f b6 d0             	movzx  edx,al
 194:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 197:	89 50 04             	mov    DWORD PTR [eax+0x4],edx
        time->tm_hour = get_RTC_register(0x04);
 19a:	83 ec 0c             	sub    esp,0xc
 19d:	6a 04                	push   0x4
 19f:	e8 88 fe ff ff       	call   2c <get_RTC_register>
 1a4:	83 c4 10             	add    esp,0x10
 1a7:	0f b6 d0             	movzx  edx,al
 1aa:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1ad:	89 50 08             	mov    DWORD PTR [eax+0x8],edx
        time->tm_mday = get_RTC_register(0x07);
 1b0:	83 ec 0c             	sub    esp,0xc
 1b3:	6a 07                	push   0x7
 1b5:	e8 72 fe ff ff       	call   2c <get_RTC_register>
 1ba:	83 c4 10             	add    esp,0x10
 1bd:	0f b6 d0             	movzx  edx,al
 1c0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1c3:	89 50 0c             	mov    DWORD PTR [eax+0xc],edx
        time->tm_wday = get_RTC_register(0x06);
 1c6:	83 ec 0c             	sub    esp,0xc
 1c9:	6a 06                	push   0x6
 1cb:	e8 5c fe ff ff       	call   2c <get_RTC_register>
 1d0:	83 c4 10             	add    esp,0x10
 1d3:	0f b6 d0             	movzx  edx,al
 1d6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1d9:	89 50 18             	mov    DWORD PTR [eax+0x18],edx
        time->tm_mon = get_RTC_register(0x08);
 1dc:	83 ec 0c             	sub    esp,0xc
 1df:	6a 08                	push   0x8
 1e1:	e8 46 fe ff ff       	call   2c <get_RTC_register>
 1e6:	83 c4 10             	add    esp,0x10
 1e9:	0f b6 d0             	movzx  edx,al
 1ec:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1ef:	89 50 10             	mov    DWORD PTR [eax+0x10],edx
        time->tm_year = get_RTC_register(0x09);
 1f2:	83 ec 0c             	sub    esp,0xc
 1f5:	6a 09                	push   0x9
 1f7:	e8 30 fe ff ff       	call   2c <get_RTC_register>
 1fc:	83 c4 10             	add    esp,0x10
 1ff:	0f b6 d0             	movzx  edx,al
 202:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 205:	89 50 14             	mov    DWORD PTR [eax+0x14],edx

        if(century_register != 0)
 208:	a1 00 00 00 00       	mov    eax,ds:0x0
 20d:	85 c0                	test   eax,eax
 20f:	74 14                	je     225 <read_rtc+0x1d0>
        {
            century = get_RTC_register(century_register);
 211:	a1 00 00 00 00       	mov    eax,ds:0x0
 216:	83 ec 0c             	sub    esp,0xc
 219:	50                   	push   eax
 21a:	e8 0d fe ff ff       	call   2c <get_RTC_register>
 21f:	83 c4 10             	add    esp,0x10
 222:	88 45 f7             	mov    BYTE PTR [ebp-0x9],al
        }
    } while( (last_second != time->tm_sec) || 
 225:	0f b6 55 f6          	movzx  edx,BYTE PTR [ebp-0xa]
 229:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 22c:	8b 00                	mov    eax,DWORD PTR [eax]
            (last_minute != time->tm_min) || 
            (last_hour != time->tm_hour) ||
            (last_day != time->tm_mday) || 
            (last_month != time->tm_mon) || 
            (last_year != time->tm_year) ||
            (last_century != century) ||
 22e:	39 c2                	cmp    edx,eax
 230:	0f 85 ea fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_minute != time->tm_min) || 
 236:	0f b6 55 f5          	movzx  edx,BYTE PTR [ebp-0xb]
 23a:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 23d:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
    } while( (last_second != time->tm_sec) || 
 240:	39 c2                	cmp    edx,eax
 242:	0f 85 d8 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_hour != time->tm_hour) ||
 248:	0f b6 55 f4          	movzx  edx,BYTE PTR [ebp-0xc]
 24c:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 24f:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
            (last_minute != time->tm_min) || 
 252:	39 c2                	cmp    edx,eax
 254:	0f 85 c6 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_day != time->tm_mday) || 
 25a:	0f b6 55 f3          	movzx  edx,BYTE PTR [ebp-0xd]
 25e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 261:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
            (last_hour != time->tm_hour) ||
 264:	39 c2                	cmp    edx,eax
 266:	0f 85 b4 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_month != time->tm_mon) || 
 26c:	0f b6 55 f1          	movzx  edx,BYTE PTR [ebp-0xf]
 270:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 273:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
            (last_day != time->tm_mday) || 
 276:	39 c2                	cmp    edx,eax
 278:	0f 85 a2 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_year != time->tm_year) ||
 27e:	0f b6 55 f0          	movzx  edx,BYTE PTR [ebp-0x10]
 282:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 285:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
            (last_month != time->tm_mon) || 
 288:	39 c2                	cmp    edx,eax
 28a:	0f 85 90 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_year != time->tm_year) ||
 290:	0f b6 45 ef          	movzx  eax,BYTE PTR [ebp-0x11]
 294:	3a 45 f7             	cmp    al,BYTE PTR [ebp-0x9]
 297:	0f 85 83 fe ff ff    	jne    120 <read_rtc+0xcb>
            (last_wday != time->tm_wday));
 29d:	0f b6 55 f2          	movzx  edx,BYTE PTR [ebp-0xe]
 2a1:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2a4:	8b 40 18             	mov    eax,DWORD PTR [eax+0x18]
            (last_century != century) ||
 2a7:	39 c2                	cmp    edx,eax
 2a9:	0f 85 71 fe ff ff    	jne    120 <read_rtc+0xcb>
 
    registerB = get_RTC_register(0x0B);
 2af:	83 ec 0c             	sub    esp,0xc
 2b2:	6a 0b                	push   0xb
 2b4:	e8 73 fd ff ff       	call   2c <get_RTC_register>
 2b9:	83 c4 10             	add    esp,0x10
 2bc:	88 45 ee             	mov    BYTE PTR [ebp-0x12],al
 
    // Convert BCD to binary values if necessary
 
    if (!(registerB & 0x04))
 2bf:	0f b6 45 ee          	movzx  eax,BYTE PTR [ebp-0x12]
 2c3:	83 e0 04             	and    eax,0x4
 2c6:	85 c0                	test   eax,eax
 2c8:	0f 85 86 01 00 00    	jne    454 <read_rtc+0x3ff>
    {
        time->tm_sec = (time->tm_sec & 0x0F) + ((time->tm_sec / 16) * 10);
 2ce:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2d1:	8b 00                	mov    eax,DWORD PTR [eax]
 2d3:	83 e0 0f             	and    eax,0xf
 2d6:	89 c1                	mov    ecx,eax
 2d8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2db:	8b 00                	mov    eax,DWORD PTR [eax]
 2dd:	8d 50 0f             	lea    edx,[eax+0xf]
 2e0:	85 c0                	test   eax,eax
 2e2:	0f 48 c2             	cmovs  eax,edx
 2e5:	c1 f8 04             	sar    eax,0x4
 2e8:	89 c2                	mov    edx,eax
 2ea:	89 d0                	mov    eax,edx
 2ec:	c1 e0 02             	shl    eax,0x2
 2ef:	01 d0                	add    eax,edx
 2f1:	01 c0                	add    eax,eax
 2f3:	8d 14 01             	lea    edx,[ecx+eax*1]
 2f6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2f9:	89 10                	mov    DWORD PTR [eax],edx
        time->tm_min = (time->tm_min & 0x0F) + ((time->tm_min / 16) * 10);
 2fb:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 2fe:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
 301:	83 e0 0f             	and    eax,0xf
 304:	89 c1                	mov    ecx,eax
 306:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 309:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
 30c:	8d 50 0f             	lea    edx,[eax+0xf]
 30f:	85 c0                	test   eax,eax
 311:	0f 48 c2             	cmovs  eax,edx
 314:	c1 f8 04             	sar    eax,0x4
 317:	89 c2                	mov    edx,eax
 319:	89 d0                	mov    eax,edx
 31b:	c1 e0 02             	shl    eax,0x2
 31e:	01 d0                	add    eax,edx
 320:	01 c0                	add    eax,eax
 322:	8d 14 01             	lea    edx,[ecx+eax*1]
 325:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 328:	89 50 04             	mov    DWORD PTR [eax+0x4],edx
        time->tm_hour = ( (time->tm_hour & 0x0F) + (((time->tm_hour & 0x70) / 16) * 10) ) | (time->tm_hour & 0x80);
 32b:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 32e:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 331:	83 e0 0f             	and    eax,0xf
 334:	89 c1                	mov    ecx,eax
 336:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 339:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 33c:	83 e0 70             	and    eax,0x70
 33f:	8d 50 0f             	lea    edx,[eax+0xf]
 342:	85 c0                	test   eax,eax
 344:	0f 48 c2             	cmovs  eax,edx
 347:	c1 f8 04             	sar    eax,0x4
 34a:	89 c2                	mov    edx,eax
 34c:	89 d0                	mov    eax,edx
 34e:	c1 e0 02             	shl    eax,0x2
 351:	01 d0                	add    eax,edx
 353:	01 c0                	add    eax,eax
 355:	8d 14 01             	lea    edx,[ecx+eax*1]
 358:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 35b:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 35e:	25 80 00 00 00       	and    eax,0x80
 363:	09 c2                	or     edx,eax
 365:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 368:	89 50 08             	mov    DWORD PTR [eax+0x8],edx
        time->tm_mday = (time->tm_mday & 0x0F) + ((time->tm_mday / 16) * 10);
 36b:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 36e:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
 371:	83 e0 0f             	and    eax,0xf
 374:	89 c1                	mov    ecx,eax
 376:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 379:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
 37c:	8d 50 0f             	lea    edx,[eax+0xf]
 37f:	85 c0                	test   eax,eax
 381:	0f 48 c2             	cmovs  eax,edx
 384:	c1 f8 04             	sar    eax,0x4
 387:	89 c2                	mov    edx,eax
 389:	89 d0                	mov    eax,edx
 38b:	c1 e0 02             	shl    eax,0x2
 38e:	01 d0                	add    eax,edx
 390:	01 c0                	add    eax,eax
 392:	8d 14 01             	lea    edx,[ecx+eax*1]
 395:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 398:	89 50 0c             	mov    DWORD PTR [eax+0xc],edx
        time->tm_wday = (time->tm_wday & 0x0F) + ((time->tm_wday / 16) * 10);
 39b:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 39e:	8b 40 18             	mov    eax,DWORD PTR [eax+0x18]
 3a1:	83 e0 0f             	and    eax,0xf
 3a4:	89 c1                	mov    ecx,eax
 3a6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3a9:	8b 40 18             	mov    eax,DWORD PTR [eax+0x18]
 3ac:	8d 50 0f             	lea    edx,[eax+0xf]
 3af:	85 c0                	test   eax,eax
 3b1:	0f 48 c2             	cmovs  eax,edx
 3b4:	c1 f8 04             	sar    eax,0x4
 3b7:	89 c2                	mov    edx,eax
 3b9:	89 d0                	mov    eax,edx
 3bb:	c1 e0 02             	shl    eax,0x2
 3be:	01 d0                	add    eax,edx
 3c0:	01 c0                	add    eax,eax
 3c2:	8d 14 01             	lea    edx,[ecx+eax*1]
 3c5:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3c8:	89 50 18             	mov    DWORD PTR [eax+0x18],edx
        time->tm_mon = (time->tm_mon & 0x0F) + ((time->tm_mon / 16) * 10);
 3cb:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3ce:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
 3d1:	83 e0 0f             	and    eax,0xf
 3d4:	89 c1                	mov    ecx,eax
 3d6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3d9:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
 3dc:	8d 50 0f             	lea    edx,[eax+0xf]
 3df:	85 c0                	test   eax,eax
 3e1:	0f 48 c2             	cmovs  eax,edx
 3e4:	c1 f8 04             	sar    eax,0x4
 3e7:	89 c2                	mov    edx,eax
 3e9:	89 d0                	mov    eax,edx
 3eb:	c1 e0 02             	shl    eax,0x2
 3ee:	01 d0                	add    eax,edx
 3f0:	01 c0                	add    eax,eax
 3f2:	8d 14 01             	lea    edx,[ecx+eax*1]
 3f5:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3f8:	89 50 10             	mov    DWORD PTR [eax+0x10],edx
        time->tm_year = (time->tm_year & 0x0F) + ((time->tm_year / 16) * 10);
 3fb:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 3fe:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 401:	83 e0 0f             	and    eax,0xf
 404:	89 c1                	mov    ecx,eax
 406:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 409:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 40c:	8d 50 0f             	lea    edx,[eax+0xf]
 40f:	85 c0                	test   eax,eax
 411:	0f 48 c2             	cmovs  eax,edx
 414:	c1 f8 04             	sar    eax,0x4
 417:	89 c2                	mov    edx,eax
 419:	89 d0                	mov    eax,edx
 41b:	c1 e0 02             	shl    eax,0x2
 41e:	01 d0                	add    eax,edx
 420:	01 c0                	add    eax,eax
 422:	8d 14 01             	lea    edx,[ecx+eax*1]
 425:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 428:	89 50 14             	mov    DWORD PTR [eax+0x14],edx
        if(century_register != 0)
 42b:	a1 00 00 00 00       	mov    eax,ds:0x0
 430:	85 c0                	test   eax,eax
 432:	74 20                	je     454 <read_rtc+0x3ff>
        {
            century = (century & 0x0F) + ((century / 16) * 10);
 434:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 438:	83 e0 0f             	and    eax,0xf
 43b:	89 c1                	mov    ecx,eax
 43d:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 441:	c0 e8 04             	shr    al,0x4
 444:	89 c2                	mov    edx,eax
 446:	89 d0                	mov    eax,edx
 448:	c1 e0 02             	shl    eax,0x2
 44b:	01 d0                	add    eax,edx
 44d:	01 c0                	add    eax,eax
 44f:	01 c8                	add    eax,ecx
 451:	88 45 f7             	mov    BYTE PTR [ebp-0x9],al
        }
    }
 
    // Convert 12 hour clock to 24 hour clock if necessary
 
    if (!(registerB & 0x02) && (time->tm_hour & 0x80))
 454:	0f b6 45 ee          	movzx  eax,BYTE PTR [ebp-0x12]
 458:	83 e0 02             	and    eax,0x2
 45b:	85 c0                	test   eax,eax
 45d:	75 45                	jne    4a4 <read_rtc+0x44f>
 45f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 462:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 465:	25 80 00 00 00       	and    eax,0x80
 46a:	85 c0                	test   eax,eax
 46c:	74 36                	je     4a4 <read_rtc+0x44f>
    {
        time->tm_hour = ((time->tm_hour & 0x7F) + 12) % 24;
 46e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 471:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 474:	83 e0 7f             	and    eax,0x7f
 477:	8d 48 0c             	lea    ecx,[eax+0xc]
 47a:	ba ab aa aa 2a       	mov    edx,0x2aaaaaab
 47f:	89 c8                	mov    eax,ecx
 481:	f7 ea                	imul   edx
 483:	89 d0                	mov    eax,edx
 485:	c1 f8 02             	sar    eax,0x2
 488:	89 cb                	mov    ebx,ecx
 48a:	c1 fb 1f             	sar    ebx,0x1f
 48d:	29 d8                	sub    eax,ebx
 48f:	89 c2                	mov    edx,eax
 491:	89 d0                	mov    eax,edx
 493:	01 c0                	add    eax,eax
 495:	01 d0                	add    eax,edx
 497:	c1 e0 03             	shl    eax,0x3
 49a:	29 c1                	sub    ecx,eax
 49c:	89 ca                	mov    edx,ecx
 49e:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4a1:	89 50 08             	mov    DWORD PTR [eax+0x8],edx
    }
 
    // Calculate the full (4-digit) year
 
    if(century_register != 0)
 4a4:	a1 00 00 00 00       	mov    eax,ds:0x0
 4a9:	85 c0                	test   eax,eax
 4ab:	74 17                	je     4c4 <read_rtc+0x46f>
    {
        time->tm_year += century * 100;
 4ad:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4b0:	8b 50 14             	mov    edx,DWORD PTR [eax+0x14]
 4b3:	0f b6 45 f7          	movzx  eax,BYTE PTR [ebp-0x9]
 4b7:	6b c0 64             	imul   eax,eax,0x64
 4ba:	01 c2                	add    edx,eax
 4bc:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4bf:	89 50 14             	mov    DWORD PTR [eax+0x14],edx
    else
    {
        time->tm_year += (CURRENT_YEAR / 100) * 100;
        if(time->tm_year < CURRENT_YEAR) time->tm_year += 100;
    }
}
 4c2:	eb 2e                	jmp    4f2 <read_rtc+0x49d>
        time->tm_year += (CURRENT_YEAR / 100) * 100;
 4c4:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4c7:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 4ca:	8d 90 d0 07 00 00    	lea    edx,[eax+0x7d0]
 4d0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4d3:	89 50 14             	mov    DWORD PTR [eax+0x14],edx
        if(time->tm_year < CURRENT_YEAR) time->tm_year += 100;
 4d6:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4d9:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 4dc:	3d e7 07 00 00       	cmp    eax,0x7e7
 4e1:	7f 0f                	jg     4f2 <read_rtc+0x49d>
 4e3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4e6:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 4e9:	8d 50 64             	lea    edx,[eax+0x64]
 4ec:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 4ef:	89 50 14             	mov    DWORD PTR [eax+0x14],edx
}
 4f2:	90                   	nop
 4f3:	8b 5d fc             	mov    ebx,DWORD PTR [ebp-0x4]
 4f6:	c9                   	leave
 4f7:	c3                   	ret

000004f8 <mktime>:

time_t mktime(struct tm* t)
{
 4f8:	55                   	push   ebp
 4f9:	89 e5                	mov    ebp,esp
 4fb:	57                   	push   edi
 4fc:	56                   	push   esi
 4fd:	53                   	push   ebx
 4fe:	83 ec 44             	sub    esp,0x44
    // https://de.wikipedia.org/wiki/Unixzeit

    const short days_in_months[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
 501:	66 c7 45 cc 00 00    	mov    WORD PTR [ebp-0x34],0x0
 507:	66 c7 45 ce 1f 00    	mov    WORD PTR [ebp-0x32],0x1f
 50d:	66 c7 45 d0 3b 00    	mov    WORD PTR [ebp-0x30],0x3b
 513:	66 c7 45 d2 5a 00    	mov    WORD PTR [ebp-0x2e],0x5a
 519:	66 c7 45 d4 78 00    	mov    WORD PTR [ebp-0x2c],0x78
 51f:	66 c7 45 d6 97 00    	mov    WORD PTR [ebp-0x2a],0x97
 525:	66 c7 45 d8 b5 00    	mov    WORD PTR [ebp-0x28],0xb5
 52b:	66 c7 45 da d4 00    	mov    WORD PTR [ebp-0x26],0xd4
 531:	66 c7 45 dc f3 00    	mov    WORD PTR [ebp-0x24],0xf3
 537:	66 c7 45 de 11 01    	mov    WORD PTR [ebp-0x22],0x111
 53d:	66 c7 45 e0 30 01    	mov    WORD PTR [ebp-0x20],0x130
 543:	66 c7 45 e2 4e 01    	mov    WORD PTR [ebp-0x1e],0x14e

    int leapyears = ((t->tm_year-1) - 1968) / 4 
 549:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 54c:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 54f:	2d b1 07 00 00       	sub    eax,0x7b1
 554:	8d 50 03             	lea    edx,[eax+0x3]
 557:	85 c0                	test   eax,eax
 559:	0f 48 c2             	cmovs  eax,edx
 55c:	c1 f8 02             	sar    eax,0x2
 55f:	89 c3                	mov    ebx,eax
        - ((t->tm_year - 1) - 1900) / 100 
 561:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 564:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 567:	8d 88 93 f8 ff ff    	lea    ecx,[eax-0x76d]
 56d:	ba 1f 85 eb 51       	mov    edx,0x51eb851f
 572:	89 c8                	mov    eax,ecx
 574:	f7 ea                	imul   edx
 576:	c1 fa 05             	sar    edx,0x5
 579:	89 c8                	mov    eax,ecx
 57b:	c1 f8 1f             	sar    eax,0x1f
 57e:	29 d0                	sub    eax,edx
 580:	01 c3                	add    ebx,eax
        + ((t->tm_year-1) - 1600) / 400;
 582:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 585:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 588:	8d 88 bf f9 ff ff    	lea    ecx,[eax-0x641]
 58e:	ba 1f 85 eb 51       	mov    edx,0x51eb851f
 593:	89 c8                	mov    eax,ecx
 595:	f7 ea                	imul   edx
 597:	89 d0                	mov    eax,edx
 599:	c1 f8 07             	sar    eax,0x7
 59c:	c1 f9 1f             	sar    ecx,0x1f
 59f:	89 ca                	mov    edx,ecx
 5a1:	29 d0                	sub    eax,edx
    int leapyears = ((t->tm_year-1) - 1968) / 4 
 5a3:	01 d8                	add    eax,ebx
 5a5:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
        
    long long days_since_1970 = (t->tm_year - 1970) * 365 
 5a8:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5ab:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 5ae:	2d b2 07 00 00       	sub    eax,0x7b2
 5b3:	69 d0 6d 01 00 00    	imul   edx,eax,0x16d
        + leapyears 
 5b9:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
 5bc:	01 c2                	add    edx,eax
        + days_in_months[t->tm_mon - 1] + t->tm_mday - 1;
 5be:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5c1:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
 5c4:	83 e8 01             	sub    eax,0x1
 5c7:	0f b7 44 45 cc       	movzx  eax,WORD PTR [ebp+eax*2-0x34]
 5cc:	98                   	cwde
 5cd:	01 c2                	add    edx,eax
 5cf:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5d2:	8b 40 0c             	mov    eax,DWORD PTR [eax+0xc]
 5d5:	01 d0                	add    eax,edx
 5d7:	83 e8 01             	sub    eax,0x1
    long long days_since_1970 = (t->tm_year - 1970) * 365 
 5da:	99                   	cdq
 5db:	89 45 e8             	mov    DWORD PTR [ebp-0x18],eax
 5de:	89 55 ec             	mov    DWORD PTR [ebp-0x14],edx

    if( (t->tm_mon > 2) && (t->tm_year % 4 == 0 && (t->tm_year % 100 != 0 || t->tm_year % 400 == 0)))
 5e1:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5e4:	8b 40 10             	mov    eax,DWORD PTR [eax+0x10]
 5e7:	83 f8 02             	cmp    eax,0x2
 5ea:	7e 64                	jle    650 <mktime+0x158>
 5ec:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5ef:	8b 40 14             	mov    eax,DWORD PTR [eax+0x14]
 5f2:	83 e0 03             	and    eax,0x3
 5f5:	85 c0                	test   eax,eax
 5f7:	75 57                	jne    650 <mktime+0x158>
 5f9:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 5fc:	8b 48 14             	mov    ecx,DWORD PTR [eax+0x14]
 5ff:	ba 1f 85 eb 51       	mov    edx,0x51eb851f
 604:	89 c8                	mov    eax,ecx
 606:	f7 ea                	imul   edx
 608:	89 d0                	mov    eax,edx
 60a:	c1 f8 05             	sar    eax,0x5
 60d:	89 ca                	mov    edx,ecx
 60f:	c1 fa 1f             	sar    edx,0x1f
 612:	29 d0                	sub    eax,edx
 614:	6b d0 64             	imul   edx,eax,0x64
 617:	89 c8                	mov    eax,ecx
 619:	29 d0                	sub    eax,edx
 61b:	85 c0                	test   eax,eax
 61d:	75 29                	jne    648 <mktime+0x150>
 61f:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 622:	8b 48 14             	mov    ecx,DWORD PTR [eax+0x14]
 625:	ba 1f 85 eb 51       	mov    edx,0x51eb851f
 62a:	89 c8                	mov    eax,ecx
 62c:	f7 ea                	imul   edx
 62e:	89 d0                	mov    eax,edx
 630:	c1 f8 07             	sar    eax,0x7
 633:	89 ca                	mov    edx,ecx
 635:	c1 fa 1f             	sar    edx,0x1f
 638:	29 d0                	sub    eax,edx
 63a:	69 d0 90 01 00 00    	imul   edx,eax,0x190
 640:	89 c8                	mov    eax,ecx
 642:	29 d0                	sub    eax,edx
 644:	85 c0                	test   eax,eax
 646:	75 08                	jne    650 <mktime+0x158>
    {
        days_since_1970 += 1;
 648:	83 45 e8 01          	add    DWORD PTR [ebp-0x18],0x1
 64c:	83 55 ec 00          	adc    DWORD PTR [ebp-0x14],0x0
    }

    return t->tm_sec + 60 * (t->tm_min + 60 * (t->tm_hour + 24 * days_since_1970));
 650:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 653:	8b 00                	mov    eax,DWORD PTR [eax]
 655:	89 45 bc             	mov    DWORD PTR [ebp-0x44],eax
 658:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 65b:	8b 40 04             	mov    eax,DWORD PTR [eax+0x4]
 65e:	89 c6                	mov    esi,eax
 660:	89 c7                	mov    edi,eax
 662:	c1 ff 1f             	sar    edi,0x1f
 665:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 668:	8b 40 08             	mov    eax,DWORD PTR [eax+0x8]
 66b:	89 45 b0             	mov    DWORD PTR [ebp-0x50],eax
 66e:	89 c3                	mov    ebx,eax
 670:	c1 fb 1f             	sar    ebx,0x1f
 673:	89 5d b4             	mov    DWORD PTR [ebp-0x4c],ebx
 676:	8b 45 ec             	mov    eax,DWORD PTR [ebp-0x14]
 679:	6b d0 18             	imul   edx,eax,0x18
 67c:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 67f:	6b c0 00             	imul   eax,eax,0x0
 682:	8d 0c 02             	lea    ecx,[edx+eax*1]
 685:	b8 18 00 00 00       	mov    eax,0x18
 68a:	f7 65 e8             	mul    DWORD PTR [ebp-0x18]
 68d:	01 d1                	add    ecx,edx
 68f:	89 ca                	mov    edx,ecx
 691:	03 45 b0             	add    eax,DWORD PTR [ebp-0x50]
 694:	13 55 b4             	adc    edx,DWORD PTR [ebp-0x4c]
 697:	6b da 3c             	imul   ebx,edx,0x3c
 69a:	6b c8 00             	imul   ecx,eax,0x0
 69d:	01 d9                	add    ecx,ebx
 69f:	bb 3c 00 00 00       	mov    ebx,0x3c
 6a4:	f7 e3                	mul    ebx
 6a6:	01 d1                	add    ecx,edx
 6a8:	89 ca                	mov    edx,ecx
 6aa:	01 f0                	add    eax,esi
 6ac:	11 fa                	adc    edx,edi
 6ae:	6b c0 3c             	imul   eax,eax,0x3c
 6b1:	03 45 bc             	add    eax,DWORD PTR [ebp-0x44]
}
 6b4:	83 c4 44             	add    esp,0x44
 6b7:	5b                   	pop    ebx
 6b8:	5e                   	pop    esi
 6b9:	5f                   	pop    edi
 6ba:	5d                   	pop    ebp
 6bb:	c3                   	ret

000006bc <time>:

time_t time(time_t* arg)
{    
 6bc:	55                   	push   ebp
 6bd:	89 e5                	mov    ebp,esp
 6bf:	83 ec 38             	sub    esp,0x38
    struct tm t;
    read_rtc(&t);
 6c2:	83 ec 0c             	sub    esp,0xc
 6c5:	8d 45 d4             	lea    eax,[ebp-0x2c]
 6c8:	50                   	push   eax
 6c9:	e8 87 f9 ff ff       	call   55 <read_rtc>
 6ce:	83 c4 10             	add    esp,0x10

    if(arg != NULL)
 6d1:	83 7d 08 00          	cmp    DWORD PTR [ebp+0x8],0x0
 6d5:	74 14                	je     6eb <time+0x2f>
    {
        memcpy(arg, &t, sizeof(struct tm));
 6d7:	83 ec 04             	sub    esp,0x4
 6da:	6a 24                	push   0x24
 6dc:	8d 45 d4             	lea    eax,[ebp-0x2c]
 6df:	50                   	push   eax
 6e0:	ff 75 08             	push   DWORD PTR [ebp+0x8]
 6e3:	e8 fc ff ff ff       	call   6e4 <time+0x28>
 6e8:	83 c4 10             	add    esp,0x10
    }

    return mktime(&t);
 6eb:	83 ec 0c             	sub    esp,0xc
 6ee:	8d 45 d4             	lea    eax,[ebp-0x2c]
 6f1:	50                   	push   eax
 6f2:	e8 fc ff ff ff       	call   6f3 <time+0x37>
 6f7:	83 c4 10             	add    esp,0x10
}
 6fa:	c9                   	leave
 6fb:	c3                   	ret

000006fc <difftime>:
 
double difftime(time_t time_end, time_t time_start)
{
 6fc:	55                   	push   ebp
 6fd:	89 e5                	mov    ebp,esp
 6ff:	83 ec 08             	sub    esp,0x8
    return time_end - time_start;
 702:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 705:	2b 45 0c             	sub    eax,DWORD PTR [ebp+0xc]
 708:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
 70b:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
 712:	df 6d f8             	fild   QWORD PTR [ebp-0x8]
}
 715:	c9                   	leave
 716:	c3                   	ret

00000717 <asctime>:

char* asctime(const struct tm* time_ptr)
{
 717:	55                   	push   ebp
 718:	89 e5                	mov    ebp,esp

    // char buffer[26];

    // Www Mmm dd hh:mm:ss yyyy\n

    return NULL;
 71a:	b8 00 00 00 00       	mov    eax,0x0
}
 71f:	5d                   	pop    ebp
 720:	c3                   	ret

00000721 <localtime>:

struct tm* localtime(const time_t* timer)
{
 721:	55                   	push   ebp
 722:	89 e5                	mov    ebp,esp
 724:	83 ec 30             	sub    esp,0x30
    static struct tm t;

    const unsigned long int SECONDS_PER_DAY   =  24ul * 60ul * 60ul;
 727:	c7 45 fc 80 51 01 00 	mov    DWORD PTR [ebp-0x4],0x15180
    const unsigned long int DAYS_PER_YEAR =    365ul;
 72e:	c7 45 f8 6d 01 00 00 	mov    DWORD PTR [ebp-0x8],0x16d
    const unsigned long int DAYS_PER_4YEARS   =   1461ul;
 735:	c7 45 f4 b5 05 00 00 	mov    DWORD PTR [ebp-0xc],0x5b5
    const unsigned long int DAYS_PER_100YEARS =  36524ul;
 73c:	c7 45 f0 ac 8e 00 00 	mov    DWORD PTR [ebp-0x10],0x8eac
    const unsigned long int DAYS_PER_400YEARS = 146097ul;
 743:	c7 45 ec b1 3a 02 00 	mov    DWORD PTR [ebp-0x14],0x23ab1
    const unsigned long int TAGN_AD_1970_01_01 = 719468ul;
 74a:	c7 45 e8 6c fa 0a 00 	mov    DWORD PTR [ebp-0x18],0xafa6c

    unsigned long int TagN = TAGN_AD_1970_01_01 + *timer / SECONDS_PER_DAY;
 751:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 754:	8b 00                	mov    eax,DWORD PTR [eax]
 756:	ba 00 00 00 00       	mov    edx,0x0
 75b:	f7 75 fc             	div    DWORD PTR [ebp-0x4]
 75e:	89 c2                	mov    edx,eax
 760:	8b 45 e8             	mov    eax,DWORD PTR [ebp-0x18]
 763:	01 d0                	add    eax,edx
 765:	89 45 e4             	mov    DWORD PTR [ebp-0x1c],eax
    unsigned long int seconds_since_midnight = *timer % SECONDS_PER_DAY;
 768:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 76b:	8b 00                	mov    eax,DWORD PTR [eax]
 76d:	ba 00 00 00 00       	mov    edx,0x0
 772:	f7 75 fc             	div    DWORD PTR [ebp-0x4]
 775:	89 55 e0             	mov    DWORD PTR [ebp-0x20],edx
    unsigned long int temp;

    temp = 4 * (TagN + DAYS_PER_100YEARS + 1) / DAYS_PER_400YEARS - 1;
 778:	8b 55 e4             	mov    edx,DWORD PTR [ebp-0x1c]
 77b:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
 77e:	01 d0                	add    eax,edx
 780:	83 c0 01             	add    eax,0x1
 783:	c1 e0 02             	shl    eax,0x2
 786:	ba 00 00 00 00       	mov    edx,0x0
 78b:	f7 75 ec             	div    DWORD PTR [ebp-0x14]
 78e:	83 e8 01             	sub    eax,0x1
 791:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
    t.tm_year = 100 * temp;
 794:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
 797:	6b c0 64             	imul   eax,eax,0x64
 79a:	a3 34 00 00 00       	mov    ds:0x34,eax
    TagN -= DAYS_PER_100YEARS * temp + temp / 4;
 79f:	8b 45 f0             	mov    eax,DWORD PTR [ebp-0x10]
 7a2:	0f af 45 dc          	imul   eax,DWORD PTR [ebp-0x24]
 7a6:	89 c2                	mov    edx,eax
 7a8:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
 7ab:	c1 e8 02             	shr    eax,0x2
 7ae:	01 d0                	add    eax,edx
 7b0:	29 45 e4             	sub    DWORD PTR [ebp-0x1c],eax

    temp = 4 * (TagN + DAYS_PER_YEAR + 1) / DAYS_PER_4YEARS - 1;
 7b3:	8b 55 e4             	mov    edx,DWORD PTR [ebp-0x1c]
 7b6:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
 7b9:	01 d0                	add    eax,edx
 7bb:	83 c0 01             	add    eax,0x1
 7be:	c1 e0 02             	shl    eax,0x2
 7c1:	ba 00 00 00 00       	mov    edx,0x0
 7c6:	f7 75 f4             	div    DWORD PTR [ebp-0xc]
 7c9:	83 e8 01             	sub    eax,0x1
 7cc:	89 45 dc             	mov    DWORD PTR [ebp-0x24],eax
    t.tm_year += temp;
 7cf:	a1 34 00 00 00       	mov    eax,ds:0x34
 7d4:	89 c2                	mov    edx,eax
 7d6:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
 7d9:	01 d0                	add    eax,edx
 7db:	a3 34 00 00 00       	mov    ds:0x34,eax
    TagN -= DAYS_PER_YEAR * temp + temp / 4;
 7e0:	8b 45 f8             	mov    eax,DWORD PTR [ebp-0x8]
 7e3:	0f af 45 dc          	imul   eax,DWORD PTR [ebp-0x24]
 7e7:	89 c2                	mov    edx,eax
 7e9:	8b 45 dc             	mov    eax,DWORD PTR [ebp-0x24]
 7ec:	c1 e8 02             	shr    eax,0x2
 7ef:	01 d0                	add    eax,edx
 7f1:	29 45 e4             	sub    DWORD PTR [ebp-0x1c],eax
    t.tm_mon = (5 * TagN + 2) / 153;
 7f4:	8b 55 e4             	mov    edx,DWORD PTR [ebp-0x1c]
 7f7:	89 d0                	mov    eax,edx
 7f9:	c1 e0 02             	shl    eax,0x2
 7fc:	01 d0                	add    eax,edx
 7fe:	83 c0 02             	add    eax,0x2
 801:	ba d7 80 2b d6       	mov    edx,0xd62b80d7
 806:	f7 e2                	mul    edx
 808:	89 d0                	mov    eax,edx
 80a:	c1 e8 07             	shr    eax,0x7
 80d:	a3 30 00 00 00       	mov    ds:0x30,eax
    t.tm_mday = TagN - (t.tm_mon * 153 + 2) / 5 + 1;
 812:	a1 30 00 00 00       	mov    eax,ds:0x30
 817:	69 c0 99 00 00 00    	imul   eax,eax,0x99
 81d:	8d 48 02             	lea    ecx,[eax+0x2]
 820:	ba 67 66 66 66       	mov    edx,0x66666667
 825:	89 c8                	mov    eax,ecx
 827:	f7 ea                	imul   edx
 829:	89 d0                	mov    eax,edx
 82b:	d1 f8                	sar    eax,1
 82d:	c1 f9 1f             	sar    ecx,0x1f
 830:	89 ca                	mov    edx,ecx
 832:	29 d0                	sub    eax,edx
 834:	89 c2                	mov    edx,eax
 836:	8b 45 e4             	mov    eax,DWORD PTR [ebp-0x1c]
 839:	29 d0                	sub    eax,edx
 83b:	83 c0 01             	add    eax,0x1
 83e:	a3 2c 00 00 00       	mov    ds:0x2c,eax
    t.tm_mon += 3;
 843:	a1 30 00 00 00       	mov    eax,ds:0x30
 848:	83 c0 03             	add    eax,0x3
 84b:	a3 30 00 00 00       	mov    ds:0x30,eax
    if (t.tm_mon > 12)
 850:	a1 30 00 00 00       	mov    eax,ds:0x30
 855:	83 f8 0c             	cmp    eax,0xc
 858:	7e 1a                	jle    874 <localtime+0x153>
    {
        t.tm_mon -= 12;
 85a:	a1 30 00 00 00       	mov    eax,ds:0x30
 85f:	83 e8 0c             	sub    eax,0xc
 862:	a3 30 00 00 00       	mov    ds:0x30,eax
        ++t.tm_year;
 867:	a1 34 00 00 00       	mov    eax,ds:0x34
 86c:	83 c0 01             	add    eax,0x1
 86f:	a3 34 00 00 00       	mov    ds:0x34,eax
    }

    t.tm_hour  = seconds_since_midnight / 3600;
 874:	8b 45 e0             	mov    eax,DWORD PTR [ebp-0x20]
 877:	ba c5 b3 a2 91       	mov    edx,0x91a2b3c5
 87c:	f7 e2                	mul    edx
 87e:	89 d0                	mov    eax,edx
 880:	c1 e8 0b             	shr    eax,0xb
 883:	a3 28 00 00 00       	mov    ds:0x28,eax
    t.tm_min = seconds_since_midnight % 3600 / 60;
 888:	8b 4d e0             	mov    ecx,DWORD PTR [ebp-0x20]
 88b:	ba c5 b3 a2 91       	mov    edx,0x91a2b3c5
 890:	89 c8                	mov    eax,ecx
 892:	f7 e2                	mul    edx
 894:	89 d0                	mov    eax,edx
 896:	c1 e8 0b             	shr    eax,0xb
 899:	69 d0 10 0e 00 00    	imul   edx,eax,0xe10
 89f:	89 c8                	mov    eax,ecx
 8a1:	29 d0                	sub    eax,edx
 8a3:	ba 89 88 88 88       	mov    edx,0x88888889
 8a8:	f7 e2                	mul    edx
 8aa:	89 d0                	mov    eax,edx
 8ac:	c1 e8 05             	shr    eax,0x5
 8af:	a3 24 00 00 00       	mov    ds:0x24,eax
    t.tm_sec = seconds_since_midnight        % 60;
 8b4:	8b 4d e0             	mov    ecx,DWORD PTR [ebp-0x20]
 8b7:	ba 89 88 88 88       	mov    edx,0x88888889
 8bc:	89 c8                	mov    eax,ecx
 8be:	f7 e2                	mul    edx
 8c0:	89 d0                	mov    eax,edx
 8c2:	c1 e8 05             	shr    eax,0x5
 8c5:	6b d0 3c             	imul   edx,eax,0x3c
 8c8:	89 c8                	mov    eax,ecx
 8ca:	29 d0                	sub    eax,edx
 8cc:	a3 20 00 00 00       	mov    ds:0x20,eax

    return &t;
 8d1:	b8 20 00 00 00       	mov    eax,0x20
 8d6:	c9                   	leave
 8d7:	c3                   	ret
