#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

asm("pusha;call $0, $main;popa;xor %eax,%eax;xor %ebx,%ebx;int $0x21;");

void main(void)
{
    unsigned char* ptr = (unsigned char*)0xB8000;

    for(int i = 0; i < 2000; i += 2)
    {
        ptr++;
        *ptr = 0x03;
        ptr++;
    }
}
