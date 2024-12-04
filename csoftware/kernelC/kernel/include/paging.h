#ifndef _PAGING_H_
#define _PAGING_H_

#include "stdint.h"
#include "exceptions_isr.h"

void initPaging(void);

__attribute__((interrupt))
void pagefault_isr(struct interrupt_frame* frame, uword_t error_code);

extern void loadPageDirectory(uint32_t*);
extern void enablePaging();

#endif