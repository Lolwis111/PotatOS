#include "stdio.h"
#include "stdint.h"

void main()
{
    moveCursor(0, 0);

    for(char c = 32; c < 128; c++)
    {
        printChar(c, (uint8_t)c);
    }

    while(1);
}
