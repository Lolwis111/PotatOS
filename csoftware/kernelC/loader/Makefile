#!/usr/bin/make

pmtest.bin: protectedmode.asm
	nasm $< -f bin -o $@ ;\
	ndisasm -k 32,30 $@ > $@.asm