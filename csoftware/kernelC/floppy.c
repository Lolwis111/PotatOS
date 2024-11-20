#include "stdint.h"
#include "floppy.h"
#include "irq_isr.h"
#include "io.h"
#include "pic.h"
#include "stdbool.h"
#include "sleep.h"

static volatile bool recievedIRQ = false;

static void lba_2_chs(uint32_t lba, uint16_t* cyl, uint16_t* head, uint16_t* sector)
{
    *cyl    = lba / (2 * SECTORS_PER_TRACK);
    *head   = ((lba % (2 * SECTORS_PER_TRACK)) / SECTORS_PER_TRACK);
    *sector = ((lba % (2 * SECTORS_PER_TRACK)) % SECTORS_PER_TRACK + 1);
}

int waitIRQ(int timeout)
{
    int waiter = 0;

    while(!recievedIRQ) 	// Wait for the IRQ handler to run
    {
        sleep(50);
        waiter += 50;
        if(waiter >= timeout) return 1;
    }

    return 0;
}

int resetController()
{
    recievedIRQ = false; 	// This will prevent the FDC from being faster than us!

    // Enter, then exit reset mode.
    outportb(DIGITAL_OUTPUT_REGISTER, 0x00);
    outportb(DIGITAL_OUTPUT_REGISTER, 0x0C);

    if(waitIRQ(500) != 0) return 1;

    outportb(CONFIGURATION_CONTROL_REGISTER, 0x00);	// 500Kbps -- for 1.44M floppy

    // configure the drive
    floppySendCommand(SPECIFY);
    outportb(DATA_FIFO, 0x80);
    outportb(DATA_FIFO, 0x0A);

    return 0;
}

int floppyRecalibrate(uint8_t driveNumber)
{
    recievedIRQ = false;

    floppySendCommand(RECALIBRATE);

    outportb(DATA_FIFO, driveNumber);

    if(waitIRQ(3000) != 0) return 1;

    return 0;
}

void floppySendCommand(uint8_t cmd)
{
    uint8_t msr = inportb(MAIN_STATUS_REGISTER);

    if((msr & 0xC0) != 0x80) resetController();

    outportb(DATA_FIFO, cmd);
}

void motorOn(uint8_t drive)
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

void motorOff(uint8_t drive)
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

    if(resetController() != 0)
    {
        return 2;
    }

    motorOn(drive);

    sleep(300);


    if(floppyRecalibrate(drive) != 0)
    {
        return 3;
    }

    sleep(100);

    motorOff(drive);

    return 0;
}


void floppyRead(uint32_t lba, uint8_t drive)
{
    uint16_t cyl, head, sector;

    lba_2_chs(lba, &cyl, &head, &sector);

    // uint8_t msr = inportb(MAIN_STATUS_REGISTER);

    motorOn(drive);

    recievedIRQ = false;

    floppySendCommand(READ_DATA);

    outportb(DATA_FIFO, (head << 2) | drive);
    io_wait();
    outportb(DATA_FIFO, cyl);
    io_wait();
    outportb(DATA_FIFO, head);
    io_wait();
    outportb(DATA_FIFO, sector);
    io_wait();
    outportb(DATA_FIFO, 2);
    io_wait();
    outportb(DATA_FIFO, 0x12);
    io_wait();
    outportb(DATA_FIFO, 0x1B);
    io_wait();
    outportb(DATA_FIFO, 0xFF);

    motorOff(drive);

    waitIRQ(5000);
}


__attribute__((interrupt))
void floppy_irq_handler(struct interrupt_frame* frame)
{
    recievedIRQ = true;
    
    PIC_sendEOI(6);
}
