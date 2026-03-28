org 0x7C00
bits 16

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00

    mov bx, 0x8000    
    mov ah, 0x02      
    mov al, 64        
    mov ch, 0         
    mov cl, 2         
    mov dh, 0         
    int 0x13
    jc error          

    jmp 0x0000:0x8000

error:
    hlt
    jmp error

times 510-($-$$) db 0
dw 0xAA55
