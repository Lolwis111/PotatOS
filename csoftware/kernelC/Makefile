# $@ target file
# $< first dependency
# $^ all dependencies

CFLAGS := -m32 -O0 -I./libc/header -ffreestanding -fno-stack-protector -Wall -Werror
LFLAGS := -Ttext 0x10000 --oformat binary
LIBS := -L ./libc/ -l minic

all: pmtest.bin kernel.sys libminic.a

kernel.sys: kernelEntry.o kernel.o pic.o idt.o exceptions_isr.o irq_isr.o floppy.o dma.o sleep.o
	/home/levin/opt/cross/bin/i686-elf-ld $^ $(LFLAGS) -o $@ $(LIBS) 

kernelEntry.o: kernelEntry.asm
	nasm $< -f elf -o $@

pic.o: pic.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -c $< -o $@

idt.o: idt.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -c $< -o $@

kernel.o: kernel.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -c $< -o $@ ;\
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -S $< -o $@.asm

exceptions_isr.o: exceptions_isr.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -mgeneral-regs-only -c $< -o $@

irq_isr.o: irq_isr.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -mgeneral-regs-only -c $< -o $@

floppy.o: floppy.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -mgeneral-regs-only -c $< -o $@

dma.o: dma.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -mgeneral-regs-only -c $< -o $@

sleep.o: sleep.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -mgeneral-regs-only -c $< -o $@

pmtest.bin: protectedmode.asm
	nasm $< -f bin -o $@ ;\
	ndisasm -k 32,30 $@ > $@.asm

libminic.a:
	make clean -C libc/ ; \
	make all -j 4 -C libc/

clean:
	rm -f *.bin *.o *.dis *.sys
