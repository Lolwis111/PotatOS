#include "stdio.h"
#include "stdint.h"
#include "os.h"

static char cursorX = 0;
static char cursorY = 0;

void moveCursor(uint8_t x, uint8_t y)
{
    cursorX = x;
    cursorY = y;
    outb(0x03D4, 0x0F);
    outb(0x03D5, x + (80 * y));
    outb(0x03D4, 0x0E);
    outb(0x03D5, 80 * y);
}

void printChar(char character, uint8_t color)
{
    char* videoMemory = VIDEO_MEMORY_ADDRESS;
    videoMemory += 2 * (cursorY * 80 + cursorX);
    *videoMemory = character;
    *(videoMemory+1) = color;

    cursorX++;

    if(cursorX == SCREEN_WIDTH_TEXT - 1)
    {
        cursorY++;
        cursorX = 0;
    }

    if(cursorY == SCREEN_HEIGHT_TEXT)
    {
        moveBuffer();
        cursorY = SCREEN_HEIGHT_TEXT - 1;
    }

    moveCursor(cursorX, cursorY);
}

void print(const char* string, uint8_t color)
{
    while(*string)
    {
        printChar(*string, color);
        string++;
    }
}

void clearScreen(void)
{
    char* videoMemory = VIDEO_MEMORY_ADDRESS;

    int i;
    for(i = 0; i < FRAME_BUFFER_SIZE; i+=2)
    {
        *videoMemory = 0x20;
        videoMemory++;
        *videoMemory = 0x07; 
        videoMemory++;
    }
}

void moveBuffer(void)
{
    char* source = VIDEO_MEMORY_ADDRESS + 160;
    char* dest = VIDEO_MEMORY_ADDRESS;
    int i;
    for(i = 0; i < FRAME_BUFFER_SIZE; i++)
    {
        *dest = *source;
        dest++;
        source++;
    }
}
