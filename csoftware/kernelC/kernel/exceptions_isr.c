#include "exceptions_isr.h"
#include "stdint.h"
#include "printk.h"
#include "asm.h"
#include "keyboard.h"
#include "console.h"
#include "panic.h"

__attribute__((interrupt)) void div_zero_exception(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '0';
}

__attribute__((interrupt)) void exception1_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '1';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void nmi_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '2';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void debugger_isr(struct interrupt_frame* frame)
{
    uint32_t eax, ebx, ecx, edx, esi, edi;
    asm volatile(";" : 
        "=a"(eax),
        "=b"(ebx),
        "=c"(ecx),
        "=d"(edx),
        "=S"(esi),
        "=D"(edi)
         :);
    
    char* dst = (char*)0x4000;
    char* v = (char*)0xB8000;

    int x, y;
    getCursorPosition(&x, &y);

    for(int i = 0; i < 80*25*2; i++)
    {
        *dst = *v;
        dst++;
        v++;
    }

    clearScreen();

    printk("eax: %x\r\nebx: %x\r\necx: %x\r\nedx: %x\r\nesi: %x\r\nedi: %x\r\n", eax, ebx, ecx, edx, esi, edi);

    printk("\r\nPress any key to continue.\r\n");

    getch();

    dst = (char*)0x4000;
    v = (char*)0xB8000;

    for(int i = 0; i < 80*25*2; i++)
    {
        *v = *dst;
        dst++;
        v++;
    }

    setCursorPosition(x, y);
}

__attribute__((interrupt)) void exception4_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '4';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception5_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '5';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void invalid_op_exception(struct interrupt_frame* frame)
{
    clearScreen();

    panic("Invalid Instruction");
}

__attribute__((interrupt)) void exception7_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '7';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void double_fault_exception(struct interrupt_frame* frame)
{
    clearScreen();

    panic("Exception during an exception.");
}

__attribute__((interrupt)) void exception9_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = '9';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception10_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'a';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception11_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'b';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception12_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'c';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception_gpf_isr(struct interrupt_frame* frame)
{
    unsigned long errCode = pop();
    
    clearScreen();

    char tableC = ((errCode | 0x0060) >> 13) + '0';

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'd';
    v += 2;
    *v = tableC;

    char code1 = ((errCode | 0x0010) >> 4) + '0';
    char code2 = (errCode | 0x000F) + '0';

    v += 2;
    *v = ' ';

    v += 2;
    *v = code1;

    v += 2;
    *v = code2;

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception14_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'e';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception15_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'f';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception16_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'g';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception17_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'h';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception18_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'i';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception19_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'j';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception20_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'k';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception21_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'l';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception22_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'm';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception23_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'n';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception24_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'o';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception25_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'p';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception26_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'q';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception27_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'r';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception28_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 's';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception29_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 't';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception30_isr(struct interrupt_frame* frame)
{
    clearScreen();

    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'u';

    asm volatile("cli; hlt;":::);
}

__attribute__((interrupt)) void exception31_isr(struct interrupt_frame* frame)
{
    clearScreen();
    
    char* v = (char*)0xB8000;

    *v = 'E';
    v += 2;
    *v = 'v';

    asm volatile("cli; hlt;":::);
}