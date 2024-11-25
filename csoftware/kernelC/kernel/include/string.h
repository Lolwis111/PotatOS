#ifndef _STRING_H_
#define _STRING_H_

#include "stdint.h"
#include "stddef.h"

int strncmp(const char* str1, const char* str2, int n);
int strcmp(const char* str1, const char* str2);
int strlen(const char* str);
char* strcpy( char* dest, const char* src);
char* strcat(char* dest, const char* src);
void* memcpy(void* dest, const void* src, size_t numBytes);
int memcmp(const void* a, const void* b, size_t n);
void* memset( void* dest, int ch, size_t count );

#endif