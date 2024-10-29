#ifndef _FILES_H_
#define _FILES_H_

#include <stdio.h>
#include <stdbool.h>

#include "fs.h"

void clusterChain(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, const unsigned char* fat, const FILE_ENTRY* entry);
int readFile(FILE* ptr, const FLOPPY_DISK_STRUCTURE* fds, const unsigned char* fat, FILE_ENTRY* entry);

#endif