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

char* strcpy(char* __restrict dest, const char* __restrict src)
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

int memcmp(const void* a, const void* b, size_t n)
{
    unsigned char* ca = (unsigned char*)a; 
    unsigned char* cb = (unsigned char*)b; 

    for(size_t i = 0; i < n; i++)
    {
        if(ca[i] < cb[i])
        {
            return -1;
        }
        else if(ca[i] > cb[i])
        {
            return 1;
        }
    }

    return 0;
}

void* memcpy(void* __restrict dest, const void* __restrict src, size_t n)
{
    unsigned char* csrc = (unsigned char*)src; 
    unsigned char* cdest = (unsigned char*)dest; 

    for (size_t i = 0; i < n; i++)
    {
        cdest[i] = csrc[i]; 
    }

    return dest;
}

void* memmove(void* dest, const void* src, size_t n)
{
    unsigned char* csrc = (unsigned char*)src; 
    unsigned char* cdest = (unsigned char*)dest; 

    if(dest < src)
    {
        for (size_t i = 0; i < n; i++)
        {
            cdest[i] = csrc[i]; 
        }
    }
    else
    {
        for (size_t i = n; i != 0; i--)
        {
            cdest[i - 1] = csrc[i - 1]; 
        }
    }

    return dest;
}

void* memset(void* dest, int ch, size_t n )
{
    unsigned char c = (unsigned char)ch;
    unsigned char* ptr = (unsigned char*)dest;

    for(size_t i = 0; i < n; i++)
    {
        ptr[i] = c;
    }

    return dest;
}