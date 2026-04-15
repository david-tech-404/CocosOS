#include "kernel.h"
#include "memory/memory.h"
#include "log.h"
#include "Display.h"
#include "events/event.h"
#include "terminal.h"
#include "blade.h"
#include "drivers/net/nic.h"
#include "drivers/wifi/wifi.h"

static void kernel_stage2(void);
static void kernel_run_userspace(void);

void kernel_main(void)
{
    uint8_t buffer[512];
    disk_read_sector(0, buffer);

    display_clear();
    int pos = 0;
    
    event_init();
    blade_init();
    display_print("cocos OS iniciado");
    
    log_init();
    log_info("Kernel iniciado");
    log_warn("Memoria sin mapear");
    log_error("Un driver fallo");
    
    Memory_init((void*)0x100000, 1024 * 1024);
    void* p = Memory_alloc(64);

    gdt_init();
    idt_init();
    pic_init();
    pit_init(1000);

    sti();

    kernel_stage2();
}

static void kernel_stage2(void)
{
    ramfs_init();
    mm_init();
    fs_init();
    device_init();
    
    net_init();
    wifi_init();
    
    gui_init();
    lua_init();

    kernel_run_userspace();
}

static void kernel_run_userspace(void)
{
    lua_run("kernel.lua");

    event_t e;
    while (1)
    {
        while (event_poll(&e))
        {
            switch (e.type)
            {
                case EVENT_KEY:
                    terminal_handle_key(e.data1);
                    break;

                case EVENT_MOUSE:
                    mouse_handle(e.data, e.data2);
                    break;

                case EVENT_TIMER:
                    break;
                
                default:
                    break;
            }
        }

        char c = keyboard_read();
        if (c)
        {
            display_write_char(c, 0);
        }

        asm volatile("hlt");
    }
}

void kernel_init(void)
{
    log_info("Inicializando subsistemas...");
}

void kernel_start(void)
{
    log_info("Cocos OS esta en ejecucion");
}

void internal_error_handler(void)
{
    log_error("Error critico del sistema");
    cli();
    for(;;) { asm volatile("hlt"); }
}
