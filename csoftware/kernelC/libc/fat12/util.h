#ifndef _UTIL_H_
#define _UTIL_H_

#include <stdbool.h>

#include "fs.h"

void printBuffer(const unsigned char* buffer, size_t size);
int cluster2lba(unsigned short cluster, const struct FLOPPY_DISK_STRUCTURE* fds);

void convertName(char* fatName, const char* source, bool isDir);
void convertName_d(char* fatName, const char* source);
void convertName_f(char* fatName, const char* source);

int saveFile(const unsigned char* buffer, size_t size, const char* fName);

void printDir(const DIRECTORY* dir);

#endif