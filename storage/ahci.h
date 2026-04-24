#ifndef AHCI_H
#define AHCI_H

#include <stdint.h>
#include <stdbool.h>

#define AHCI_MAX_PORTS 32
#define AHCI_SECTOR_SIZE 512

typedef struct {
    uint32_t clb;
    uint32_t clbu;
    uint32_t fb;
    uint32_t fbu;
    uint32_t is;
    uint32_t ie;
    uint32_t cmd;
    uint32_t rsv0;
    uint32_t tfd;
    uint32_t sig;
    uint32_t ssts;
    uint32_t sctl;
    uint32_t serr;
    uint32_t sact;
    uint32_t ci;
    uint32_t sntf;
    uint32_t fbs;
    uint32_t rsv1[11];
    uint32_t vendor[4];
} __attribute__((packed)) hba_port_t;

typedef struct {
    uint32_t cap;
    uint32_t ghc;
    uint32_t is;
    uint32_t pi;
    uint32_t vs;
    uint32_t ccc_ctl;
    uint32_t ccc_pts;
    uint32_t em_loc;
    uint32_t em_ctl;
    uint32_t cap2;
    uint32_t bohc;
    uint8_t  rsv[0xA0 - 0x2C];
    uint8_t  vendor[0x100 - 0xA0];
    hba_port_t ports[32];
} __attribute__((packed)) hba_memory_t;

void ahci_init(void);
bool ahci_read_sector(uint32_t port, uint64_t lba, uint8_t* buffer);
bool ahci_write_sector(uint32_t port, uint64_t lba, const uint8_t* buffer);
bool ahci_is_present(uint32_t port);
uint64_t ahci_get_size(uint32_t port);

#endif