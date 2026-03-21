BITS  32
SECTION .text

global ps2_read_scancode

ps2_read_scancode:
    mov dx, 0x60
    in al, dx
    ret