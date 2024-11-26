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

uint32_t pop(void)
{
    unsigned long value;
    asm volatile ("pop %0" : "=r"(value) : : "memory");
    return value;
}

void cli(void)
{
    asm volatile("cli;":::);
}

void sti(void)
{
    asm volatile("sti;":::);
}

void hlt(void)
{
    asm volatile("hlt;":::);
}

void breakpoint(void)
{
    asm volatile("int3;":::);
}

void int80(void)
{
    asm volatile("int $0x80;":::);
}