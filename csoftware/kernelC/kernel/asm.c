#include "asm.h"

uint8_t inportb (uint16_t _port)
{
    uint8_t rv;
    asm volatile("inb %1, %0" : "=a" (rv) : "dN" (_port));
    return rv;
}

void outportb (uint16_t _port, uint8_t _data)
{
    asm volatile("outb %1, %0" : : "dN" (_port), "a" (_data));
}

void io_wait(void)
{
    outportb(0x80, 0);
}

void cli()
{
    asm volatile("cli;":::);
}

void sti()
{
    asm volatile("sti;":::);
}

void hlt()
{
    asm volatile("hlt;":::);
}

void int3()
{
    asm volatile("int3;":::);
}