#include "stdint.h"
#include "pic.h"
#include "asm.h"

void PIC_remap(int offset1, int offset2)
{
	uint8_t a1, a2;
	
	a1 = inportb(PIC1_DATA);                        // save masks
	a2 = inportb(PIC2_DATA);
	
	outportb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);  // starts the initialization sequence (in cascade mode)
	io_wait();
	outportb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);
	io_wait();
	outportb(PIC1_DATA, offset1);                 // ICW2: Master PIC vector offset
	io_wait();
	outportb(PIC2_DATA, offset2);                 // ICW2: Slave PIC vector offset
	io_wait();
	outportb(PIC1_DATA, 4);                       // ICW3: tell Master PIC that there is a slave PIC at IRQ2 (0000 0100)
	io_wait();
	outportb(PIC2_DATA, 2);                       // ICW3: tell Slave PIC its cascade identity (0000 0010)
	io_wait();
	
	outportb(PIC1_DATA, ICW4_8086);               // ICW4: have the PICs use 8086 mode (and not 8080 mode)
	io_wait();
	outportb(PIC2_DATA, ICW4_8086);
	io_wait();
	
	outportb(PIC1_DATA, a1);   // restore saved masks.
	outportb(PIC2_DATA, a2);
}

void PIC_sendEOI(uint8_t irq)
{
	if(irq >= 8)
		outportb(PIC2_COMMAND,PIC_EOI);
	
	outportb(PIC1_COMMAND,PIC_EOI);
}

void pic_disable(void)
{
    outportb(PIC1_DATA, 0xff);
    outportb(PIC2_DATA, 0xff);
}

void IRQ_set_mask(uint8_t IRQline)
{
    uint16_t port;
    uint8_t value;

    if(IRQline < 8) {
        port = PIC1_DATA;
    } else {
        port = PIC2_DATA;
        IRQline -= 8;
    }
    value = inportb(port) | (1 << IRQline);
    outportb(port, value);        
}

void IRQ_clear_mask(uint8_t IRQline)
{
    uint16_t port;
    uint8_t value;

    if(IRQline < 8)
	{
        port = PIC1_DATA;
    }
	else
	{
        port = PIC2_DATA;
        IRQline -= 8;
    }
    value = inportb(port) & ~(1 << IRQline);
    outportb(port, value);        
}