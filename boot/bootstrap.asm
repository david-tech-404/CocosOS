bits 16
global bootstrap_start
extern kernel_entry

bootstrap_start:
    cli

    in al, 0x92
    or al, 2
    out 0x92, al

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax
    jmp 0x08:pmode_entry

bits 32
pmode_entry:
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov esp, 0x90000

    call kernel_entry

.halt:
    hlt
    jmp .halt