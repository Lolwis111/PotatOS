#include "stdint.h"
#include "floppy.h"
#include "irq_isr.h"
#include "asm.h"
#include "pic.h"
#include "stdbool.h"
#include "sleep.h"
#include "printk.h"
#include "panic.h"

static void motorOn(uint8_t drive);
static void motorOff(uint8_t drive);

static volatile bool recievedIRQ = false;

static const char * statusMessages[] = { 0, "error", "invalid", "drive" };

static void lba_2_chs(uint32_t lba, uint16_t* cyl, uint16_t* head, uint16_t* sector)
{
    *cyl    = lba / (2 * SECTORS_PER_TRACK);
    *head   = ((lba % (2 * SECTORS_PER_TRACK)) / SECTORS_PER_TRACK);
    *sector = ((lba % (2 * SECTORS_PER_TRACK)) % SECTORS_PER_TRACK + 1);
}

static int readResultByte()
{
    volatile uint8_t msr;
    for(int i = 0; i < 256; i++)
    {
        sleep(5);

        msr = inportb(MAIN_STATUS_REGISTER);
        if(msr & 0x80)
        {
            return inportb(DATA_FIFO);
        }
    }

    panic("Floppy result byte: timeout");
    return 1;
}

static void floppySendCommand(uint8_t cmd)
{
    volatile uint8_t msr;

    for(int i = 0; i < 256; i++)
    {
        msr = inportb(MAIN_STATUS_REGISTER);

        if((msr & 0xC0) == 0x80)
        {
            outportb(DATA_FIFO, cmd);
            return;
        }
    }
}

static void sense(int* st0, int* cyl)
{
    floppySendCommand(SENSE_INTERRUPT);

    *st0 = readResultByte();

    *cyl = readResultByte();
}

static int waitIRQ(int timeout)
{
    int waiter = 0;

    while(!recievedIRQ) 	// Wait for the IRQ handler to run
    {
        hlt();
        waiter += 1;
        if(waiter >= timeout) return 1;
    }

    return 0;
}

int resetController(void)
{
    recievedIRQ = false; 	// This will prevent the FDC from being faster than us!

    // Enter, then exit reset mode.
    outportb(DIGITAL_OUTPUT_REGISTER, 0x00);
    outportb(DIGITAL_OUTPUT_REGISTER, 0x0C);

    if(waitIRQ(1000) != 0) return 1;

    int st0, cyl;
    sense(&st0, &cyl);

    outportb(CONFIGURATION_CONTROL_REGISTER, 0x00);	// 500Kbps -- for 1.44M floppy

    // configure the drive
    floppySendCommand(SPECIFY);
    floppySendCommand(0xDF);
    floppySendCommand(0x02);

    floppyRecalibrate(0);

    return 0;
}

int floppyRecalibrate(uint8_t drive)
{
    motorOn(drive);

    sleep(300);

    int tries = 0;

    for(tries = 0; tries < 10; tries++)
    {
        recievedIRQ = false;

        floppySendCommand(RECALIBRATE);

        floppySendCommand(drive);

        if(waitIRQ(5000) != 0)
        {
            continue;
        }

        int st0, cyl;
        sense(&st0, &cyl);

        if(st0 & 0xC0)
        {
            printk("floppyRecalibrate: status = %s\n", statusMessages[st0 >> 6]);
            continue;
        }

        if(!cyl)
        {
            motorOff(drive);
            return 0;
        }
    }

    motorOff(drive);

    panic("Floppy calibrate: timeout");
    return 1;
}

static void motorOn(uint8_t drive)
{
    switch(drive)
    {
        case 0:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00011100);
            break;
        case 1:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00101101);
            break;
        case 2:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b01001110);
            break;
        case 3:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b10001111);
            break;
    }
    
}

static void motorOff(uint8_t drive)
{
    switch(drive)
    {
        case 0:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00001100);
            break;
        case 1:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00001101);
            break;
        case 2:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00001110);
            break;
        case 3:
            outportb(DIGITAL_OUTPUT_REGISTER, 0b00001111);
            break;
    }
    
}

int floppyInit(uint8_t drive)
{
    floppySendCommand(VERSION);

    uint8_t res = inportb(DATA_FIFO);

    if(res != 0x90)
    {
        return 1;
    }

    floppySendCommand(CONFIGURE);
    floppySendCommand(0);
    floppySendCommand(0b00001111);
    floppySendCommand(0);

    floppySendCommand(LOCK);
    readResultByte();

    if(resetController() != 0)
    {
        printk("floppyReset fail");
        return 1;
    }

    motorOn(drive);

    sleep(300);
    
    floppyRecalibrate(drive);

    sleep(100);

    motorOff(drive);

    return 0;
}

int floppySeek(uint8_t track, uint8_t drive)
{
    // printk("Seeking to track %d on drive %d\r\n", track, drive);

    motorOn(drive);

    for(int i = 0; i < 10; i++)
    {
        recievedIRQ = false;

        floppySendCommand(SEEK);
        floppySendCommand(drive);
        floppySendCommand(track);

        if(waitIRQ(1000) != 0)
        {
            return 1;
        }

        int st0, cyl;
        sense(&st0, &cyl);

        if(st0 & 0xC0)
        {
            printk("floppy_seek: status = %s\n", statusMessages[st0 >> 6]);
            continue;
        }

        if(cyl == track)
        {
            motorOff(drive);
            return 0;
        }
    }

    panic("Floppy seek: timeout");
    return 1;
}

int floppyRead(uint32_t lba, uint8_t drive)
{
    uint16_t track, head, sector;

    lba_2_chs(lba, &track, &head, &sector);

    outportb(CONFIGURATION_CONTROL_REGISTER, 0x00);	// 500Kbps -- for 1.44M floppy

    motorOn(drive);

    sleep(500);

    floppySeek(track, drive);

    int tries = 0;

    uint8_t status[7];
    for(tries = 0; tries < 10; tries++)
    {
        motorOn(drive);

        recievedIRQ = false;

        floppySendCommand(READ_DATA | 0xC0);

        floppySendCommand((head << 2) | drive);

        floppySendCommand(track);

        floppySendCommand(head);

        floppySendCommand(sector);

        floppySendCommand(2);

        floppySendCommand(18);

        floppySendCommand(0x1B);

        floppySendCommand(0xFF);

        waitIRQ(1000);
        
        // first read status information
        status[0] = readResultByte();
        status[1] = readResultByte();
        status[2] = readResultByte();
        status[3] = readResultByte();
        status[4] = readResultByte();
        status[5] = readResultByte();
        status[6] = readResultByte();

        int error = 0;

        if(status[0] & 0xC0)
        {
            printk("floppyRead: status = %s\n", statusMessages[status[0] >> 6]);
            error = 1;
        }

        if(status[1] & 0x80)
        {
            printk("floppyRead: end of cylinder\n");
            error = 1;
        }

        if(status[0] & 0x08)
        {
            printk("floppyRead: drive not ready\n");
            error = 1;
        }

        if(status[1] & 0x20)
        {
            printk("floppyRead: CRC error\n");
            error = 1;
        }

        if(status[1] & 0x10)
        {
            printk("floppyRead: controller timeout\n");
            error = 1;
        }

        if(status[1] & 0x04)
        {
            printk("floppyRead: no data found\n");
            error = 1;
        }

        if((status[1]|status[2]) & 0x01)
        {
            printk("floppyRead: no address mark found\n");
            error = 1;
        }
        
        if(status[2] & 0x40)
        {
            printk("floppyRead: deleted address mark\n");
            error = 1;
        }

        if(status[2] & 0x20)
        {
            printk("floppyRead: CRC error in data\n");
            error = 1;
        }

        if(status[2] & 0x10)
        {
            printk("floppyRead: wrong cylinder\n");
            error = 1;
        }

        if(status[2] & 0x04)
        {
            printk("floppyRead: uPD765 sector not found\n");
            error = 1;
        }

        if(status[2] & 0x02)
        {
            printk("floppyRead: bad cylinder\n");
            error = 1;
        }

        if(status[6] != 0x2)
        {
            printk("floppyRead: wanted 512B/sector, got %d", (1<<(status[6]+7)));
            error = 1;
        }

        // if(status[1] & 0x02)
        // {
        //     printk("floppy_do_sector: not writable\n");
        //     error = 2;
        // }

        if(!error)
        {
            motorOff(drive);
            return 0;
        }

        if(error > 1)
        {
            printk("floppy_do_sector: not retrying..\n");
            motorOff(drive);
            return -2;
        }
    }

    motorOff(drive);

    sleep(300);

    return 0;
}


__attribute__((interrupt))
void floppy_irq_handler(struct interrupt_frame* frame)
{
    recievedIRQ = true;
    
    PIC_sendEOI(6);
}
