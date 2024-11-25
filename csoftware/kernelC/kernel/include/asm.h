#ifndef _ASM_H_
#define _ASM_H_

#include "stdint.h"

uint8_t inportb (uint16_t _port);
void outportb (uint16_t _port, uint8_t _data);
void io_wait(void);
void cli(void);
void sti(void);
void hlt(void);
void breakpoint(void);
uint32_t pop(void);
void int80(void);

#endif