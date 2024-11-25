#ifndef _CONSOLE_H_
#define _CONSOLE_H_

#include "stdint.h"

#define SCREEN_WIDTH 80
#define SCREEN_HEIGHT 25
#define SCREEN_BUFFER_SIZE (SCREEN_HEIGHT * SCREEN_WIDTH * 2)

void putchar(char c, uint8_t color);
int printstring(const char* str);
void setCursorPosition(int x, int y);
void getCursorPosition(int* x, int* y);
void clearScreen();
void clearScreenC(char color);
void setColor(char);

#endif