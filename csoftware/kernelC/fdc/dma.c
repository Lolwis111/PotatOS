#include "dma.h"
#include "../os.h"

void initalizeFloppyDMA(void)
{
    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    
    outb(DMA_FLIP_FLOP_RESET_03, 0xFF);
    outb(DMA_START_ADDR_CHANNEL_2, 0x00);
    outb(DMA_START_ADDR_CHANNEL_2, 0x10);

    outb(DMA_FLIP_FLOP_RESET_03, 0xFF);
    outb(DMA_COUNT_REGISTER_CHANNEL_2, 0xFF); 
    outb(DMA_COUNT_REGISTER_CHANNEL_2, 0x23);

    outb(DMA_PAGE_ADDR_CHANNEL_2, 0x00);

    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}

void initalizeFloppyWrite(void)
{
    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    outb(DMA_MODE_REGISTER_03, 0x5A);

    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}

void initalizeFloppyRead(void)
{
    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    outb(DMA_MODE_REGISTER_03, 0x56);

    outb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}
