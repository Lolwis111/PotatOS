#include "stdbool.h"
#include "printk.h"
#include "ctype.h"
#include "console.h"
#include "stdint.h"
#include "stddef.h"

static char* strcpy(char *dest, const char *src)
{
    int i = 0;
    while(1)
    {
        dest[i] = src[i];

        if(dest[i] == '\0')
        {
            break;
        }

        i++;
    }

    return dest;
}

static char* strcat(char* dest, const char* src)
{
    char* ptr = dest;

    while(*ptr != '\0') ptr++;

    strcpy(ptr, src);

    return dest;
}

static int strlen(const char* str)
{    
    int i;
    for(i = 0; *str; i++, str++) ;
    return i;
}

static void itoa(long num, char* buf, int base)
{
    long neg = 0;
    long i = 0;

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
        long r = num % base;        
        buf[i] = (r > 9) ? (r - 10) + 'a' : r + '0';

        i++;

        num = num / base;
    }

    if(neg > 0)
    {
        buf[i] = '-';
        i++;
    }

    long start = 0;
    long end = i - 1;
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

int vsprintk(char* dest, const char* format, __builtin_va_list val)
{
    size_t len = 0;
    char buffer[32];

    char* ptr = dest;
    *ptr = '\0';

    while(*format)
    {
        if(*format == '%')
        {
            format++;

            int neg = 1;

            if(*format == '-')
            {
                neg = -1;
                format++;
            }

            int align = 0;
            while(*format >= '0' && *format <= '9')
            {
                align *= 10;
                align += (*format) - '0';
            }

            align *= neg;

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

                    buffer[0] = c;
                    buffer[1] = '\0';

                    len++;

                    if(ptr != NULL) ptr = strcat(ptr, buffer);

                    break;
                }
                case 'p':
                {
                    void* ptr = __builtin_va_arg(val, void*);

                    unsigned int i = (unsigned int)ptr;

                    itoa(i, buffer, 16);

                    len += strlen(buffer);

                    if(ptr != NULL) strcat(ptr, buffer);
                    break;
                }
                case '%':
                {
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

int printk(const char* format, ...)
{
    __builtin_va_list val;

    __builtin_va_start(val, format);

    int l = vsprintk(NULL, format, val);

    char buffer[l + 1];

    l = vsprintk(buffer, format, val);

    printstring(buffer);

    __builtin_va_end(val);

    return l;
}