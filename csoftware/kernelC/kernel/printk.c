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

        if(src[i] == '\0')
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

    char filler = ' ';

    while(*format)
    {
        char* bufferPTR = buffer;

        if(*format == '%')
        {
            format++;

            int neg = 1;

            if(*format == '-')
            {
                neg = -1;
                format++;
            }
            else if(*format == '0')
            {
                filler = '0';
                format++;
            }

            int align = 0;
            while(*format >= '0' && *format <= '9')
            {
                align *= 10;
                align += (*format) - '0';
                format++;
            }

            align *= neg;

            switch (*format)
            {
                case 'd':
                case 'i':
                {
                    int i = __builtin_va_arg(val, int);

                    itoa(i, bufferPTR, 10);

                    break;
                }
                case 'o':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoa(i, bufferPTR, 8);

                    break;
                }
                case 'x':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoa(i, bufferPTR, 16);

                    break;
                }
                case 'X':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoa(i, bufferPTR, 16);

                    char* temp = bufferPTR;
                    while(*temp)
                    {
                        *temp = toupper(*temp);
                        temp++;
                    }

                    break;
                }
                case 's':
                {
                    bufferPTR = __builtin_va_arg(val, char*);

                    break;
                }
                case 'c':
                {
                    char c = (char)__builtin_va_arg(val, int);

                    bufferPTR[0] = c;
                    bufferPTR[1] = '\0';

                    break;
                }
                case 'p':
                {
                    void* p = __builtin_va_arg(val, void*);

                    unsigned int i = (unsigned int)p;

                    itoa(i, bufferPTR, 16);

                    break;
                }
                case '%':
                {
                    bufferPTR[0] = '%';
                    bufferPTR[1] = '\0';

                    break;
                }   
            }

            size_t bufferL = strlen(bufferPTR);

            if(bufferL < align)
            {
                char temp[align + 1];
                temp[align] = 0;

                for(int i = 0; i < align; i++)
                {
                    temp[i] = filler;
                }

                if(neg < 0)
                {
                    strcpy(temp, bufferPTR);
                }
                else
                {
                    strcpy(temp + (align - bufferL), bufferPTR);
                }

                len += align;
                if(ptr != NULL) strcat(ptr, temp);
            }
            else
            {
                len += bufferL;
                if(ptr != NULL) strcat(ptr, bufferPTR);
            }
        }
        else
        {
            bufferPTR[0] = *format;
            bufferPTR[1] = '\0';

            len++;

            if(ptr != NULL) strcat(ptr, bufferPTR);
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