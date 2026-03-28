global irq0_handler
extern irq0_handler_c

irq0_handler:
    pusha
    call irq0_handler_c
    popa
    iret
