# Compiler and assembler settings
CC = /home/levin/opt/cross/bin/i686-elf-gcc
ASM = nasm
LD = /home/levin/opt/cross/bin/i686-elf-ld

# Directories
SRC_DIR = src
ASM_DIR = asm
OBJ_DIR = obj
LST_DIR = lst
OUT_DIR = .

# File extensions
C_SRC_EXT = .c
ASM_SRC_EXT = .asm
OBJ_EXT = .o
OUT_NAME = kernel.sys

CFLAGS := -m32 -march=i586 -O2 -Iinclude/ -ffreestanding -fno-stack-protector -Wall -Werror -Wno-array-bounds -mgeneral-regs-only -mno-red-zone
LFLAGS := -Tlinker.ld --oformat binary
AFLAGS := -f elf

# Source files and object files
C_SRCS = $(wildcard $(SRC_DIR)/*.c)
ASM_SRCS = $(wildcard $(ASM_DIR)/*.asm)

# Corresponding object files for C and ASM sources
C_OBJS = $(C_SRCS:$(SRC_DIR)/%$(C_SRC_EXT)=$(OBJ_DIR)/%$(OBJ_EXT))
ASM_OBJS = $(ASM_SRCS:$(ASM_DIR)/%$(ASM_SRC_EXT)=$(OBJ_DIR)/%$(OBJ_EXT))

# Generated assembly files from C source files
C_ASM = $(C_SRCS:$(SRC_DIR)/%$(C_SRC_EXT)=$(LST_DIR)/%$(ASM_SRC_EXT))

# All object files
OBJS = $(C_OBJS) $(ASM_OBJS)

# Output executable name
OUT_EXEC = $(OUT_DIR)/$(OUT_NAME)

# Default target to build everything
all: $(OUT_EXEC)

# Rule to link object files into the final executable
$(OUT_EXEC): $(OBJS)
	$(LD) $(OBJS) $(LFLAGS) -o bin/$(OUT_EXEC)

# Rule to compile C files into object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to generate assembly files from C files
$(LST_DIR)/%.asm: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -S $< -o $@

# Rule to assemble assembly files into object files
$(OBJ_DIR)/%.o: $(ASM_DIR)/%.asm
	$(ASM) $< $(AFLAGS) -o $@  

# Clean up generated files
clean:
	rm -f $(OBJ_DIR)/*.o $(ASM_DIR)/*.s $(OUT_EXEC)

# Phony targets
.PHONY: all clean