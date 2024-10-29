# $@ target file
# $< first dependency
# $^ all dependencies

CFLAGS := -m32 -O2 -I./libc/header -ffreestanding -fno-stack-protector -Wall -Werror
LFLAGS := -Ttext 0x10000 --oformat binary
LIBS = -L ./libc/ -l minic

all: pmtest.bin libminic.a

kernel.sys: kernelEntry.o kernel.o
	/home/levin/opt/cross/bin/i686-elf-ld $^ $(LFLAGS) -o $@ $(LIBS) 

kernelEntry.o: kernelEntry.asm
	nasm $< -f elf -o $@

kernel.o: kernel.c
	/home/levin/opt/cross/bin/i686-elf-gcc $(CFLAGS) -c $< -o $@

protectedmode.bin: protectedmode.asm
	nasm $< -f bin -o $@

pmtest.bin: protectedmode.bin kernel.sys
	cat $^ > $@ ;\
	ndisasm -k 32,30 $@ > $@.asm

libminic.a:
	make clean -C libc/ ; \
	make all -C libc/

clean:
	rm -f *.bin *.o *.dis *.sys
