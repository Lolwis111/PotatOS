#include "helper.h"

void farWrite_byte(short segment, short offset, char data)
{
    asm volatile(
        "mov %%ax, %%gs;"
        "movb %%dl, %%gs:(%%bx);"
        :
        : "a"(segment), "b"(offset), "d"(data)
        :
        );
}

void farWrite_word(short segment, short offset, short data)
{
    asm volatile(
        "mov %%ax, %%gs;"
        "movw %%dx, %%gs:(%%bx);"
        :
        : "a"(segment), "b"(offset), "d"(data)
        :
        );
}

void farWrite_dword(short segment, short offset, int data)
{
    asm volatile(
        "mov %%ax, %%gs;"
        "movl %%edx, %%gs:(%%bx);"
        :
        : "a"(segment), "b"(offset), "d"(data)
        :
        );
}

char farRead_byte(short segment, short offset)
{
    char data;
    asm volatile(
        "mov %%ax, %%gs;"
        "movb %%gs:(%%bx), %%dl;"
        : "=d"(data)
        : "a"(segment), "b"(offset)
        :
        );
    return data;
}

short farRead_word(short segment, short offset)
{
    short data;
    asm volatile(
        "mov %%ax, %%gs;"
        "movb %%gs:(%%bx), %%dx;"
        : "=d"(data)
        : "a"(segment), "b"(offset)
        :
        );
    return data;
}

int farRead_dword(short segment, short offset)
{
    int data;
    asm volatile(
        "mov %%ax, %%gs;"
        "movb %%gs:(%%bx), %%edx;"
        : "=d"(data)
        : "a"(segment), "b"(offset)
        :
        );
    return data;
}

int getLinearAddress(short segment, short offset)
{
    return (segment << 4) + offset;
}

void getSegmentOffsetAddress(int linear, short* segment, short* offset)
{
    offset = (linear & 0x0000FFFF);

    segment = (short)((linear & 0xFFFF0000) >> 16);
}