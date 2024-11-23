#ifndef _SLEEP_H_
#define _SLEEP_H_

#include "irq_isr.h"

__attribute__((interrupt))
void timer_isr(struct interrupt_frame* frame);

void setTimer(int hz);
void sleep(int time);

#endif