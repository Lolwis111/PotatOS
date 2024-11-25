#ifndef _PS2_H_
#define _PS2_H_

#include "stdint.h"

#define STATUS_PORT 0x64
#define COMMAND_PORT 0x64
#define DATA_PORT 0x60

void sendPS2Command(uint8_t command);

#endif