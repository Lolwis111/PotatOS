#ifndef _SYSCALL_H_
#define _SYSCALL_H_

#include "exceptions_isr.h"

__attribute__((interrupt)) void syscall(struct interrupt_frame* frame);

#endif