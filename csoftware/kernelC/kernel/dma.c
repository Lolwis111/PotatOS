#include "dma.h"
#include "asm.h"

void initalizeFloppyDMA(void)
{
    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    
    outportb(DMA_FLIP_FLOP_RESET_03, 0xFF);
    outportb(DMA_START_ADDR_CHANNEL_2, 0x00);
    outportb(DMA_START_ADDR_CHANNEL_2, 0x10);

    outportb(DMA_FLIP_FLOP_RESET_03, 0xFF);
    outportb(DMA_COUNT_REGISTER_CHANNEL_2, 0xFF); 
    outportb(DMA_COUNT_REGISTER_CHANNEL_2, 0x23);

    outportb(DMA_PAGE_ADDR_CHANNEL_2, 0x00);

    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}

void initalizeFloppyWrite(void)
{
    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    outportb(DMA_MODE_REGISTER_03, 0x5A);

    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}

void initalizeFloppyRead(void)
{
    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x06);
    outportb(DMA_MODE_REGISTER_03, 0x56);

    outportb(DMA_SINGLE_CHANNEL_MASK_REGISTER_03, 0x02);
}
