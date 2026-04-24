#include "disk.h"

#define ATA_DATA 0x1F0
#define ATA_SECTOR_COUNT 0x1F2
#define ATA_LBA_LOW 0x1F3
#define ATA_LBA_MID 0x1F4
#define ATA_LBA_HIGH 0x1F5
#define ATA_DRIVE 0x1F6
#define ATA_COMMAND 0x1F7
#define ATA_STATUS 0x1F7

#define ATA_CMD_READ 0x20
#define ATA_CMD_WRITE 0x30

extern void outb(uint16_t port, uint8_t val);
extern uint8_t inb(uint16_t port);
extern uint16_t inw(uint16_t port);
extern void outw(uint16_t port, uint16_t val);

static void ata_wait() {
    while (inb(ATA_STATUS) & 0x80);
}

void disk_init() {    
}

int disk_read_sector(uint32_t lba, uint8_t *buffer) {

    ata_wait();

    outb(ATA_DRIVE, 0xE0 | ((lba >> 24) & 0x0F));
    outb(ATA_SECTOR_COUNT, 1);

    outb(ATA_LBA_LOW, (uint8_t)lba);
    outb(ATA_LBA_MID, (uint8_t)(lba >> 8));

    outb(ATA_LBA_HIGH, (uint8_t)(lba >> 16));

    outb(ATA_COMMAND, ATA_CMD_READ);

    ata_wait();

    for (int i = 0; i < 256; i++) {
        ((uint16_t*)buffer)[i] = inw(ATA_DATA);
    }

    return 1;
 
}

int disk_write_sector(uint32_t lba, uint8_t *buffer) {

    ata_wait(); outb(ATA_DRIVE, 0xE0 | ((lba >> 24) & 0x0F));
    outb(ATA_SECTOR_COUNT, 1);

    outb(ATA_LBA_LOW, (uint8_t)lba);
    outb(ATA_LBA_MID, (uint8_t)(lba >> 8));
    outb(ATA_LBA_HIGH, (uint8_t)(lba >> 16));

    outb(ATA_COMMAND, ATA_CMD_WRITE);

    ata_wait();

    for (int i = 0; i < 256; i++) {
        outw(ATA_DATA,((uint16_t*)buffer)[i]);
    }

    return 1;
}