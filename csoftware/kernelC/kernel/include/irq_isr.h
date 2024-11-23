#ifndef _IRQ_ISR_H_
#define _IRQ_ISR_H_

struct interrupt_frame;

__attribute__((interrupt)) void irq2_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq3_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq4_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq5_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq6_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq7_isr(struct interrupt_frame* frame);

__attribute__((interrupt)) void irq8_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq9_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq10_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq11_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq12_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq13_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq14_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void irq15_isr(struct interrupt_frame* frame);

#endif