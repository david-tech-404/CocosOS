org 0x7C00
bits 16
start:
cli
cld
xor ax, ax
mov ds, ax
mov es, ax
mov ss, ax
mov sp, 0x7B00
in al, 0x92
or al, 2
out 0x92, al
mov cx, 3
.disk_loop:
mov bx, 0x8000
mov ah, 0x02
mov al, 127
mov ch, 0
mov cl, 2
mov dh, 0
int 0x13
jnc .ok
dec cx
jnz .disk_loop
jmp error
.ok:
jmp 0x0000:0x8000
error:
hlt
jmp error
times 510-($-$$) db 0
dw 0xAA55
