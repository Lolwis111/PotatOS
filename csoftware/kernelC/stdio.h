#pragma once

#include "stdint.h"

#define VIDEO_MEMORY_ADDRESS ((char*)0xB8000)
#define SCREEN_WIDTH_TEXT 80
#define SCREEN_HEIGHT_TEXT 25
#define FRAME_BUFFER_SIZE (SCREEN_WIDTH_TEXT * SCREEN_HEIGHT_TEXT * 2)
#define BLACK          0x00
#define BLUE           0x01
#define GREEN          0x02
#define CYAN           0x03
#define RED            0x04
#define MAGENTA        0x05
#define BROWN          0x06
#define WHITE          0x07
#define GREY           0x08
#define BRIGHT_BLUE    0x09
#define BRIGHT_GREEN   0x0A
#define BRIGHT_CYAN    0x0B
#define BRIGHT_RED     0x0C
#define BRIGHT_MAGENTA 0x0D
#define BRIGHT_YELLOW  0x0E
#define BRIGHT_WHITE   0x0F

#define COLOR(F, B) ((B<<4)|F)

void clearScreen(void);
void printChar(char character, uint8_t color);
void print(const char* string, uint8_t color);
void moveCursor(uint8_t x, uint8_t y);
void moveBuffer(void);

void outb(uint16_t port, uint8_t byte);
uint8_t inb(uint16_t port);
