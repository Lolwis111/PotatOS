#include "ctype.h"

int isspace(int ch)
{
    unsigned char c = (unsigned char)ch;

    if(c == 0x20 || c == 0x0C || c == 0x0A || c == 0x0D || c == 0x09 || c == 0x0B)
    {
        return 1;
    }

    return 0;
}

int tolower(int ch)
{
    unsigned char c = (unsigned char)ch;

    if(c >= 'A' && c <= 'Z')
    {
        return (c | 0x80);
    }

    return c;
}

int toupper(int ch)
{
    unsigned char c = (unsigned char)ch;

    if(c >= 'a' && c <= 'z')
    {
        return (c ^ 0x80);
    }

    return c;
}