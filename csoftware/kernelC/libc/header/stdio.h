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

typedef struct KEY_S {
    char ascii;
    unsigned char scancode;
} KEY_S;

int putchar(char ch);
void putchar_c(char c, uint8_t color);
int puts(const char* str);

int sprintf(char* dest, const char* format, ...);
int printf(const char* format, ...);

void setCursorPosition(int x, int y);

char* gets(char* str);

int getchar(void);

// void sleep(int ms);
void setColor(uint8_t c);

void initKeyboard();

#endif