ENTRY(kernel_main)

SECTIONS
{
    . = 0x8200;  /* Kernel starts after bootstrap (512 bytes = 0x200) */

    .text :
    {
        *(.text*)
    }

    .data :
    {
        *(.data*)
    }

    .bss :
    {
        *(COMMON)
        *(.bss*)
    }
}
