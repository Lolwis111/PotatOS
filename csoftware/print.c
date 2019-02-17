#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

// call main and exit on return
asm("call main; xor %ax,%ax;xor %bx,%bx; int $0x21;");

void main(void)
{
    unsigned char* mem = (unsigned char*)0xB8000;

    for(int y = 0; y < 25; y++)
    {
        for(int x = 0; x < 80; x++)
	{
	    *mem = 'A';
	    mem++;
	    *mem = 0x03;
	    mem++;
	}
    }
    
    asm("xor %ax,%ax;int $0x16;");
}
