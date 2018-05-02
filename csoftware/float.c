#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

asm("jmp $0, $main");

void exit(short code)
{
    asm volatile(
        "mov $0x00, %%ah;"
        "mov %0, %%bx;"
        "int $0x21;"
        :: "r"(code):"ax","bx"
    );
}

void printString(const char *string, char color)
{
    asm volatile (
        "mov %0, %%edx;"
        "mov %1, %%bl;"
        "mov $0x01, %%ah;"
        "int $0x21;"
        : : "d"(string), "r"(color) :
    );
}

void printAddr(int *address)
{
    char addr[11];
    
    int address_int = 0;
    
    asm volatile(
        ""
        : "=r"(address_int)
        : "r"(address)
    );
    
    for(int i = 10; i >= 0; i--)
    {
        addr[i] = (address_int % 10) + '0';
        address_int /= 10;
    }
    
    addr[10] = '\0';
    
    printString(addr, 0x07);
}

void debug_p(int *value)
{
    asm volatile(
        "mov %0, %%edx;"
        "mov $0xFF, %%ah;"
        "int $0x21;"
        : : "r"(value)
    );
}

void debug_i(int value)
{
    asm volatile(
        "mov %0, %%edx;"
        "mov $0xFF, %%ah;"
        "int $0x21;"
        : : "r"(value)
    );
}

void main(void)
{
    debug_i(1);
    debug_i(10);
    debug_i(1000);
    debug_i(123456789);
    
    int buffer[16];
    debug_p(buffer);
    
    printString("\r\n\0", 0x07);
    
    printAddr(buffer);
    
    exit(0);
}
