# Universal Makefile - Works on Windows and Linux
# Compiles exactly the same on any OS without changes

ifeq ($(OS),Windows_NT)
    RM      := del /Q /S
    CP      := copy /b
    NULL    := > nul 2>&1
    PY      := python
    MKDIR   := mkdir
    QEMU    := qemu-system-i386.exe
    LDFLAGS += -m i386pe
else
    RM      := rm -f
    RMDIR   := rm -rf
    CP      := cat
    NULL    := > /dev/null 2>&1
    PY      := python3
    MKDIR   := mkdir -p
    QEMU    := qemu-system-i386
    LDFLAGS += -m elf_i386
endif

CC          = gcc
AS          = nasm
LD          = ld
OBJCOPY     = objcopy

CFLAGS      = -ffreestanding -O2 -Wall -Wextra -nostdlib -nostartfiles -I. -Ikernel -Ikernel/memory -Ikernel/drivers -Ikernel/events -Ikernel/input -Ikernel/logs -Ifilesystem -IIDT -Iinterrupts -IPIC -Itimer -Ischeduler -Iprocess_manager -IIPC -Iterminal -Ishell -Iblade -Icore -Iruntime -Iinstaller
ASFLAGS     = -f elf32
LDFLAGS    += -T kernel/linker.ld --oformat binary

C_SRC       = $(wildcard kernel/*.c) $(wildcard kernel/memory/*.c) $(wildcard kernel/drivers/*/*.c) $(wildcard kernel/events/*.c) $(wildcard kernel/input/*.c) $(wildcard kernel/logs/*.c) $(wildcard filesystem/*.c) $(wildcard IDT/*.c) $(wildcard interrupts/*.c) $(wildcard PIC/*.c) $(wildcard timer/*.c) $(wildcard scheduler/*.c) $(wildcard process_manager/*.c) $(wildcard IPC/*.c) $(wildcard terminal/*.c) $(wildcard shell/*.c) $(wildcard blade/*.c) $(wildcard core/*.c) $(wildcard runtime/*.c) $(wildcard installer/*.c)
ASM_SRC     = $(wildcard boot/*.asm) $(wildcard kernel/*.asm) $(wildcard IDT/*.asm) $(wildcard interrupts/*.asm) $(wildcard PIC/*.asm) $(wildcard scheduler/*.asm)
OBJ         = $(C_SRC:.c=.o) $(ASM_SRC:.asm=.o)

KERNEL      = kernel.bin
BOOTLOADER  = boot.bin
IMAGE       = CocosOS.img
ISO         = CocosOS.iso

.PHONY: all clean run run-iso iso ui tools rust swift

all: $(IMAGE) $(ISO)

%.o: %.c
	@$(CC) $(CFLAGS) -c $< -o $@

%.o: %.asm
	@$(AS) $(ASFLAGS) $< -o $@

$(BOOTLOADER): boot/boot.asm
	@$(AS) -f bin $< -o $@

$(KERNEL): $(OBJ)
	@$(LD) $(LDFLAGS) -o $@ $^

$(IMAGE): $(BOOTLOADER) $(KERNEL)
ifeq ($(OS),Windows_NT)
	@$(CP) $(BOOTLOADER)+$(KERNEL) $@ $(NULL)
else
	@$(CP) $(BOOTLOADER) $(KERNEL) $@ $(NULL)
endif

$(ISO): $(IMAGE)
	@genisoimage -b $(IMAGE) -no-emul-boot -boot-load-size 4 -boot-info-table -o $@ . $(NULL) || mkisofs -b $(IMAGE) -no-emul-boot -boot-load-size 4 -boot-info-table -o $@ . $(NULL)

iso: $(ISO)

ui:
	@lua GUI/ui_compiler.lua

run: $(IMAGE)
	@$(QEMU) -drive format=raw,file=$<

run-iso: $(ISO)
	@$(QEMU) -cdrom $< -m 512 -vga std

tools:
	@$(PY) IA/shellby.py

rust:
	@cargo build --release

swift:
	@swift build

clean:
	@$(RM) *.o $(NULL)
	@$(RM) $(KERNEL) $(IMAGE) $(BOOTLOADER) $(ISO) $(NULL)
	@$(RM) UI.c InstallerUI.c $(NULL)