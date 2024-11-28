STARTUP(obj/kernelEntry.o);
OUTPUT(bin/kernel.sys);
SECTIONS
{
    . = 0x10000;
    .text ALIGN (0x1000):
    {
        _text = .;
        *(.text);
        _text_end = .;
    }

    .rodata ALIGN (0x1000):
    {
        *(.rodata)
    }

    .data ALIGN (0x1000):
    {
        _data = .;
        
        *(.data)
        
        _data_end = .;
    }
    .bss : {
        _bss = .;
        *(COMMON)
        *(.bss);
        _bss_end = .;
        _end_kernel = .;
    }
    /DISCARD/ :
    {
        *(.note*);
        *(.iplt*);
        *(.igot*);
        *(.rel*);
        *(.comment);
        *(.eh_frame);
    }
}
