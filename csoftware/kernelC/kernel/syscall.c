#include "printk.h"
#include "syscall.h"

__attribute__((interrupt)) void syscall(struct interrupt_frame* frame)
{
    printk("Systemcall\r\n\n");
}