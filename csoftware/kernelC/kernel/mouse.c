#include "mouse.h"
#include "ps2.h"
#include "asm.h"
#include "printk.h"
#include "pic.h"

void initMouse(void)
{
    sendPS2Command(0xA7);

    inportb(0x60);

    sendPS2Command(0xA8);

    sendPS2Command(0x20);
    uint8_t status = inportb(0x60) | 2;
    sendPS2Command(0x60);
    
    sendPS2Command(status);
}

__attribute__((interrupt)) void mouse_irq(struct interrupt_frame* frame)
{
    inportb(0x60);
    printk("m");

    PIC_sendEOI(12);
}