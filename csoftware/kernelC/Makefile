# $@ target file
# $< first dependency
# $^ all dependencies

CFLAGS=-m32 -O2 -ffreestanding

all: pmtest.bin

kernel.sys: kernelEntry.o kernel.o stdio.o
	/home/levin/i386elfgcc/bin/i386-elf-ld -o $@ -Ttext 0x10000 $^ --oformat binary

kernelEntry.o: kernelEntry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	/home/levin/i386elfgcc/bin/i386-elf-gcc $(CFLAGS) -c $< -o $@

stdio.o: stdio.c
	/home/levin/i386elfgcc/bin/i386-elf-gcc $(CFLAGS) -c $< -o $@

kernel.dis: kernel.sys
	ndisasm -b 32 $< > $@

protectedmode.bin: protectedmode.asm
	nasm $< -f bin -o $@

pmtest.bin: protectedmode.bin kernel.sys
	cat $^ > $@

clean:
	rm -f *.bin *.o *.dis
