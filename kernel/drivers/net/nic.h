#ifndef NIC_H
#define NIC_H

#include <stdint.h>
#include <stdbool.h>

#define MAC_ADDR_LEN 6
#define ETH_FRAME_MAX 1518

typedef struct {
    uint8_t bytes[MAC_ADDR_LEN];
} mac_addr_t;

typedef struct nic_device {
    char* name;
    mac_addr_t mac;
    bool initialized;
    bool link_up;
    
    int (*init)(struct nic_device* dev);
    int (*send)(struct nic_device* dev, uint8_t* buffer, uint32_t len);
    int (*recv)(struct nic_device* dev, uint8_t* buffer, uint32_t max_len);
    void (*irq_handler)(struct nic_device* dev);
    
    struct nic_device* next;
} nic_device_t;

void net_init(void);
int  nic_register(nic_device_t* dev);
nic_device_t* nic_get_default(void);
int  net_send_frame(uint8_t* dest_mac, uint16_t ethertype, uint8_t* payload, uint32_t len);
void net_poll(void);

#define ETHERTYPE_IPV4 0x0800
#define ETHERTYPE_ARP  0x0806
#define ETHERTYPE_IPV6 0x86DD

#endif
