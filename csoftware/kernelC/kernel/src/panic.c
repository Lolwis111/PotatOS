#include "panic.h"
#include "printk.h"
#include "asm.h"

__attribute__((noreturn))
void panic(const char* message)
{
    printk("\r\n\n -- KERNEL PANIC --\r\n\n%s\r\n\nSYSTEM HALT.", message);   
    cli();
    hlt();
    while(1);
}