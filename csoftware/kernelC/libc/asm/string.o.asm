
string.o:     file format elf32-i386


Disassembly of section .text:

00000000 <strcmp>:
#include "string.h"

int strcmp(const char* str1, const char* str2)
{
   0:	55                   	push   ebp
   1:	89 e5                	mov    ebp,esp
    while(*str1 && (*str1 == *str2))
   3:	eb 08                	jmp    d <strcmp+0xd>
    {
        str1++;
   5:	83 45 08 01          	add    DWORD PTR [ebp+0x8],0x1
        str2++;
   9:	83 45 0c 01          	add    DWORD PTR [ebp+0xc],0x1
    while(*str1 && (*str1 == *str2))
   d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  10:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  13:	84 c0                	test   al,al
  15:	74 10                	je     27 <strcmp+0x27>
  17:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  1a:	0f b6 10             	movzx  edx,BYTE PTR [eax]
  1d:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  20:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  23:	38 c2                	cmp    dl,al
  25:	74 de                	je     5 <strcmp+0x5>
    }

    return (*(const unsigned char*)str1 - *(const unsigned char*)str2);
  27:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  2a:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  2d:	0f b6 d0             	movzx  edx,al
  30:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  33:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  36:	0f b6 c8             	movzx  ecx,al
  39:	89 d0                	mov    eax,edx
  3b:	29 c8                	sub    eax,ecx
}
  3d:	5d                   	pop    ebp
  3e:	c3                   	ret

0000003f <strncmp>:

int strncmp(const char* str1, const char* str2, int n)
{
  3f:	55                   	push   ebp
  40:	89 e5                	mov    ebp,esp
    while(n && *str1 && (*str1 == *str2))
  42:	eb 0c                	jmp    50 <strncmp+0x11>
    {
        str1++;
  44:	83 45 08 01          	add    DWORD PTR [ebp+0x8],0x1
        str2++;
  48:	83 45 0c 01          	add    DWORD PTR [ebp+0xc],0x1
        n--;
  4c:	83 6d 10 01          	sub    DWORD PTR [ebp+0x10],0x1
    while(n && *str1 && (*str1 == *str2))
  50:	83 7d 10 00          	cmp    DWORD PTR [ebp+0x10],0x0
  54:	74 1a                	je     70 <strncmp+0x31>
  56:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  59:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  5c:	84 c0                	test   al,al
  5e:	74 10                	je     70 <strncmp+0x31>
  60:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  63:	0f b6 10             	movzx  edx,BYTE PTR [eax]
  66:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  69:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  6c:	38 c2                	cmp    dl,al
  6e:	74 d4                	je     44 <strncmp+0x5>
    }

    if(n == 0) return 0;
  70:	83 7d 10 00          	cmp    DWORD PTR [ebp+0x10],0x0
  74:	75 07                	jne    7d <strncmp+0x3e>
  76:	b8 00 00 00 00       	mov    eax,0x0
  7b:	eb 16                	jmp    93 <strncmp+0x54>

    return (*(const unsigned char*)str1 - *(const unsigned char*)str2);
  7d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  80:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  83:	0f b6 d0             	movzx  edx,al
  86:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  89:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  8c:	0f b6 c8             	movzx  ecx,al
  8f:	89 d0                	mov    eax,edx
  91:	29 c8                	sub    eax,ecx
}
  93:	5d                   	pop    ebp
  94:	c3                   	ret

00000095 <strlen>:

int strlen(const char* str)
{    
  95:	55                   	push   ebp
  96:	89 e5                	mov    ebp,esp
  98:	83 ec 10             	sub    esp,0x10
    int i;
    for(i = 0; *str; i++, str++) ;
  9b:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
  a2:	eb 08                	jmp    ac <strlen+0x17>
  a4:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
  a8:	83 45 08 01          	add    DWORD PTR [ebp+0x8],0x1
  ac:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  af:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  b2:	84 c0                	test   al,al
  b4:	75 ee                	jne    a4 <strlen+0xf>
    return i;
  b6:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
}
  b9:	c9                   	leave
  ba:	c3                   	ret

000000bb <strcpy>:

char* strcpy( char *dest, const char *src)
{
  bb:	55                   	push   ebp
  bc:	89 e5                	mov    ebp,esp
  be:	83 ec 10             	sub    esp,0x10
    int i = 0;
  c1:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
    while(1)
    {
        dest[i] = src[i];
  c8:	8b 55 fc             	mov    edx,DWORD PTR [ebp-0x4]
  cb:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
  ce:	01 d0                	add    eax,edx
  d0:	8b 4d fc             	mov    ecx,DWORD PTR [ebp-0x4]
  d3:	8b 55 08             	mov    edx,DWORD PTR [ebp+0x8]
  d6:	01 ca                	add    edx,ecx
  d8:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  db:	88 02                	mov    BYTE PTR [edx],al

        if(dest[i] == '\0')
  dd:	8b 55 fc             	mov    edx,DWORD PTR [ebp-0x4]
  e0:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
  e3:	01 d0                	add    eax,edx
  e5:	0f b6 00             	movzx  eax,BYTE PTR [eax]
  e8:	84 c0                	test   al,al
  ea:	74 06                	je     f2 <strcpy+0x37>
        {
            break;
        }

        i++;
  ec:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
        dest[i] = src[i];
  f0:	eb d6                	jmp    c8 <strcpy+0xd>
            break;
  f2:	90                   	nop
    }

    return dest;
  f3:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
}
  f6:	c9                   	leave
  f7:	c3                   	ret

000000f8 <strcat>:

char* strcat(char* dest, const char* src)
{
  f8:	55                   	push   ebp
  f9:	89 e5                	mov    ebp,esp
  fb:	83 ec 10             	sub    esp,0x10
    char* ptr = dest;
  fe:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 101:	89 45 fc             	mov    DWORD PTR [ebp-0x4],eax

    while(*ptr != '\0') ptr++;
 104:	eb 04                	jmp    10a <strcat+0x12>
 106:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
 10a:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 10d:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 110:	84 c0                	test   al,al
 112:	75 f2                	jne    106 <strcat+0xe>

    strcpy(ptr, src);
 114:	ff 75 0c             	push   DWORD PTR [ebp+0xc]
 117:	ff 75 fc             	push   DWORD PTR [ebp-0x4]
 11a:	e8 fc ff ff ff       	call   11b <strcat+0x23>
 11f:	83 c4 08             	add    esp,0x8

    return dest;
 122:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
}
 125:	c9                   	leave
 126:	c3                   	ret

00000127 <memcpy>:

void* memcpy(void* dest, const void* src, size_t numBytes)
{
 127:	55                   	push   ebp
 128:	89 e5                	mov    ebp,esp
 12a:	83 ec 10             	sub    esp,0x10
    char* csrc = (char*)src; 
 12d:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 130:	89 45 f8             	mov    DWORD PTR [ebp-0x8],eax
    char* cdest = (char*)dest; 
 133:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 136:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

    for (size_t i = 0; i < numBytes; i++)
 139:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
 140:	eb 19                	jmp    15b <memcpy+0x34>
    {
        cdest[i] = csrc[i]; 
 142:	8b 55 f8             	mov    edx,DWORD PTR [ebp-0x8]
 145:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 148:	01 d0                	add    eax,edx
 14a:	8b 4d f4             	mov    ecx,DWORD PTR [ebp-0xc]
 14d:	8b 55 fc             	mov    edx,DWORD PTR [ebp-0x4]
 150:	01 ca                	add    edx,ecx
 152:	0f b6 00             	movzx  eax,BYTE PTR [eax]
 155:	88 02                	mov    BYTE PTR [edx],al
    for (size_t i = 0; i < numBytes; i++)
 157:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
 15b:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 15e:	3b 45 10             	cmp    eax,DWORD PTR [ebp+0x10]
 161:	72 df                	jb     142 <memcpy+0x1b>
    }

    return dest;
 163:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
}
 166:	c9                   	leave
 167:	c3                   	ret

00000168 <memset>:

void* memset(void* dest, int ch, size_t count )
{
 168:	55                   	push   ebp
 169:	89 e5                	mov    ebp,esp
 16b:	83 ec 10             	sub    esp,0x10
    char c = (char)ch;
 16e:	8b 45 0c             	mov    eax,DWORD PTR [ebp+0xc]
 171:	88 45 fb             	mov    BYTE PTR [ebp-0x5],al
    char* ptr = (char*)dest;
 174:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 177:	89 45 f4             	mov    DWORD PTR [ebp-0xc],eax

    for(size_t i = 0; i < count; i++)
 17a:	c7 45 fc 00 00 00 00 	mov    DWORD PTR [ebp-0x4],0x0
 181:	eb 12                	jmp    195 <memset+0x2d>
    {
        ptr[i] = c;
 183:	8b 55 f4             	mov    edx,DWORD PTR [ebp-0xc]
 186:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 189:	01 c2                	add    edx,eax
 18b:	0f b6 45 fb          	movzx  eax,BYTE PTR [ebp-0x5]
 18f:	88 02                	mov    BYTE PTR [edx],al
    for(size_t i = 0; i < count; i++)
 191:	83 45 fc 01          	add    DWORD PTR [ebp-0x4],0x1
 195:	8b 45 fc             	mov    eax,DWORD PTR [ebp-0x4]
 198:	3b 45 10             	cmp    eax,DWORD PTR [ebp+0x10]
 19b:	72 e6                	jb     183 <memset+0x1b>
    }

    return dest;
 19d:	8b 45 08             	mov    eax,DWORD PTR [ebp+0x8]
 1a0:	c9                   	leave
 1a1:	c3                   	ret
