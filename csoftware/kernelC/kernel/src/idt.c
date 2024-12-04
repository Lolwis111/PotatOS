#include "stdint.h"
#include "stdbool.h"
#include "idt.h"
#include "exceptions_isr.h"
#include "paging.h"

__attribute__((aligned(0x10))) 
static idt_entry_t idt[256]; // Create an array of IDT entries; aligned for performance

typedef struct {
	uint16_t	limit;
	uint32_t	base;
} __attribute__((packed)) idtr_t;

static idtr_t idtr;
static bool vectors[256];

void idt_set_descriptor(uint8_t vector, void* isr, uint8_t flags)
{
    idt_entry_t* descriptor = &idt[vector];

    descriptor->isr_low        = (uint32_t)isr & 0xFFFF;
    descriptor->kernel_cs      = 0x08; // this value can be whatever offset your kernel code selector is in your GDT
    descriptor->attributes     = flags;
    descriptor->isr_high       = (uint32_t)isr >> 16;
    descriptor->reserved       = 0;
}

void idt_init()
{
    idtr.base = (uint32_t)&idt[0];
    idtr.limit = (uint16_t)sizeof(idt_entry_t) * 256 - 1;

    for (uint8_t vector = 0; vector < 32; vector++)
    {
        vectors[vector] = true;
    }

    idt_set_descriptor(0, &div_zero_exception, 0x8E);
    idt_set_descriptor(1, &exception1_isr, 0x8E);
    idt_set_descriptor(2, &nmi_isr, 0x8E);
    idt_set_descriptor(3, &debugger_isr, 0x8F);
    idt_set_descriptor(4, &exception4_isr, 0x8E);
    idt_set_descriptor(5, &exception5_isr, 0x8E);
    idt_set_descriptor(6, &invalid_op_exception, 0x8E);
    idt_set_descriptor(7, &exception7_isr, 0x8E);
    idt_set_descriptor(8, &double_fault_exception, 0x8E);
    idt_set_descriptor(9, &exception9_isr, 0x8E);

    idt_set_descriptor(10, &exception10_isr, 0x8E);
    idt_set_descriptor(11, &exception11_isr, 0x8E);
    idt_set_descriptor(12, &exception12_isr, 0x8E);
    idt_set_descriptor(13, &exception_gpf_isr, 0x8E);
    idt_set_descriptor(14, &pagefault_isr, 0x8E);
    idt_set_descriptor(15, &exception15_isr, 0x8E);
    idt_set_descriptor(16, &exception16_isr, 0x8E);
    idt_set_descriptor(17, &exception17_isr, 0x8E);
    idt_set_descriptor(18, &exception18_isr, 0x8E);
    idt_set_descriptor(19, &exception19_isr, 0x8E);

    idt_set_descriptor(20, &exception20_isr, 0x8E);
    idt_set_descriptor(21, &exception21_isr, 0x8E);
    idt_set_descriptor(22, &exception22_isr, 0x8E);
    idt_set_descriptor(23, &exception23_isr, 0x8E);
    idt_set_descriptor(24, &exception24_isr, 0x8E);
    idt_set_descriptor(25, &exception25_isr, 0x8E);
    idt_set_descriptor(26, &exception26_isr, 0x8E);
    idt_set_descriptor(27, &exception27_isr, 0x8E);
    idt_set_descriptor(28, &exception28_isr, 0x8E);
    idt_set_descriptor(29, &exception29_isr, 0x8E);

    idt_set_descriptor(30, &exception30_isr, 0x8E);
    idt_set_descriptor(31, &exception31_isr, 0x8E);


    __asm__ volatile ("lidt %0" : : "m"(idtr)); // load the new IDT
    __asm__ volatile ("sti"); // set the interrupt flag
}