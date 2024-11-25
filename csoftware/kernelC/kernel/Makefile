# $@ target file
# $< first dependency
# $^ all dependencies

CFLAGS := -m32 -march=i586 -O2 -Iinclude/ -ffreestanding -fno-stack-protector -Wall -Werror -mgeneral-regs-only -mno-red-zone
LFLAGS := -Ttext 0x10000 --oformat binary

FILES := $(patsubst %.c,%.o,$(wildcard *.c))

all: pmtest.bin kernel.sys 

kernel.sys: kernelEntry.o $(FILES) usermode.o # kernelEntry.o kernel.o pic.o idt.o exceptions_isr.o irq_isr.o floppy.o dma.o sleep.o keyboard.o asm.o keyboard.o serial.o printk.o console.o panic.o
	/home/levin/opt/cross/bin/i686-elf-ld $^ $(LFLAGS) -o bin/$@

kernelEntry.o: kernelEntry.asm
	nasm $< -f elf -o $@

usermode.o: usermode.asm
	nasm $< -f elf -o $@

%.o: %.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -c $< -o $@ ;\
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -S $< -o dis/$@.asm

pmtest.bin: protectedmode.asm
	nasm $< -f bin -o bin/$@ ;\
	ndisasm -k 32,30 bin/$@ > dis/$@.asm

clean:
	rm -f bin/*.bin *.o dis/*.asm bin/*.sys
