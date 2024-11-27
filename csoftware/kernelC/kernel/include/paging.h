#ifndef _PAGING_H_
#define _PAGING_H_

#include "stdint.h"

void initPaging(void);

// This should go outside any function..
extern void loadPageDirectory(uint32_t*);
extern void enablePaging();

#endif