#ifndef _PRINTK_H_
#define _PRINTK_H_

int printk(const char* format, ...);
int vsprintk(char* dest, const char* format, __builtin_va_list val);

#endif