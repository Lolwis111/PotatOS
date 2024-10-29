#include "stdio.h"
#include "serial.h"
#include "string.h"
#include "stdint.h"
#include "io.h"

uint8_t screenX = 0, screenY = 0;
char global_color = 0x07;

void setColor(uint8_t c)
{
    uint8_t l = c & 0xF;
    uint8_t h = (c >> 4) & 0xF;

    if(l != h) global_color = c;
}

void _asm_moveBuffer()
{
    char* dest = (char*)0x000B8000;
    char* src = dest + (screenX * 2);

    uint32_t size = (screenX * screenY * 2) - (screenX * 2);

    for(uint32_t i = 0; i < size; i++)
    {
        *dest = *src;
        src++;
        dest++;
    }

    screenY = 23;
}

void _putchar(char c, uint8_t color)
{
    uint32_t offset = (screenY * 160) + (screenX * 2);
    uint32_t addr = 0x000B8000;

    switch(c)
    {
        case '\r':
        {
            screenX = 0;
            break;
        }
        case '\n':
        {
            screenY++;
            break;
        }
        default:
        {
            char* ptr = (char*)(addr+offset);
            *ptr = c;
            *(ptr+1) = color;

            screenX++;

            break;
        }
    }

    if(screenX == 80)
    {
        screenX = 0;
        screenY++;
    }

    if(screenY >= 23)
    {
        screenY = 23;
        _asm_moveBuffer();
    }
}

void putchar(char c, uint8_t color)
{
    _putchar(c, color);

    setCursorPosition(screenX, screenY);
}


static int printstring(const char* str)
{
    int i = 0;
    while(*str)
    {
        _putchar(*str, global_color);
        str++;
        i++;
    }
    setCursorPosition(screenX, screenY);

    return i;
}

int puts(const char* str)
{
    int i = printstring(str);
    putchar('\r', global_color);
    putchar('\n', global_color);
    return i+2;
}


static void itoa(int num, char* buf, int base)
{
    int neg = 0;
    int i = 0;

    if (num == 0)
    {
        buf[0] = '0';
        buf[1] = 0;
        return;
    }

    if(num < 0 && base == 10)
    {
        num = -num;
        neg = 1;
    }

    while(num != 0)
    {
        int r = num % base;
        buf[i++] = (r > 9) ? (r - 10) + 'a' : r + '0';
        num = num / base;
    }

    if(neg > 0)
    {
        buf[i] = '-';
        i++;
    }

    int start = 0;
    int end = i - 1;
    while(start < end)
    {
        char t = buf[start];
        buf[start] = buf[end];
        buf[end] = t;
        end--;
        start++;
    }

    buf[i] = 0;
}

int vsprintf(char* dest, const char* format, __builtin_va_list val)
{
    size_t len = 0;
    char buffer[20];

    char* ptr = dest;

    while(*format)
    {
        if(*format == '%')
        {
            format++;

            int align = 0;
            while(*format >= '0' && *format <= '9')
            {
                align *= 10;
                align += (*format) - '0';
            }

            switch (*format)
            {
                case 'd':
                case 'i':
                {
                    int i = __builtin_va_arg(val, int);

                    itoa(i, buffer, 10);

                    len += strlen(buffer);

                    if(ptr != NULL) strcat(ptr, buffer);
                    break;
                }
                case 'o':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoa(i, buffer, 8);

                    len += strlen(buffer);

                    if(ptr != NULL) strcat(ptr, buffer);
                    break;
                }
                case 'x':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoa(i, buffer, 16);

                    len += strlen(buffer);

                    if(ptr != NULL) strcat(ptr, buffer);
                    break;
                }
                case 's':
                {
                    char* str = __builtin_va_arg(val, char*);

                    len += strlen(str);

                    if(ptr != NULL) strcat(ptr, str);
                    break;
                }
                case 'c':
                {
                    char c = (char)__builtin_va_arg(val, int);
                    // putchar(c, global_color);

                    buffer[0] = c;
                    buffer[1] = '\0';

                    len++;

                    if(ptr != NULL) ptr = strcat(ptr, buffer);

                    break;
                }
                case '%':
                {
                    putchar('%', global_color);
                    buffer[0] = '%';
                    buffer[1] = '\0';

                    len++;

                    if(ptr != NULL) strcat(ptr, buffer);

                    break;
                }
                
            }
        }
        else
        {
            buffer[0] = *format;
            buffer[1] = '\0';

            len++;

            if(ptr != NULL) strcat(ptr, buffer);
        }

        format++;
    }

    return len;
}

int sprintf(char* dest, const char* format, ...)
{
    __builtin_va_list val;

    __builtin_va_start(val, format);

   int l = vsprintf(dest, format, val);

    __builtin_va_end(val);

    return l;
}

int printf(const char* format, ...)
{
    __builtin_va_list val;

    __builtin_va_start(val, format);

    int l = vsprintf(NULL, format, val);

    char buffer[l + 1];

    l = vsprintf(buffer, format, val);

    printstring(buffer);

    __builtin_va_end(val);

    return l;
}

uint8_t readkey()
{
    while ((inportb(STATUS_PORT) & 0x01) == 0) writeSerial('!');

    return inportb(DATA_PORT);
}

static void sendPS2Command(uint8_t command)
{
    while ((inportb(STATUS_PORT) & 0x02) > 0);

    outportb(COMMAND_PORT, command);
}

void initKeyboard()
{
    sendPS2Command(0xAD);

    inportb(DATA_PORT);

    sendPS2Command(0xAE);
}

static int shift = 0;
static char lowerCaseMap[256] = {
    0x00, 0x00, '1','2','3','4','5','6','7','8','9','0','-','=', 
    0x08, 0x09, 'q','w','e','r','t','y','u','i','o','p','[',']', 
    0x0A, 0x00, 'a','s','d','f','g','h','j','k','l', 0x3B, 0x27, 
    '`', 0x00, '\\','z','x','c','v','b','n','m',',','.','/'
};
static char upperCaseMap[256] = {
    0x00, 0x00, '!', '@', '#', '$', '\%', '^', '&', '*', '(', ')', '_', '+', 0x08, 0x09,
    'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0x0A, 0x00, 'A','S',
    'D','F','G','H','J','K','L',':', 0x22, '~', 0x00, 0x7C, 'Z','X','C',
    'V','B','N','M','<','>','?'
};

static void _readChar(KEY_S* k)
{
    uint8_t code = readkey();

    writeSerial(code);

    k->scancode = code;
    k->ascii = 0;

    switch (k->scancode)
    {
        case LEFT_SHIFT_DOWN:
        case RIGHT_SHIFT_DOWN:
        {
            shift = 1;
            break;
        }
        case LEFT_SHIFT_UP:
        case RIGHT_SHIFT_UP:
        {
            shift = 0;
            break;
        }
        case 0x39:
        {
            k->ascii = ' ';
            break;
        }
        default:
        {
            if(shift == 1)
            {
                k->ascii = upperCaseMap[k->scancode];
            }
            else
            {
                k->ascii = lowerCaseMap[k->scancode];
            }
            break;
        }
    }
}

char readChar()
{
    KEY_S k = { .ascii = 0, .scancode = 0 };
    _readChar(&k);
    return k.ascii;
}

int readLine(char* buffer, int length)
{
    int counter = 0;
    while(1)
    {
        KEY_S k = { .ascii = 0, .scancode = 0 };
        _readChar(&k);

        if(k.scancode == KEY_ENTER)
        {
            *(buffer+counter) = 0;
            return counter;
        }

        if(k.scancode == KEY_BACKSPACE)
        {
            if(counter > 0)
            {
                counter--;
                screenX--;
                putchar(' ', global_color);

                screenX--;
                setCursorPosition(screenX, screenY);

                *(buffer+counter) = 0;
            }
        }
        else if(k.ascii == 0)
        {
            // ignore
        }
        else 
        {
            if(counter < length-1)
            {
                *(buffer+counter) = k.ascii;
                counter++;
                putchar(k.ascii, global_color);
            }
        }
    }

    return 0;
}

void setCursorPosition(int x, int y)
{
    if(x < 0) x = 0;
    if(x > 79) x = 79;
    if(y < 0) y = 0;
    if(y > 24) y = 24;

    screenX = x;
    screenY = y;

    uint16_t pos = y * 80 + x;

    outportb(0x3D4, 0x0F);
    outportb(0x3D5, (unsigned char)(pos & 0xFF));
    outportb(0x3D4, 0x0E);
    outportb(0x3D5, (unsigned char)((pos >> 8) & 0xFF));
}