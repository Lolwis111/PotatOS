#include "stdint.h"
#include "floppy.h"
#include "irq_isr.h"
#include "asm.h"
#include "pic.h"
#include "stdbool.h"
#include "sleep.h"

static void motorOn(uint8_t drive);
static void motorOff(uint8_t drive);

static volatile bool recievedIRQ = false;

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
        msr = inportb(MAIN_STATUS_REGISTER);
        if((msr & 0xD0) == 0xD0)
        {
            return inportb(DATA_FIFO);
        }

        io_wait();
    }

    return -1;
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

static int sense()
{
    floppySendCommand(SENSE_INTERRUPT);

    int res = readResultByte();

    readResultByte();

    return res;
}

static int waitIRQ(int timeout)
{
    int waiter = 0;

    while(!recievedIRQ) 	// Wait for the IRQ handler to run
    {
        // io_wait();
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

    outportb(CONFIGURATION_CONTROL_REGISTER, 0x00);	// 500Kbps -- for 1.44M floppy

    outportb(DIGITAL_OUTPUT_REGISTER, 0x0C);

    if(waitIRQ(1000) != 0) return 1;

    sense();
    sense();
    sense();
    sense();

    // configure the drive
    floppySendCommand(SPECIFY);
    floppySendCommand(0x80);
    floppySendCommand(0x0A);

    floppySeek(1, 0);

    floppyRecalibrate(0);

    return 0;
}

int floppyRecalibrate(uint8_t drive)
{
    motorOn(drive);

    int tries = 0;
    int lastError = 0;

    for(tries = 0; tries < 3; tries++)
    {
        recievedIRQ = false;

        floppySendCommand(RECALIBRATE);

        floppySendCommand(drive);

        if(waitIRQ(5000) != 0)
        {
            lastError = 1;
            continue;
        }

        if(sense() != (0x20 | drive))
        {
            lastError = 2;
            continue;
        }
    }

    motorOff(drive);

    if(tries == 3)
        return lastError;
    
    return 0;
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

    int res2 = resetController();

    if(res2 != 0)
    {
        return 10 + res2;
    }

    motorOn(drive);

    sleep(300);
    
    res2 = floppyRecalibrate(drive);

    if(res2 != 0)
    {
        return 20 + res2;
    }

    sleep(100);

    motorOff(drive);

    return 0;
}

int floppySeek(uint8_t track, uint8_t drive)
{
    recievedIRQ = false;

    floppySendCommand(SEEK);
    floppySendCommand(drive);
    floppySendCommand(track);

    if(waitIRQ(1000) != 0)
    {
        return 1;
    }

    if(sense() != (0x20 | drive))
    {
        return 2;
    }

    return 0;
}

int floppyRead(uint32_t lba, uint8_t drive)
{
    uint16_t cyl, head, sector;

    lba_2_chs(lba, &cyl, &head, &sector);

    // uint8_t msr = inportb(MAIN_STATUS_REGISTER);

    motorOn(drive);

    int tries = 0;

    uint8_t status[7];

    for(tries = 0; tries < 3; tries++)
    {
        recievedIRQ = false;

        floppySendCommand(READ_DATA);

        floppySendCommand((head << 2) | drive);

        floppySendCommand(cyl);

        floppySendCommand(head);

        floppySendCommand(sector);

        floppySendCommand(2);

        floppySendCommand(0x12);

        floppySendCommand(0x1B);

        floppySendCommand(0xFF);

        waitIRQ(1000);

        for(int i = 0; i < 7; i++)
        {
            status[i] = (uint8_t)readResultByte();
            io_wait();
        }

        if((status[0] & 0xC0) == 0) break;

        floppyRecalibrate(drive);
    }

    motorOff(drive);

    return 0;
}


__attribute__((interrupt))
void floppy_irq_handler(struct interrupt_frame* frame)
{
    recievedIRQ = true;
    
    PIC_sendEOI(6);
}
