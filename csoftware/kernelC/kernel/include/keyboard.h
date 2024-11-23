#ifndef _KEYBOARD_H_
#define _KEYBOARD_H_

#include "irq_isr.h"

#define STATUS_PORT 0x64
#define COMMAND_PORT 0x64
#define DATA_PORT 0x60

#define LEFT_SHIFT_DOWN  0x2A
#define RIGHT_SHIFT_DOWN 0x36
#define LEFT_SHIFT_UP    0xAA
#define RIGHT_SHIFT_UP   0xB6
#define KEY_ENTER 0x1C
#define KEY_BACKSPACE 0x0E

#define KB_BUFFER_SIZE 16

__attribute__((interrupt)) void keyboard_isr(struct interrupt_frame* frame);

char getch(void);

void initKeyboard(void);

#endif