[BITS 32]
section .text

global load_page_directory
global enable_paging
global disable_paging
global flush_tlb
global flush_tlb_page
global get_cr3
global get_cr2

load_page_directory:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    mov cr3, eax
    pop ebp
    ret

enable_paging:
    mov eax, cr0
    or eax, 0x80000001
    mov cr0, eax
    ret

disable_paging:
    mov eax, cr0
    and eax, 0x7FFFFFFE
    mov cr0, eax
    ret

flush_tlb:
    mov eax, cr3
    mov cr3, eax
    ret

flush_tlb_page:
    push ebp
    mov ebp, esp
    mov eax, [ebp + 8]
    invlpg [eax]
    pop ebp
    ret

get_cr3:
    mov eax, cr3
    ret

get_cr2:
    mov eax, cr2
    ret