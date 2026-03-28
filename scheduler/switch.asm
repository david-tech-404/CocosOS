global context_switch

context_switch:
    mov eax, [esp + 4]
    mov edx, [esp + 8]
    mov [eax], esp
    ret
