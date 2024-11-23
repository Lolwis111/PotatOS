#include "console.h"
#include "stddef.h"
#include "stdint.h"
#include "asm.h"

static uint8_t screenX = 0;
static uint8_t screenY = 0;
static char global_color = 0x07;

void clearScreenC(char color)
{
    global_color = color;
    
    const uint16_t value = (color << 8) | 0x20;

    asm volatile(
        "movw %0, %%ax;\n"
        "movl $2000, %%ecx;\n"
        "movl $0xB8000,%%edi;\n"
        "rep stosw;\n"
        : 
        : "r"(value)
        : "memory", "eax", "ecx", "edi"
    );

    setCursorPosition(0, 0);
}

void clearScreen()
{
    clearScreenC(global_color);
}

static void moveBuffer()
{
    setCursorPosition(screenX, SCREEN_HEIGHT - 2);

    char* vmem = (char*)0x000B8000;
    char* dest = vmem;
    char* src = dest + (SCREEN_WIDTH * 2);

    const uint32_t size = SCREEN_BUFFER_SIZE - (SCREEN_WIDTH * 2);

    // for(uint32_t i = 0; i < size; i++)
    // {
    //     *dest = *src;
    //     src++;
    //     dest++;
    // }

    asm volatile(
        "movl %0, %%ecx;\n"
        "movl %1,%%esi;\n"
        "movl %2,%%edi;\n"
        "rep movsw;\n"
        : 
        : "ri"(size), "ri"(src), "ri"(dest)
        : "memory", "ecx", "esi", "edi"
    );
    
    uint16_t value = (global_color << 8) | 0x20;

    char* end = vmem + SCREEN_BUFFER_SIZE - (SCREEN_WIDTH * 2);

    asm volatile(
        "movw %0, %%ax;\n"
        "movl %1, %%ecx;\n"
        "movl %2,%%edi;\n"
        "rep stosw;\n"
        : 
        : "ri"(value), "ri"(SCREEN_WIDTH), "ri"(end)
        : "memory", "ax", "ecx", "edi"
    );

    // for(uint32_t i = 0; i < (SCREEN_WIDTH); i++)
    // {
    //     *end = ' ';
    //     end++;
    //     *end = global_color;
    //     end++;
    // }
}

int printstring(const char* str)
{
    int i = 0;
    while(*str)
    {
        putchar(*str, global_color);
        str++;
        i++;
    }
    setCursorPosition(screenX, screenY);

    return i;
}

void putchar(char c, uint8_t color)
{
    uint32_t offset = (screenY * (SCREEN_WIDTH) * 2) + (screenX * 2);
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

    if(screenX == SCREEN_WIDTH)
    {
        screenX = 0;
        screenY++;
    }

    if(screenY >= (SCREEN_HEIGHT - 1))
    {
        moveBuffer();
    }
}

void getCursorPosition(int* x, int* y)
{
    *x = screenX;
    *y = screenY;
}

void setCursorPosition(int x, int y)
{
    if(x < 0) x = 0;
    if(x > (SCREEN_WIDTH)-1) x = (SCREEN_WIDTH)-1;
    if(y < 0) y = 0;
    if(y > (SCREEN_HEIGHT)-1) y = (SCREEN_HEIGHT)-1;

    screenX = x;
    screenY = y;

    uint16_t pos = y * SCREEN_WIDTH + x;

    outportb(0x3D4, 0x0F);
    outportb(0x3D5, (uint8_t)(pos & 0xFF));
    outportb(0x3D4, 0x0E);
    outportb(0x3D5, (uint8_t)((pos >> 8) & 0xFF));
}