#pragma once

#include "stdint.h"

inline void outb(uint16_t port, uint8_t byte)
{
    asm volatile ("out %0, %1" : : "a"(byte), "Nd"(port)); 
}

inline uint8_t inb(uint16_t port)
{
    uint8_t ret;
    asm volatile ("in %1, %0" : "=a"(ret) : "Nd"(port));
    return ret;
}
