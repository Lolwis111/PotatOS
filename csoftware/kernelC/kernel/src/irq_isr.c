#include "irq_isr.h"
#include "pic.h"

__attribute__((interrupt)) void irq2_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8004;

    if(*v == 'C') *v = 'c';
    else *v = 'C';

    PIC_sendEOI(2);
}

__attribute__((interrupt)) void irq3_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8006;

    if(*v == 'D') *v = 'd';
    else *v = 'D';

    PIC_sendEOI(3);
}

__attribute__((interrupt)) void irq4_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8008;

    if(*v == 'E') *v = 'e';
    else *v = 'E';

    PIC_sendEOI(4);
}

__attribute__((interrupt)) void irq5_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB800A;

    if(*v == 'F') *v = 'f';
    else *v = 'F';

    PIC_sendEOI(5);
}

__attribute__((interrupt)) void irq7_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB800E;

    if(*v == 'H') *v = 'h';
    else *v = 'h';

    PIC_sendEOI(7);
}

__attribute__((interrupt)) void irq8_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8010;

    if(*v == 'I') *v = 'i';
    else *v = 'I';

    PIC_sendEOI(8);
}

__attribute__((interrupt)) void irq9_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8012;

    if(*v == 'J') *v = 'j';
    else *v = 'J';

    PIC_sendEOI(9);
}

__attribute__((interrupt)) void irq10_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8014;

    if(*v == 'K') *v = 'k';
    else *v = 'K';

    PIC_sendEOI(10);
}

__attribute__((interrupt)) void irq11_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB8016;

    if(*v == 'L') *v = 'l';
    else *v = 'L';

    PIC_sendEOI(11);
}

__attribute__((interrupt)) void irq13_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB801A;

    if(*v == 'N') *v = 'n';
    else *v = 'N';

    PIC_sendEOI(13);
}

__attribute__((interrupt)) void irq14_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB801C;

    if(*v == 'O') *v = 'o';
    else *v = 'O';

    PIC_sendEOI(14);
}

__attribute__((interrupt)) void irq15_isr(struct interrupt_frame* frame)
{
    char* v = (char*)0xB801E;

    if(*v == 'P') *v = 'p';
    else *v = 'P';

    PIC_sendEOI(15);
}