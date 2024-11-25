#ifndef _MOUSE_H_
#define _MOUSE_H_

struct interrupt_frame;

void initMouse(void);
__attribute__((interrupt)) void mouse_irq(struct interrupt_frame* frame);

#endif