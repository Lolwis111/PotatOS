#!/usr/bin/make

CFLAGS := -m32 -O2 -I../libc/header -ffreestanding -fno-stack-protector -Wall -Werror

FILES := $(patsubst %.c,%.o,$(wildcard *.c))

all: libminic.a

clean:
	rm -f *.sys *.elf *.o

%.o: %.c
	/home/levin/opt/cross/bin/i686-elf-gcc -c $(CFLAGS) $^ -o $@; \
	objdump -d -M intel -S $@ > asm/$@.asm

libminic.a: $(FILES)
	/home/levin/opt/cross/bin/i686-elf-ar -rcs $@ $^ 

