#!/usr/bin/make

CFLAGS := -m32 -g -O0 -I../libc/header -ffreestanding -fno-stack-protector -Wall -Werror

all: libminic.a

clean:
	rm -f *.sys *.elf *.o

%.o: %.c
	/home/levin/opt/cross/bin/i686-elf-gcc -c $(CFLAGS) $^ -o $@; \
	objdump -d -M intel -S $@ > asm/$@.asm

libminic.a: stdio.o serial.o string.o time.o io.o
	/home/levin/opt/cross/bin/i686-elf-ar -rcs $@ $^ 

