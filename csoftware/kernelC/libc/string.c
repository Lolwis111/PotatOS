#include "string.h"

int strcmp(const char* str1, const char* str2)
{
    while(*str1 && (*str1 == *str2))
    {
        str1++;
        str2++;
    }

    return (*(const unsigned char*)str1 - *(const unsigned char*)str2);
}

int strncmp(const char* str1, const char* str2, int n)
{
    while(n && *str1 && (*str1 == *str2))
    {
        str1++;
        str2++;
        n--;
    }

    if(n == 0) return 0;

    return (*(const unsigned char*)str1 - *(const unsigned char*)str2);
}

int strlen(const char* str)
{    
    int i;
    for(i = 0; *str; i++, str++) ;
    return i;
}

char* strcpy( char *dest, const char *src)
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

char* strcat(char* dest, const char* src)
{
    char* ptr = dest;

    while(*ptr != '\0') ptr++;

    strcpy(ptr, src);

    return dest;
}

void* memcpy(void* dest, const void* src, size_t numBytes)
{
    char* csrc = (char*)src; 
    char* cdest = (char*)dest; 

    for (size_t i = 0; i < numBytes; i++)
    {
        cdest[i] = csrc[i]; 
    }

    return dest;
}

void* memset(void* dest, int ch, size_t count )
{
    char c = (char)ch;
    char* ptr = (char*)dest;

    for(size_t i = 0; i < count; i++)
    {
        ptr[i] = c;
    }

    return dest;
}