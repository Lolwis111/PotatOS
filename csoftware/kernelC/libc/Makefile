#!/usr/bin/make

CFLAGS := -m32 -march=pentium -O2 -I./header -ffreestanding -fno-stack-protector -Wall -Werror

FILES := $(patsubst %.c,%.o,$(wildcard *.c))

all: libminic.a

clean:
	rm -f *.o libminic.a

%.o: %.c
	/home/levin/opt/cross/bin/i686-elf-gcc -c $(CFLAGS) $^ -o $@; \
	/home/levin/opt/cross/bin/i686-elf-gcc -S $(CFLAGS) $^ -o asm/$@.asm

libminic.a: $(FILES)
	/home/levin/opt/cross/bin/i686-elf-ar -rcs $@ $^ 

