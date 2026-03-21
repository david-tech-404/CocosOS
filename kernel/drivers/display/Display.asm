BITS 32

SECTION .text

global display_clear
global display_write_char

display_clear:
    mov edi, 0xB8000
    mov ecx, 80*25
    mov ax, 0x0720
.clear_loop:
    mov [edi], ax
    add edi, 2
    loop .clear_loop
    ret

display_write_char:
    mov edi, 0xB8000
    mov eax, ecx
    shl eax, 1
    add edi, eax
    mov ah, 0x07
    mov [edi], ax
    ret