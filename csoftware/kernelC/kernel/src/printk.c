#include "stdbool.h"
#include "printk.h"
#include "ctype.h"
#include "console.h"
#include "stdint.h"
#include "stddef.h"
#include "string.h"

static void itoak(long num, char* buf, int base, char padding)
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
    else if(padding != 0)
    {
        buf[i] = padding;
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
    if(dest != NULL) *ptr = '\0';

    char filler = ' ';
    char padding = 0;

    while(*format)
    {
        filler = ' ';
        
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
            
            switch(*format)
            {
                case '0':
                {
                    filler = '0';
                    format++;
                    break;
                }
                case '+':
                {
                    padding = '+';
                    format++;
                    break;
                }
                case ' ':
                {
                    padding = ' ';
                    format++;
                    break;
                }
            }

            int align = 0;

            // if(*format == '*')
            // {
            //     int i = __builtin_va_arg(val, int);

            //     if(i < 0)
            //     {
            //         neg = -1;
            //         align = -i;
            //     }
            //     else
            //     {
            //         neg = 1;
            //         align = i;
            //     }

            //     format++;
            // }
            // else
            // {
            while(*format >= '0' && *format <= '9')
            {
                align *= 10;
                align += (*format) - '0';
                format++;
            }
            // }

            // align *= neg;

            switch (*format)
            {
                case 'd':
                case 'i':
                {
                    int i = __builtin_va_arg(val, int);

                    itoak(i, bufferPTR, 10, padding);

                    break;
                }
                case 'u':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoak(i, bufferPTR, 10, padding);

                    break;
                }
                case 'o':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoak(i, bufferPTR, 8, padding);

                    break;
                }
                case 'x':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoak(i, bufferPTR, 16, padding);

                    break;
                }
                case 'X':
                {
                    unsigned int i = __builtin_va_arg(val, unsigned int);

                    itoak(i, bufferPTR, 16, padding);

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

                    align = 8;
                    filler = '0';

                    unsigned int i = (unsigned int)p;

                    itoak(i, bufferPTR, 16, '0');

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

                memset(temp, filler, sizeof(char) * align);
                temp[align] = '\0';

                // for(size_t t = 0; t < align; t++)
                // {
                //     temp[t] = filler;
                // }

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

     __builtin_va_end(val);

    char buffer[l + 1];

    __builtin_va_start(val, format);

    l = vsprintk(buffer, format, val);

    printstring(buffer);

    __builtin_va_end(val);

    return l;
}