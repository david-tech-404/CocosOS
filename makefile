CC = gcc
AS = nasm
LD = ld

CFLAGS = -ffreestanding -O2 -Wall

ASFLAGS = -f bin

C_SRC = $(shell find . -name "*.c")
ASM_SRC = $(shell find . -name "*.asm")
LUA_SRC = $(shell find . -name "*.lua")
JSON_SRC = $(shell find . -name "*.json")
PY_SRC = $(shell find . -name "*.py")
RUST_SRC = $(shell find . -name "*.rs")
SWIFT_SRC = $(shell find . -name "*.swift")
LD_FILE = kernel/linker.ld

OBJ = $(C_SRC:.c=.o)

KERNEL = kernel.bin
IMAGE = CocosOS-image.bin

ui:
	lua GUI/ui_compiler.lua

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

boot.bin: boot/boot.asm
	$(AS) $(ASFLAGS) $< -o boot.bin

$(KERNEL): ui $(OBJ)
	$(LD) -T $(LD_FILE) -o $(KERNEL) $(OBJ)

$(IMAGE): boot.bin $(KERNEL)
	cat boot.bin $(KERNEL) > $(IMAGE)

tools:
	python3 IA/shellby.py

rust:
	cargo build --release

swift:
	swift build

all: $(IMAGE)

run:
	qemu-system-x86_64 -drive format=raw, file=$(IMAGE)

clean:
	rm -f $(OBJ) $(KERNEL) $(IMAGE) boot.bin

.PHONY: all run clean ui tools rust swift
