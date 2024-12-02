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
// #include "mouse.h"

#include "syscall.h"
#include "userland.h"
#include "string.h"
#include "fs.h"
#include "gdt_util.h"
#include "paging.h"
#include "malloc.h"

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

void malloc_test()
{
    printBlocks();

    void* p1 = malloc(200);
    void* p2 = malloc(300);
    void* p3 = malloc(150);

    printBlocks();

    free(p2);

    printBlocks();

    p2 = malloc(250);

    printBlocks();

    free(p1);
    free(p2);
    free(p3);
    
    printBlocks();
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
    // idt_set_descriptor(0x74, &mouse_irq, 0x8E);
    idt_set_descriptor(0x75, &irq13_isr, 0x8E);
    idt_set_descriptor(0x76, &irq14_isr, 0x8E);
    idt_set_descriptor(0x77, &irq15_isr, 0x8E);

    idt_set_descriptor(0x80, &syscall, 0b11101110);
}

int main()
{
    clearScreen(0x07);

    initGDT();

    initPaging();

    initKeyboard();

    // initMouse();

    initSerial();
    
    setTimer(100);

    PIC_remap(0x20, 0x70);
    initIDT();

    floppy_detect_drives();

    initalizeFloppyDMA();

    init_c_malloc(8192 * 4);

    char* str = "Welcome to TomatOS. The PotatOS fork written in C\r\n\n\n";
    printk(str);

    malloc_test();
    

    // jump_usermode();
    // printk("Returned from usermode");

    // force page fault
    // char* ptr = (char*)0x500000;
    // *ptr = 'a';

    // printk("Initiating floppy drive (might take a few seconds)\r\n");

    // floppyInit(0);

    // FLOPPY_DISK_STRUCTURE fds;

    // readFileSystem(&fds);

    // printk("Bytes Per Sector:    %6d\r\n", fds.BytesPerSector);
    // printk("Sectors Per Cluster: %6d\r\n", fds.SectorsPerCluster);
    // printk("Number Of FATS:      %6d\r\n", fds.NumberOfFATS);
    // printk("Root Entries:        %6d\r\n", fds.RootEntries);

    // printk("Sectors Per FAT:     %6d\r\n", fds.SectorsPerFAT);
    // printk("Sectors Per Track:   %6d\r\n", fds.SectorsPerTrack);
    // printk("Heads Per Cylinder:  %6d\r\n", fds.HeadsPerCylinder);

    // printk("Root sector:         %6d\r\n", ((fds.NumberOfFATS * fds.SectorsPerFAT) + fds.ReservedSectors));

    // readRoot(&fds);

    // unsigned char c = 0;
    // for(int i = 0; i < 16; i++)
    // {
    //     for(int j = 0; j < 16; j++)
    //     {
    //         setColor(c);
    //         printk("%02x ", c);
    //         c++;
    //     }
    //     setColor(0x07);
    //     printk("\r\n");
    // }

    // setColor(0x07);

    // int80();

    while(1)
    {
        int c = getch();
        printk("%d ", c);
    }

    return 0;
}
