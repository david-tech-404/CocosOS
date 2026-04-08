#ifndef KERNEL_H
#define KERNEL_H
#include <stdint.h>
#include <stddef.h>
void kernel_main(void);
void kmain(void);
void kernel_init(void);
void kernel_start(void);
void internal_error_handler(void);
void gdt_init(void);
void idt_init(void);
void pic_init(void);
void pit_init(uint32_t frequency);
void sti(void);
void cli(void);
void Memory_init(void* start, size_t size);
void* Memory_alloc(size_t size);
void Memory_free(void* ptr);
void ramfs_init(void);
void mm_init(void);
void fs_init(void);
void device_init(void);
void gui_init(void);
void lua_init(void);
void display_clear(void);
void display_print(const char* str);
void display_write_char(char c, int color);
void event_init(void);
void blade_init(void);
void terminal_handle_key(char c);
void mouse_handle(int x, int y);
char keyboard_read(void);
void disk_read_sector(uint32_t sector, uint8_t* buffer);
#endif