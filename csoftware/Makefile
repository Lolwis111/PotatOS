#!/usr/bin/make
.SUFFIXES:
TAR = ctest.bin print.bin test.bin

CFLAGS = -m32 -Os -march=i686 -ffreestanding -fno-stack-protector -Wall -Werror
LFLAGS = -m elf_i386 -static -Tlinker.ld -nostdlib --nmagic

%.o: %.c
	$(CC) -c $(CFLAGS) $^ -o $@;\
        $(CC) -S $(CFLAGS) $^ -o $@.asm;\

%.elf: %.o
	$(LD) $(LFLAGS) -o $@ $^;\
        objdump -d -Mi8086,intel -S $^ > $@.lst

%.bin: %.elf
	objcopy -O binary $^ $@

all: $(TAR)

clean:
	$(RM) $(RMFILES) $(TAR)
