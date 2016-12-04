ASM=nasm
AFLAGS=-f bin -Ox 

all: assemble
	cp pmode.bin ../Misc/pmode.bin

assemble: pmode.asm
	$(ASM) $(AFLAGS) -o pmode.bin pmode.asm
