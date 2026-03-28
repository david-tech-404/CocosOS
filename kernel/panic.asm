global kernel_panic
extern kernel_panic_state
extern kernel_panic_code

kernel_panic:
    cli
    mov dword [kernel_panic_state], 1
    mov dword [kernel_panic_code], edi

.halt:
    hlt
    jmp .halt

global arch_disable_interrupts

arch_disable_interrupts:
    cli
    ret
