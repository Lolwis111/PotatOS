#include "userland.h"
#include "asm.h"

void userland_function(void)
{
    while(1)
	{
		int80();
	}
}