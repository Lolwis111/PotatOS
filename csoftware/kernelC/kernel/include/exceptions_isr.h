#ifndef _IRQ_ROUTINES_H_
#define _IRQ_ROUTINES_H_

struct interrupt_frame;

__attribute__((interrupt)) void div_zero_exception(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception1_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void nmi_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void debugger_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception4_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception5_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void invalid_op_exception(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception7_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void double_fault_exception(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception9_isr(struct interrupt_frame* frame);

__attribute__((interrupt)) void exception10_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception11_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception12_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception_gpf_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception14_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception15_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception16_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception17_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception18_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception19_isr(struct interrupt_frame* frame);

__attribute__((interrupt)) void exception20_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception21_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception22_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception23_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception24_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception25_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception26_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception27_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception28_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception29_isr(struct interrupt_frame* frame);

__attribute__((interrupt)) void exception30_isr(struct interrupt_frame* frame);
__attribute__((interrupt)) void exception31_isr(struct interrupt_frame* frame);

#endif