CC = gcc
AS = nasm
LD = ld
OBJCOPY = objcopy

CFLAGS = -ffreestanding -O2 -Wall -Wextra -nostdlib -nostartfiles -I. -Ikernel -Ikernel/memory -Ikernel/drivers -Ikernel/events -Ikernel/input -Ikernel/logs -Ifilesystem -IIDT -Iinterrupts -IPIC -Itimer -Ischeduler -Iprocess_manager -IIPC -Iterminal -Ishell -Iblade -Icore -Iruntime -Iinstaller
ASFLAGS = -f elf32
LDFLAGS = -T kernel/linker.ld --oformat binary -m elf_i386

C_SRC = $(wildcard kernel/*.c) $(wildcard kernel/memory/*.c) $(wildcard kernel/drivers/*.c) $(wildcard kernel/events/*.c) $(wildcard kernel/input/*.c) $(wildcard kernel/logs/*.c) $(wildcard filesystem/*.c) $(wildcard IDT/*.c) $(wildcard interrupts/*.c) $(wildcard PIC/*.c) $(wildcard timer/*.c) $(wildcard scheduler/*.c) $(wildcard process_manager/*.c) $(wildcard IPC/*.c) $(wildcard terminal/*.c) $(wildcard shell/*.c) $(wildcard blade/*.c) $(wildcard core/*.c) $(wildcard runtime/*.c) $(wildcard installer/*.c)
ASM_SRC = $(wildcard boot/*.asm) $(wildcard kernel/*.asm) $(wildcard IDT/*.asm) $(wildcard interrupts/*.asm) $(wildcard PIC/*.asm) $(wildcard scheduler/*.asm)
OBJ = $(C_SRC:.c=.o) $(ASM_SRC:.asm=.o)

KERNEL = kernel.bin
BOOTLOADER = boot.bin
IMAGE = CocosOS.img
ISO = CocosOS.iso

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
	@copy /b $(BOOTLOADER)+$(KERNEL) $@ > nul

$(ISO): $(IMAGE)
	@genisoimage -b $(IMAGE) -no-emul-boot -boot-load-size 4 -boot-info-table -o $@ . 2>nul || mkisofs -b $(IMAGE) -no-emul-boot -boot-load-size 4 -boot-info-table -o $@ .

iso: $(ISO)
ui:
	@lua GUI/ui_compiler.lua
run: $(IMAGE)
	@qemu-system-i386 -drive format=raw,file=$<
run-iso: $(ISO)
	@qemu-system-i386 -cdrom $< -m 512 -vga std

tools:
	@python3 IA/shellby.py
rust:
	@cargo build --release
swift:
	@swift build

clean:
	@-del /Q /S *.o 2>nul
	@-del /Q $(KERNEL) $(IMAGE) $(BOOTLOADER) $(ISO) 2>nul
	@-del /Q UI.c InstallerUI.c 2>nul