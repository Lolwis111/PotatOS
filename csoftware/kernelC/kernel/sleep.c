#include "sleep.h"
#include "asm.h"
#include "pic.h"

static volatile int sleepCounter = 0;

__attribute__((interrupt)) void timer_isr(struct interrupt_frame* frame)
{
    if(sleepCounter > 0)
    {
        sleepCounter--;
    }

    PIC_sendEOI(0);
}

void setTimer(int hz)
{
    int divisor = 1193180 / hz;       /* Calculate our divisor */
    outportb(0x43, 0x34);             /* Set our command byte 0x34 */
    io_wait();
    outportb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
    io_wait();
    outportb(0x40, divisor >> 8);     /* Set high byte of divisor */
}

void sleep(int time)
{
    sleepCounter = time;

    while (sleepCounter > 0)
    {
        hlt();
    }
}