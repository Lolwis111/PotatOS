#ifndef _CODE16GCC_H_
#define _CODE16GCC_H_
asm(".code16gcc\n");
#endif

asm("call $0, $main; xor %eax,%eax;xor %ebx,%ebx;int $0x21;");

char buffer[8];
char decimals[] = "0123456789ABCDEF";

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

void charToHex(int low, int high, char* hex)
{
    *hex = decimals[high];
    *(hex+1) = decimals[low];
    *(hex+2) = 0;
}

int main(void)
{
    for(int y = 0; y < 16; y++)
    {
        for(int x = 0; x < 16; x++)
        {
            charToHex(y, x, buffer);
            print(buffer);
        }
        print("\r\n");
    }

    return 0;
}
