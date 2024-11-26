#include "ps2.h"
#include "asm.h"

void sendPS2Command(uint8_t command)
{
    while ((inportb(STATUS_PORT) & 0x02) > 0);

    outportb(COMMAND_PORT, command);
}