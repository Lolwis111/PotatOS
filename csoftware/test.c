#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

asm("call $0, $main; xor %eax,%eax;xor %ebx,%ebx;int $0x21;");

void print(char* string)
{
    asm volatile (
        "mov $0x01, %%ah;"
        "mov $0x07, %%bl;"
        "int $0x21;"
        :
        :"d"(string)
        : "eax", "ebx"
    );
}

int main(void)
{
    

    return 0;
}
