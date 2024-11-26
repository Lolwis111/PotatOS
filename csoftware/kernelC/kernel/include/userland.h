#ifndef _USERLAND_H_
#define _USERLAND_H_

#include "stdint.h"

void userland_function(void);

__attribute__((noreturn)) extern void jump_usermode(void);

#endif