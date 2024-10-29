#ifndef _IO_H_
#define _IO_H_

#include "stdint.h"

uint8_t inportb (uint16_t _port);
void outportb (uint16_t _port, uint8_t _data);

#endif