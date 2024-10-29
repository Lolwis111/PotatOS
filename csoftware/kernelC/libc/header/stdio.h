#ifndef _STDIO_H_
#define _STDIO_H_

#include "stdint.h"

#define STATUS_PORT 0x64
#define COMMAND_PORT 0x64
#define DATA_PORT 0x60

#define LEFT_SHIFT_DOWN  0x2A
#define RIGHT_SHIFT_DOWN 0x36
#define LEFT_SHIFT_UP    0xAA
#define RIGHT_SHIFT_UP   0xB6
#define KEY_ENTER 0x1C
#define KEY_BACKSPACE 0x0E

#define NULL 0

typedef struct KEY_S {
    char ascii;
    unsigned char scancode;
} KEY_S;

// extern void _asm_moveBuffer();
void farWrite_byte(uint16_t segment, uint16_t offset, uint8_t data);
char farRead_byte(uint16_t segment, uint16_t offset);
void putchar(char c, uint8_t color);
int puts(const char* str);

int sprintf(char* dest, const char* format, ...);
int printf(const char* format, ...);

char readChar();
int readLine(char* buffer, int length);
void setCursorPosition(int x, int y);

// void sleep(int ms);
void setColor(uint8_t c);

void initKeyboard();

#endif