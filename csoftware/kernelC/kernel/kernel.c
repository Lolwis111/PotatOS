#include "serial.h"
#include "printk.h"
#include "pic.h"
#include "asm.h"
#include "idt.h"
#include "exceptions_isr.h"
#include "irq_isr.h"
#include "dma.h"
#include "floppy.h"
#include "sleep.h"
#include "keyboard.h"
#include "console.h"
#include "panic.h"
#include "stddef.h"

void floppy_detect_drives()
{
    const char * drive_types[8] = 
    {
        "none",
        "360kB 5.25\"",
        "1.2MB 5.25\"",
        "720kB 3.5\"",
        "1.44MB 3.5\"",
        "2.88MB 3.5\"",
        "unknown type",
        "unknown type"
    };

   outportb(0x70, 0x10);
   uint8_t drives = inportb(0x71);

   printk(" - Floppy drive 0: %s\r\n", drive_types[drives >> 4]);
   printk(" - Floppy drive 1: %s\r\n", drive_types[drives & 0xf]);
}

void initIDT()
{
    idt_init();

    idt_set_descriptor(0x20, &timer_isr, 0x8E);
    idt_set_descriptor(0x21, &keyboard_isr, 0x8E);
    idt_set_descriptor(0x22, &irq2_isr, 0x8E);
    idt_set_descriptor(0x23, &irq3_isr, 0x8E);
    idt_set_descriptor(0x24, &irq4_isr, 0x8E);
    idt_set_descriptor(0x25, &irq5_isr, 0x8E);
    idt_set_descriptor(0x26, &floppy_irq_handler, 0x8E);
    idt_set_descriptor(0x27, &irq7_isr, 0x8E);

    idt_set_descriptor(0x70, &irq8_isr, 0x8E);
    idt_set_descriptor(0x71, &irq9_isr, 0x8E);
    idt_set_descriptor(0x72, &irq10_isr, 0x8E);
    idt_set_descriptor(0x73, &irq11_isr, 0x8E);
    idt_set_descriptor(0x74, &irq12_isr, 0x8E);
    idt_set_descriptor(0x75, &irq13_isr, 0x8E);
    idt_set_descriptor(0x76, &irq14_isr, 0x8E);
    idt_set_descriptor(0x77, &irq15_isr, 0x8E);
}

static void printBuffer(const unsigned char* buffer, size_t size)
{
    const size_t blockSize = 32;

    size_t blockCount = size / blockSize;
    size_t rest = size % blockSize;

    unsigned char buf[blockSize+1];
    buf[blockSize] = 0;

    size_t i = 0;

    for(; i < blockCount; i++)
    {
        // printf("%x: ", (i*16));
        for(size_t j = 0; j < blockSize; j++)
        {
            unsigned char c = buffer[(i * blockSize) + j];
            // printf("%x ", c);
            if(c >= 32)
            {
                buf[j] = c;
            }
            else
            {
                buf[j] = '.';
            }
        }

        printk("%s\r\n", buf);
    }

    // printf("%x: ", (i*blockSize));

    for(size_t i = 0; i < blockSize; i++)
    {
        buf[i] = ' ';
    }

    for(size_t j = 0; j < rest; j++)
    {
        unsigned char c = buffer[(i * blockSize) + j];
        // printf("%x ", c);
        if(c >= 32)
        {
            buf[j] = c;
        }
        else
        {
            buf[j] = '.';
        }
    }

    // for(size_t j = 0; j < 16 - rest; j++)
    // {
    //     printf("   ");
    // }

    printk("%s\r\n", buf);
}

int main()
{
    clearScreen(0x07);

    initKeyboard();
    
    initSerial();
    
    setTimer(100);

    PIC_remap(0x20, 0x70);
    initIDT();

    char* str = "Welcome to TomatOS. The PotatOS fork written in C\r\n\n\n";
    printk(str);

    initalizeFloppyDMA();

    floppy_detect_drives();

    printk("Initiating floppy drive (might take a few seconds)\r\n");

    int res = floppyInit(0);

    printk("Result: %d (%s)\r\n", res, res == 0 ? "success" : "error");

    floppyRead(0, 0);

    printBuffer((const unsigned char*)0x1000, 512);

    while(1)
    {
        int c = getch();
        printk("%c", c);
    }

    // int s = 0;

    // char buffer[64];
    // while(1)
    // {
    //     memset(buffer, 0, 64);

    //     printf("\r\nCMD> ");
    //     gets(buffer);
    //     printf("\r\n");      

    //     if(0 == strcmp(buffer, "colors"))
    //     {
    //         unsigned char c = 0;
    //         for(int i = 0; i < 16; i++)
    //         {
    //             for(int j = 0; j < 16; j++)
    //             {
    //                 setColor(c);
    //                 printf("%x ", c);
    //                 c++;
    //             }
    //             printf("\r\n");
    //         }

    //         setColor(0x07);
    //     }
    //     else if(0 == strcmp(buffer, "printf"))
    //     {
    //         int i = 123;

    //         char* str2 = "test123";

    //         printf("printf:\r\nbase 8:%o\r\nbase 10:%d\r\nbase 16:%x\r\nAnd some string:%s\r\n", i, i, i, str2);
    //     }
    //     else if(0 == strcmp(buffer, "floats"))
    //     {
    //         double d1 = 10.01;
    //         double d2 = 100.001;
    //         double d3 = 123.321;
    //         double d4 = 10000.00002;

    //         printf("10.01: %f\r\n100.001: %f\r\n123.321: %f\r\n10000.00002: %f\r\n", d1, d2, d3, d4);
    //     }
    //     else if(0 == strcmp(buffer, "math"))
    //     {
    //         for(double d = 0; d < 360; d += 30)
    //         {
    //             // double x = pow(d, 2);
    //             double x = d * d;

    //             printf("%f | %f\r\n", d, x);
    //         }
    //     }
    //     else if(0 == strcmp(buffer, "clear"))
    //     {
    //         clearscreen();
    //     }
    //     else if(0 == strcmp(buffer, "test"))
    //     {
    //         char* str1 = "test123";
    //         char* str2 = "Some Text";
    //         char* str3 = "EPIC HARDCORE SHOOBIE DOG MEMES";
    //         int l1 = strlen(str1);
    //         int l2 = strlen(str2);
    //         int l3 = strlen(str3);

    //         printf("%d: %s\r\n%d: %s\r\n%d: %s\r\n", l1, str1, l2, str2, l3, str3);
    //     }
    //     else if(0 == strncmp(buffer, "args", 4))
    //     {
    //         printf("args: %s", buffer + 4);
    //     }
    //     else if(0 == strncmp(buffer, "cat", 4))
    //     {
    //         char a[] = "Hallo ";
    //         char b[] = "Welt";

    //         char c[50];
    //         strcpy(c, a);
    //         strcat(c, b);

    //         printf("%s\r\n%s\r\n%s\r\n", a, b, c);
    //     }
    //     else if(0 == strcmp(buffer, "zero"))
    //     {
    //         int a = 12;
    //         int b = 24;
    //         int c = (b / (a - 3*sizeof(int)));

    //         printf("%d", c);
    //     }
    //     else if(0 == strcmp(buffer, "size"))
    //     {

    //         int sc = sizeof(char);
    //         int ss = sizeof(short);
    //         int si = sizeof(int);
    //         int sl = sizeof(long);
    //         int sli = sizeof(long int);
    //         int slli = sizeof(long long int);

    //         printf("char:           %d\r\n", sc);
    //         printf("short:          %d\r\n", ss);
    //         printf("int:            %d\r\n", si);
    //         printf("long:           %d\r\n", sl);
    //         printf("long int:       %d\r\n", sli);
    //         printf("long long int:  %d\r\n", slli);
    //     }
    //     else if(0 == strcmp(buffer, "sleep"))
    //     {
    //         printf("Start\r\n");
    //         sleep(1000);
    //         printf("End\r\n");
    //     }
    //     else if(0 == strcmp(buffer, "floppy"))
    //     {
    //         for(int i = 0; i < 100; i++)
    //         {
    //             floppyRead(s, 0);

    //             // Floppy DMA writes to physical address 0x1000-0x3FFF
    //             printBuffer((const unsigned char*)0x1000, 512);

    //             s++;
    //         }
            
    //     }
    //     else
    //     {
    //         printf("Unrecognized command '%s'! Try help to list all commands.\r\n", buffer);
    //     }
    // }

    return 0;
}
