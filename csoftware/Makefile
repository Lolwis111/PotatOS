#!/usr/bin/make
.SUFFIXES:
SRC = float.c
TAR = float.bin

CFLAGS = -m32 -c -Os -march=i686 -ffreestanding -Wall -Werror
LFLAGS = -m elf_i386 -static -Tlinker.ld -nostdlib --nmagic

%.o: %.c
	$(CC) $(CFLAGS)  $^ -o $@

%.elf: %.o
	$(LD) $(LFLAGS) -o $@ $^

%.bin: %.elf
	objcopy -O binary $^ $@

all: $(TAR)

clean:
	$(RM) $(RMFILES) $(TAR)
